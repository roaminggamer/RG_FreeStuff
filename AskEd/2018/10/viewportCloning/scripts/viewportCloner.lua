-- =============================================================
-- Viewport Cloner
-- =============================================================
local vcloner = {}
-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua & Corona Functions
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs; local mFloor = math.floor; local mCeil = math.ceil
local strGSub = string.gsub; local strSub = string.sub
-- Common SSK Features
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
local RGTiled = ssk.tiled; local files = ssk.files
local factoryMgr = ssk.factoryMgr; local soundMgr = ssk.soundMgr
--if( ssk.misc.countLocals ) then ssk.misc.countLocals(1) end

local mRand = math.random

local debugEn = false

local views = {}
local clones = {}
local peers = {}

vcloner.start = function()
	clones.enterFrame = function( self )
		--vcloner:purge()
		vcloner:update()
	end; listen( "enterFrame", clones )
end

vcloner.purge = function()
	local toRemove = {}
	for i = 1, #clones do
		local clone = clones[i]
		if( clone.removeSelf == nil or clone.peer.removeSelf == nil ) then
			toRemove[#toRemove+1] = clone				
		end
	end
	for i = 1, #toRemove do
		table.removeByRef( clones, toRemove[i] )
		display.remove(toRemove[i])
	end
end

vcloner.update = function( )
	for i = 1, #clones do
		local clone = clones[i]
		if( clone.removeSelf ~= nil or clone.peer.removeSelf ~= nil ) then
			local peer = clone.peer
			clone.x = peer.x
			clone.y = peer.y
			clone.rotation = peer.rotation
		end
	end
end


vcloner.update = function( )
	for i = 1, #peers do
		local peer = peers[i]
		if( peer._lx ) then
			local dx = peer.x - peer._lx
			local dy = peer.y - peer._ly

			if( d0 ~= 0 or dy ~= 0 or peer.rotation ~= peer.lr ) then
				local clones = peer.myClones
				for j = 1, #clones do
					local clone = clones[j]
					clone:translate(dx,dy)
					clone.rotation = peer.rotation
				end
				peer._lx = peer.x
				peer._ly = peer.y
				peer._lr = peer.rotation
			end
		else
			peer._lx = peer.x
			peer._ly = peer.y
			peer._lr = peer.rotation
		end
	end

	for i = 1, #clones do
		local clone = clones[i]
		if( clone.removeSelf ~= nil or clone.peer.removeSelf ~= nil ) then
			local peer = clone.peer
			clone.x = peer.x
			clone.y = peer.y
			clone.rotation = peer.rotation
		end
	end
end

vcloner.stop = function( )
	ignore( "enterFrame", clones )
end

vcloner.reset = function()	
	while #clones > 0 do
		table.removeByRef(clones[1])
	end
	while #views > 0 do
		table.removeByRef(views[1])
	end
end

vcloner.newCircle = function( group, x, y, visualParams, bodyParams )
	local peer = newCircle( views[1].view, x, y, visualParams, bodyParams )
	local myClones = {}
	peer.myClones = {}
	peers[#peers+1] = peer
	for i = 2, #views do
		local clone = newCircle( views[i].view, x, y, visualParams )
		clone.peer = peer
		clones[#clones+1] = clone
		myClones[#myClones+1] = clone

		if(debugEn) then
			clone:setFillColor(unpack(_P_))
		end
	end
	return peer
end

vcloner.newRect = function( group, x, y, visualParams, bodyParams )
	local peer = newRect( views[1].view, x, y, visualParams, bodyParams )		
	local myClones = {}
	peer.myClones = {}
	peers[#peers+1] = peer
	for i = 2, #views do
		local clone = newRect( views[i].view, x, y, visualParams )
		clone.peer = peer
		clones[#clones+1] = clone
		myClones[#myClones+1] = clone

		if(debugEn) then
			clone:setFillColor(unpack(_P_))
		end
	end
	return peer
end

vcloner.newImageRect = function( group, x, y, imgSrc, visualParams, bodyParams )
	local peer = newImageRect( views[1].view, x, y, imgSrc, visualParams, bodyParams )		
	local myClones = {}
	peer.myClones = {}
	peers[#peers+1] = peer
	for i = 2, #views do
		local clone = newImageRect( views[i].view, x, y, imgSrc, visualParams )
		clone.peer = peer
		clones[#clones+1] = clone
		myClones[#myClones+1] = clone

		if(debugEn) then
			clone:setFillColor(unpack(_P_))
		end
	end
	return peer
end

vcloner.newSprite = function( group, x, y, sheet, sequence )
	local peer = newSprite( views[1].view, sheet, sequence )
	local myClones = {}
	peer.myClones = {}
	peer.x = x
	peer.y = y
	peer:play()
	for i = 2, #views do
		local clone = newSprite( views[i].view, sheet, sequence )
		clone.peer = peer
		clones[#clones+1] = clone
		myClones[#myClones+1] = clone

		clone:play()
		clone.x = x
		clone.y = y

		if(debugEn) then
			clone:setFillColor(unpack(_P_))
		end
	end
	return peer
end


vcloner.createView = function( group, x, y, width, height, strokeColor )
	group = group or display.currentStage

	strokeColor = strokeColor or _B_
	local container = display.newContainer( group, width, height )
	container.x = x
	container.y = y

	local view = display.newGroup()
	container:insert(view)

	local frame = newRect( container, 0, 0, 
		                   { w = width, h = height, fill = _T_, 
		                   stroke = strokeColor, strokeWidth = 2})

	container.view = view
	container.frame = frame

	container.translateView = function( self, ox, oy )
		view.x = -ox
		view.y = -oy
	end

	container.moveBy = function( self, dx, dy, autoTranslate )
		self.x = self.x + dx
		self.y = self.y + dy
		--self.frame.x = self.x
		--self.frame.y = self.y
		if( autoTranslate == true ) then
			self:translateView( dx, dy )
		end
	end

	views[#views+1] = container

	return container
end

vcloner.createViews = function( group, x, y, params )
	group = group or display.currentStage
	
	local width 	= params.w
	local height 	= params.h
	local vwidth	= params.vw
	local vheight	= params.vh
	local frameFill = params.frameFill or _T_

	local rows = height/vheight
	local cols = width/vwidth

	local numViews = rows * cols

	local views = {}

	views[1]	= vcloner.createView( group, x, y, width, height, frameFill )

	for i = 1, numViews do
		views[i+1]	= vcloner.createView( group, x, y, vwidth, vheight, frameFill )
	end

	local sx = x - width/2  + vwidth/2
	local sy = y - height/2 + vheight/2

	print(x,y,sx,sy)

	local ox = sx
	local oy = sy

	local curView = 2

	for i = 1, rows do
		for j = 1, cols do
			views[curView]:moveBy( x - ox, y-oy, true )
			ox = ox + vwidth
			curView = curView + 1
		end
		ox = sx
		oy = oy + vheight
	end

	return views
end

vcloner.swapViews = function( objA, objB )
	local x = objA.x
	local y = objA.y
	objA.x = objB.x
	objA.y = objB.y
	objB.x = x
	objB.y = y
end

vcloner.randomize = function()
	for i = 1, #views * #views do
		vcloner.swapViews( views[mRand(2,#views)], views[mRand(2,#views)])
	end
end

--[[
vcloner.swapViews = function( objA, objB, delay, time )
	local x = objA.x
	local y = objA.y
	transition.to( objA, { delay = delay, time = time, x = objB.x, y = objB.y } )
	transition.to( objB, { delay = delay, time = time, x = x, y = y } )
end
vcloner.randomize = function(delay)
	delay = delay or 2000

	local toSwap = {}
	for i = 2, #views do
		toSwap[#toSwap+1] = i
	end
	toSwap = table.shuffle(toSwap)
	for i = 1, #toSwap, 2 do		
		if(toSwap[i+1] ~= nil) then
			print(toSwap[i],toSwap[i+1])
			local from = toSwap[i]
			local to = toSwap[i+1]
			vcloner.swapViews( views[from], views[to], delay + i * 100, 1000 )
		end
	end
end
--]]

vcloner.setInitialPositions = function()
	for i = 2, #views do
		views[i]._ix = views[i].x
		views[i]._iy = views[i].y
	end
end

return vcloner