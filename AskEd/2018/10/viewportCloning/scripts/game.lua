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

local rotateAbout

local examples = {}

local game = {}

-- Initialize the game
--
function game.init( group )
end

-- Stop, cleanup, and destroy the game.;
--
function game.cleanup( )
	game.isRunning = false

	local physics = require("physics")
	physics.setDrawMode( "normal" )
	physics.stop()
end

-- Run the Game
--
function game.run( group, exampleNum )
	group = group or display.currentStage
	game.isRunning = true		
	local physics = require("physics")
	physics.start()
	physics.setGravity(0,9.8)
	--physics.setDrawMode( "hybrid" )

	-- Localizations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC
	local mRand 		= math.random

	-- Locals
	--
	----examples[8]()
	examples[exampleNum or 1]()
end


local function vecScale( x, y, s )
   return x *s, y * s
end

local function angle2Vec( angle )
    local screenAngle = math.rad( -(angle+90) )
    return -math.cos( screenAngle ), math.sin( screenAngle )
end

rotateAbout = function( obj, x, y, params  )	
    
    x = x or display.contentCenterX
	y = y or display.contentCenterY
	params = params or {}
    
    local radius 		= params.radius or 50
	obj._pathRot 		= params.startA or 0
	local endA 			= params.endA or (obj._pathRot + 360 )
	local time 			= params.time or 1000
	local myEasing 		= params.myEasing or easing.linear
	local debugEn 		= params.debugEn
	local delay 		= params.delay
	local onComplete 	= params.onComplete
	local update 		= params.update

	-- Start at right position
	local vx,vy = angle2Vec( obj._pathRot )
	vx,vy = vecScale( vx, vy, radius )
	obj.x = x + vx 
	obj.y = y + vy

    -- remove 'enterFrame' listener when we finish the transition.
	obj.onComplete = function( self )	
		Runtime:removeEventListener( "enterFrame", self )
		if( onComplete ) then onComplete( self ) end
	end

	-- Update position every frame
	obj.enterFrame = function ( self )
		local vx,vy = angle2Vec( self._pathRot )
		vx,vy = vecScale( vx, vy, radius )
		self.x = x + vx 
		self.y = y + vy

		if(update) then
			update( self, obj._pathRot )
		end

		if( debugEn ) then
			local tmp = display.newCircle( self.parent, self.x, self.y, 1 )
			tmp:toBack()
		end
	end
	Runtime:addEventListener( "enterFrame", obj )

	-- Use transition to change the angle (gives us access to nice effects)
	transition.to( obj, { _pathRot = endA, delay = delay, time = time, transition = myEasing, onComplete = obj } )
end


rotateAbout = function( obj, x, y, params  )	
    
    x = x or display.contentCenterX
	y = y or display.contentCenterY
	params = params or {}
    
    local radius 		= params.radius or 50
	obj._pathRot 		= params.startA or 0
	local endA 			= params.endA or (obj._pathRot + 360 )
	local time 			= params.time or 1000
	local myEasing 		= params.myEasing or easing.linear
	local debugEn 		= params.debugEn
	local delay 		= params.delay
	local onComplete 	= params.onComplete
	local update 		= params.update

	-- Start at right position
	local vx,vy = angle2Vec( obj._pathRot )
	vx,vy = vecScale( vx, vy, radius )
	obj.x = x + vx 
	obj.y = y + vy

    -- remove 'enterFrame' listener when we finish the transition.
	obj.onComplete = function( self )	
		Runtime:removeEventListener( "enterFrame", self )
		if( onComplete ) then onComplete( self ) end
	end

	-- Update position every frame
	obj.enterFrame = function ( self )
		local vx,vy = angle2Vec( self._pathRot )
		vx,vy = vecScale( vx, vy, radius )
		self.x = x + vx 
		self.y = y + vy

		if(update) then
			update( self, obj._pathRot )
		end

		if( debugEn ) then
			local tmp = display.newCircle( self.parent, self.x, self.y, 1 )
			tmp:toBack()
		end
	end
	Runtime:addEventListener( "enterFrame", obj )

	-- Use transition to change the angle (gives us access to nice effects)
	transition.to( obj, { _pathRot = endA, delay = delay, time = time, transition = myEasing, onComplete = obj } )
end

-----------------------------------------------------------------

examples[1] = function( params )
	local _newCircle         = newCircle
	local _newRect           = newRect
	local _newImageRect      = newImageRect

	local debugEn = false

	local colors = { _R_, _G_, _B_, _Y_, _O_, _P_ }
	local views = {}
	local clones = {}

	clones.start = function( self )
		self.enterFrame = function( self )
			self:purge()
			self:update()
		end; listen( "enterFrame", clones )
	end

	clones.purge = function( self )
		local toRemove = {}
		for i = 1, #self do
			local clone = self[i]
			if( clone.removeSelf == nil or clone.peer.removeSelf == nil ) then
				toRemove[#toRemove+1] = clone				
			end
		end
		for i = 1, #toRemove do
			table.removeByRef( self, toRemove[i] )
			display.remove(toRemove[i])
		end
	end

	clones.update = function( self )
		for i = 1, #self do
			local clone = self[i]
			if( clone.removeSelf ~= nil or clone.peer.removeSelf ~= nil ) then
				clone.x = clone.peer.x
				clone.y = clone.peer.y
				clone.rotation = clone.peer.rotation
			end
		end
	end

	clones.stop = function( self )
		ignore( "enterFrame", self )
	end

	local newCircle = function( group, x, y, visualParams, bodyParams )
		local peer = _newCircle( views[1].view, x, y, visualParams, bodyParams )
		for i = 2, #views do
			local clone = _newCircle( views[i].view, x, y, visualParams )
			clone.peer = peer
			clones[#clones+1] = clone

			if(debugEn) then
				clone:setFillColor(unpack(_P_))
			end
		end
		return peer
	end

	local newRect = function( group, x, y, visualParams, bodyParams )
		local peer = _newRect( views[1].view, x, y, visualParams, bodyParams )		
		for i = 2, #views do
			local clone = _newRect( views[i].view, x, y, visualParams )
			clone.peer = peer
			clones[#clones+1] = clone

			if(debugEn) then
				clone:setFillColor(unpack(_P_))
			end
		end
		return peer
	end

	local newImageRect = function( group, x, y, imgSrc, visualParams, bodyParams )
		local peer = _newImageRect( views[1].view, x, y, imgSrc, visualParams, bodyParams )		
		for i = 2, #views do
			local clone = _newImageRect( views[i].view, x, y, imgSrc, visualParams )
			clone.peer = peer
			clones[#clones+1] = clone

			if(debugEn) then
				clone:setFillColor(unpack(_P_))
			end
		end
		return peer
	end

	local createView = function( group, x, y, size, strokeColor )
		group = group or display.currentStage

		strokeColor = strokeColor or _B_
		local container = display.newContainer( group, size, size )
		container.x = x
		container.y = y

		local view = display.newGroup()
		container:insert(view)

		local frame = _newRect( container, 0, 0, 
			                   { size = size, fill = _T_, 
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

		return container
	end

	local viewSize = 120
	local radius = 10
	local buffer = 0
	local frameOffset = (viewSize/2 + 5)
	local oy = - viewSize/2
	
	--views[1]	= createView( nil, centerX - 125, centerY, viewSize, colors[1] )
	--views[2]	= createView( nil, centerX + 125, centerY, viewSize, colors[2] )

	views[1]	= createView( nil, centerX - 100, centerY, viewSize, _W_ )
	views[2]	= createView( nil, centerX + 100, centerY, viewSize/3, _P_ )
	views[3]	= createView( nil, centerX + 100, centerY, viewSize/3, _P_ )
	views[4]	= createView( nil, centerX + 100, centerY, viewSize/3, _P_ )
	views[5]	= createView( nil, centerX + 100, centerY, viewSize/3, _P_ )
	views[6]	= createView( nil, centerX + 100, centerY, viewSize/3, _P_ )
	views[7]	= createView( nil, centerX + 100, centerY, viewSize/3, _P_ )
	views[8]	= createView( nil, centerX + 100, centerY, viewSize/3, _P_ )
	views[9]	= createView( nil, centerX + 100, centerY, viewSize/3, _P_ )
	views[10]	= createView( nil, centerX + 100, centerY, viewSize/3, _P_ )


	local function mover( self ) 
		if( self.removeSelf == nil ) then
			ignore("enterFrame",self)
			return
		end
		if( self.x > 100 ) then 
			self.dx = -self.bdx
		elseif( self.x < -100 ) then
			self.dx = self.bdx
		end
		self.x = self.x + self.dx
	end; 

	-- Background
	local tmp = newImageRect( nil, 0, 0, "images/bg2.png", { w = 757/4, h = 599/4 } )

	--[[
	-- Circle test
	local tmp = newCircle( nil, 0, 0, { radius = 10, fill = _B_ }, {} )
	tmp.bdx = 4
	tmp.dx = -tmp.bdx
	tmp.enterFrame = mover
	listen("enterFrame", tmp)

	-- Rectangle test
	local tmp = newRect( nil, 0, -50, { size = 20, fill = _G_ } )
	tmp.bdx = 3
	tmp.dx = tmp.bdx
	tmp.enterFrame = mover
	listen("enterFrame", tmp)
	--]]

	-- Image Rectangle test
	local tmp = newImageRect( nil, 0, 30, "images/smiley.png", { size = 20 } )
	tmp.bdx = 3
	tmp.dx = tmp.bdx
	tmp.enterFrame = mover
	listen("enterFrame", tmp)		

	-- Image Rectangle test
	local tmp = newImageRect( nil, 0, -10, "images/smiley.png", { size = 20 } )
	tmp.bdx = 2
	tmp.dx = -tmp.bdx
	tmp.enterFrame = mover
	listen("enterFrame", tmp)		

	--views[2]:moveBy( -12.5, -20, true )
	--views[2]:moveBy( 0, -50 )

	local function swap( objA, objB )
		local x = objA.x
		local y = objA.y
		objA.x = objB.x
		objA.y = objB.y
		objB.x = x
		objB.y = y
	end

	views[2]:moveBy( -40, -40, true )
	views[3]:moveBy( -40,   0, true )
	views[4]:moveBy( -40,  40, true )

	views[5]:moveBy( 0, -40, true )
	views[6]:moveBy( 0,   0, true )
	views[7]:moveBy( 0,  40, true )

	views[8]:moveBy( 40, -40, true )
	views[9]:moveBy(  40,   0, true )
	views[10]:moveBy( 40,  40, true )

	views[2]:moveBy( -20, -20, false )
	views[3]:moveBy( -20,   0, false )
	views[4]:moveBy( -20,  20, false )

	views[5]:moveBy( 0, -20, false )
	views[6]:moveBy( 0,   0, false )
	views[7]:moveBy( 0,  20, false )

	views[8]:moveBy( 20, -20, false )
	views[9]:moveBy(  20,   0, false )
	views[10]:moveBy( 20,  20, false )

	for i = 1, 100 do
		swap( views[mRand(2,10)], views[mRand(2,10)])
	end

	for i = 2, 10 do
		views[i].rotation = mRand(-15, 15)
	end

	--views[2].rotation = 15

	views[6]:scale(1.5, 1.5)
	
	--views[1].isVisible = false

	-- must be done last (after all other enterframes that modify peer objects)
	clones:start()

	-- test auto purge
	--timer.performWithDelay( 1000, function() display.remove( tmp ) end )
end


--
-- EFM
--
examples[2] = function( params )
	local vcloner = require "scripts.viewportCloner"

	local newCircle         = vcloner.newCircle
	local newRect           = vcloner.newRect
	local newImageRect      = vcloner.newImageRect
	local createView		= vcloner.createView
	local swap 				= vcloner.swapViews


	local mainViewWidth = 120
	local mainViewHeight = 120
	local subViewSize = 30

	local views = {}

	views[1]	= createView( nil, centerX - 100, centerY, mainViewWidth, mainViewHeight, _W_ )
	views[2]	= createView( nil, centerX + 100, centerY, subViewSize, subViewSize, _P_ )
	views[3]	= createView( nil, centerX + 100, centerY, subViewSize, subViewSize, _P_ )
	views[4]	= createView( nil, centerX + 100, centerY, subViewSize, subViewSize, _P_ )
	views[5]	= createView( nil, centerX + 100, centerY, subViewSize, subViewSize, _P_ )
	views[6]	= createView( nil, centerX + 100, centerY, subViewSize, subViewSize, _P_ )
	views[7]	= createView( nil, centerX + 100, centerY, subViewSize, subViewSize, _P_ )
	views[8]	= createView( nil, centerX + 100, centerY, subViewSize, subViewSize, _P_ )
	views[9]	= createView( nil, centerX + 100, centerY, subViewSize, subViewSize, _P_ )
	views[10]	= createView( nil, centerX + 100, centerY, subViewSize, subViewSize, _P_ )


	local function mover( self ) 
		if( self.removeSelf == nil ) then
			ignore("enterFrame",self)
			return
		end
		if( self.x > 100 ) then 
			self.dx = -self.bdx
		elseif( self.x < -100 ) then
			self.dx = self.bdx
		end
		self.x = self.x + self.dx
	end; 

	-- Background
	local tmp = newImageRect( nil, 0, 0, "images/bg2.png", { w = 757/4, h = 599/4 } )

	-- Smiley
	local tmp = newImageRect( nil, 0, 30, "images/smiley.png", { size = 20 } )
	tmp.bdx = 3
	tmp.dx = tmp.bdx
	tmp.enterFrame = mover
	listen("enterFrame", tmp)		


	views[2]:moveBy( -40, -40, true )
	views[3]:moveBy( -40,   0, true )
	views[4]:moveBy( -40,  40, true )

	views[5]:moveBy( 0, -40, true )
	views[6]:moveBy( 0,   0, true )
	views[7]:moveBy( 0,  40, true )

	views[8]:moveBy( 40, -40, true )
	views[9]:moveBy(  40,   0, true )
	views[10]:moveBy( 40,  40, true )

	views[2]:moveBy( -20, -20, false )
	views[3]:moveBy( -20,   0, false )
	views[4]:moveBy( -20,  20, false )

	views[5]:moveBy( 0, -20, false )
	views[6]:moveBy( 0,   0, false )
	views[7]:moveBy( 0,  20, false )

	views[8]:moveBy( 20, -20, false )
	views[9]:moveBy(  20,   0, false )
	views[10]:moveBy( 20,  20, false )

	for i = 1, 100 do
		swap( views[mRand(2,10)], views[mRand(2,10)])
	end

	for i = 2, 10 do
		views[i].rotation = mRand(-15, 15)
	end

	--views[6]:scale(1.5, 1.5)
	--views[1].isVisible = false

	-- must be done last (after all other enterframes that modify peer objects)
	vcloner:start()

	-- test auto purge
	--timer.performWithDelay( 1000, function() display.remove( tmp ) end )
end

--
-- EFM
--
examples[3] = function( params )
	local vcloner = require "scripts.viewportCloner"

	local newCircle         = vcloner.newCircle
	local newRect           = vcloner.newRect
	local newImageRect      = vcloner.newImageRect
	local createViews		= vcloner.createViews
	local swap 				= vcloner.swapViews

	local mainViewWidth = 450
	local mainViewHeight = 300
	local subViewSize = 50

	local views = createViews( nil, centerX, centerY, { w = 480, h = 320, vw = 80, vh = 80 } )

	local function mover( self ) 
		if( self.removeSelf == nil ) then
			ignore("enterFrame",self)
			return
		end
		if( self.x > 100 ) then 
			self.dx = -self.bdx
		elseif( self.x < -100 ) then
			self.dx = self.bdx
		end
		self.x = self.x + self.dx
	end; 

	-- Background
	local tmp = newImageRect( nil, 0, 0, "images/sample.png", { w = 592, h = 320 } )

	-- Smiley
	local tmp = newImageRect( nil, 0, 30, "images/smiley.png", { size = 20 } )
	tmp.bdx = 3
	tmp.dx = tmp.bdx
	tmp.enterFrame = mover
	listen("enterFrame", tmp)		

	--vcloner.randomize()

	--[[
	for i = 2, #views do
		views[i]:scale(0.8, 0.8)
		views[i].rotation = mRand(-15, 15)
		views[i].isVisible = false
	end
	--]]

	views[1].isVisible = false

	--views[6]:scale(1.5, 1.5)
	

	-- must be done last (after all other enterframes that modify peer objects)
	vcloner:start()

	-- test auto purge
	--timer.performWithDelay( 1000, function() display.remove( tmp ) end )
	--]]
end

--
-- EFM
--
examples[4] = function( params )
	local vcloner = require "scripts.viewportCloner"

	local colors = { _R_, _G_, _B_, _Y_, _O_, _P_ }

	local newCircle         = vcloner.newCircle
	local newRect           = vcloner.newRect
	local newImageRect      = vcloner.newImageRect
	local createViews		= vcloner.createViews
	local swap 				= vcloner.swapViews

	local bw = 384
	local bh = 384

	local views = createViews( nil, centerX, centerY, { w = bw, h = bh, vw = 96, vh = 96 } )

	-- Background
	local sx = -bw/2 + 16
	local sy = -bh/2 + 16
	local x = sx
	local y = sy
	local count = 1

	for i = 1, 12 do
		for j = 1, 16 do			
			local tmp = newImageRect( nil, x, y, "images/water.png", { w = 32, h = 32 } )
			x = x + 32
			count = count+1
			if(count>#colors) then
				count = 1
			end
		end
		x = sx
		y = y + 32
	end


	local function update( obj, angle )
		obj.rotation = angle + 90
	end

	-- Plane 1
	local plane = newImageRect( nil, 0, 0, "images/plane.png", { w = 64, h = 64 } )
	local function onComplete( self )
		rotateAbout( self, 60, 0, { onComplete = onComplete, update = update, radius = 55, time = 3000 } )
	end
	rotateAbout( plane, 60, 0, { debugEn = true, onComplete = onComplete, radius = 55, time = 3000, update = update } )

	-- Plane 2
	local plane = newImageRect( nil, 0, 0, "images/plane2.png", { w = 32, h = 32, yScale = -1 } )
	local function onComplete( self )
		rotateAbout( self, -60, 0, { onComplete = onComplete, update = update, radius = 55, time = 2000, endA = -360 } )
	end
	rotateAbout( plane, -60, 0, { debugEn = true, onComplete = onComplete, radius = 55, time = 2000, endA = -360, update = update } )


	-- Plane 3
	local plane = newImageRect( nil, 0, 0, "images/plane3.png", { w = 32, h = 32 } )
	local function onComplete( self )
		rotateAbout( self, 0, 0, { onComplete = onComplete, update = update, radius = 55, time = 5000 } )
	end
	rotateAbout( plane, 0, 0, { debugEn = true, onComplete = onComplete, radius = 55, time = 5000, update = update } )


	vcloner.setInitialPositions()
	--vcloner.randomize()

	----[[
	for i = 2, #views do
		views[i]:scale(0.95, 0.95)
		views[i].rotation = mRand(-5, 5)
		--transition.to( views[i], { delay = 3000, time = 1000, rotation = mRand(-5, 5), xScale = 0.95, yScale = 0.95 } )
		--views[i].isVisible = false
	end
	--]]

	views[1].isVisible = false

	--views[6]:scale(1.5, 1.5)
	

	-- must be done last (after all other enterframes that modify peer objects)
	vcloner:start()

	-- test auto purge
	--timer.performWithDelay( 1000, function() display.remove( tmp ) end )
	--]]


	-- ==
	--    isInBounds( obj, obj2 ) - Is the center of obj over obj2 (inside its axis aligned bounding box?)
	-- ==
	local function isInBounds( obj, obj2 )

		if(not obj2) then return false end

		local bounds = obj2.contentBounds
		if( obj.x > bounds.xMax ) then return false end
		if( obj.x < bounds.xMin ) then return false end
		if( obj.y > bounds.yMax ) then return false end
		if( obj.y < bounds.yMin ) then return false end
		return true
	end	

	local function onTouch( self, event )
		local phase = event.phase

		if( phase == "began" ) then
			self.isFocus = true
			display.currentStage:setFocus( event.target, event.id )
			self._x0 = self.x
			self._y0 = self.y

		elseif( self.isFocus ) then
			if( phase == "ended" or phase == "cancelled" ) then
				self.isFocus = false
				display.currentStage:setFocus( event.target, nil )

				for i = 2, #views do
					if(views[i] ~= self) then
						if( isInBounds( event, views[i] ) ) then
							--views[i].rotation = 0
							transition.to( self, { x = views[i].x, y = views[i].y, time = 250 } )
							transition.to( views[i], { x = self._x0, y = self._y0, time = 500 } )

						end
					end
				end

			end
			local dx = event.x - event.xStart
			local dy = event.y - event.yStart

			self.x = self._x0 + dx
			self.y = self._y0 + dy
		end
		return false
	end

	for i = 2, #views do
		views[i].touch = onTouch
		views[i]:addEventListener("touch")
	end
end

--
-- EFM
--
examples[5] = function( params )
	local vcloner = require "scripts.viewportCloner"

	local colors = { _R_, _G_, _B_, _Y_, _O_, _P_ }

	local newCircle         = vcloner.newCircle
	local newRect           = vcloner.newRect
	local newImageRect      = vcloner.newImageRect
	local createViews		= vcloner.createViews
	local swap 				= vcloner.swapViews

	local views = createViews( nil, centerX+80, centerY, { w = 320, h = 320, vw = 80, vh = 80 } )

	-- Background
	local tmp = newImageRect( nil, x, y, "images/sample.png", { w = 592 * 320/300, h = 320 } )

	vcloner.setInitialPositions()
	vcloner.randomize()

	----[[
	for i = 2, #views do
		views[i]:scale(0.95, 0.95)
		views[i].rotation = mRand(-5, 5)
		views[i].isVisible = false
	end
	--]]
	views[1].isVisible = false
	vcloner:start()
end




examples[6] = function()
	--local tmp = newImageRect( nil, centerX, centerY , "images/bg2.png", { w = 450, h = 350 } )
	--local tmp = newImageRect( nil, centerX, centerY , "images/bg2.png", { w = 450, h = 350 } )
	local tmp = newImageRect( nil, right - 10, centerY , "images/bg2.png", { w = 450, h = 350, anchorX = 1 } )
	--local tmp = newImageRect( nil, centerX, centerY, "images/bg2.png", { w = 1024, h = 768 } )
end

--
-- EFM
--
examples[7] = function( params )
	local vcloner = require "scripts.viewportCloner"

	local colors = { _R_, _G_, _B_, _Y_, _O_, _P_ }

	local newCircle         = vcloner.newCircle
	local newRect           = vcloner.newRect
	local newImageRect      = vcloner.newImageRect
	local createViews		= vcloner.createViews
	local swap 				= vcloner.swapViews

	local bw = 384
	local bh = 384

	local views = createViews( nil, centerX, centerY, { w = bw, h = bh, vw = 96, vh = 96 } )

	-- Background
	local sx = -bw/2 + 16
	local sy = -bh/2 + 16
	local x = sx
	local y = sy
	local count = 1




	local options = 
	{
		-- Required params
		frames = {
			{
				x = 64*0,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*1,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*2,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*3,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*4,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*5,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*6,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*7,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*8,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*9,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*10,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*11,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*12,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*13,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*14,
				y = 0,
				width = 64,
				height = 64,
			},
			{
				x = 64*15,
				y = 0,
				width = 64,
				height = 64,
			},
		},

		-- content scaling
		sheetContentWidth = 1024,
		sheetContentHeight = 1024,
	}

	-- (2) Generate the remaining 256 frames programatically:
	-- Instead of typing them all out, we just duplicate the first row 15 more times,
	-- adjusting the y value as necessary.
	local frames = options.frames
	for j=1,15 do
		for i=1,16 do
			local src = frames[i]
			local element = {
				x = src.x,
				y = 64 * j,
				width = src.width,
				height = src.height,
			}
			table.insert( frames, element )
		end
	end

	local sheet = graphics.newImageSheet( "images/dancers.png", options )

	local sequenceData = {}



	local function createTiles( x, y )
		local xStart = x
		
		local dancer = "dancer" .. 4
		local numFrames = 16
		local start = mRand(1,10) * 16 + 1
		local sequence = { name=dancer, start=start, count=numFrames, loopDirection="bounce" }

		local sprite

		--sprite = display.newSprite( sheet, sequence )
		sprite = vcloner.newSprite( nil, x, y, sheet, sequence )

		--sprite.x = x
		--sprite.y = y
		--sprite:play()
	end


	for i = 1, 10 do
		createTiles( mRand(sx, sx+bw), mRand(sy, sy+bh) )
	end


	vcloner.setInitialPositions()
	vcloner.randomize()

	----[[
	for i = 2, #views do
		views[i]:scale(0.95, 0.95)
		views[i].rotation = mRand(-5, 5)
		--transition.to( views[i], { delay = 3000, time = 1000, rotation = mRand(-5, 5), xScale = 0.95, yScale = 0.95 } )
		--views[i].isVisible = false
	end
	--]]

	views[1].isVisible = false

	--views[6]:scale(1.5, 1.5)
	

	-- must be done last (after all other enterframes that modify peer objects)
	--vcloner:start()

	-- test auto purge
	--timer.performWithDelay( 1000, function() display.remove( tmp ) end )
	--]]
end


--
-- EFM
--
examples[8] = function( params )
	local vcloner = require "scripts.viewportCloner"

	local colors = { _R_, _G_, _B_, _Y_, _O_, _P_ }

	local newCircle         = vcloner.newCircle
	local newRect           = vcloner.newRect
	local newImageRect      = vcloner.newImageRect
	local createViews		= vcloner.createViews
	local swap 				= vcloner.swapViews

	local bw = 320
	local bh = 320

	local views = createViews( nil, centerX, centerY, { w = bw, h = bh, vw = 80, vh = 80 } )

	-- Background
	local sx = -bw/2 + 16
	local sy = -bh/2 + 16
	local x = sx
	local y = sy
	local count = 1

	for i = 1, 12 do
		for j = 1, 16 do			
			local tmp = newImageRect( nil, x, y, "images/water.png", { w = 32, h = 32 } )
			x = x + 32
			count = count+1
			if(count>#colors) then
				count = 1
			end
		end
		x = sx
		y = y + 32
	end


	local function update( obj, angle )
		obj.rotation = angle + 90
	end

	--[[
	-- Plane 1
	local plane = newImageRect( nil, 0, 0, "images/plane.png", { w = 64, h = 64 } )
	local function onComplete( self )
		rotateAbout( self, 60, 0, { onComplete = onComplete, update = update, radius = 55, time = 3000 } )
	end
	rotateAbout( plane, 60, 0, { debugEn = true, onComplete = onComplete, radius = 55, time = 3000, update = update } )

	-- Plane 2
	local plane = newImageRect( nil, 0, 0, "images/plane2.png", { w = 32, h = 32, yScale = -1 } )
	local function onComplete( self )
		rotateAbout( self, -60, 0, { onComplete = onComplete, update = update, radius = 55, time = 2000, endA = -360 } )
	end
	rotateAbout( plane, -60, 0, { debugEn = true, onComplete = onComplete, radius = 55, time = 2000, endA = -360, update = update } )

	-- Plane 3
	local plane = newImageRect( nil, 0, 0, "images/plane3.png", { w = 32, h = 32 } )
	local function onComplete( self )
		rotateAbout( self, 0, 0, { onComplete = onComplete, update = update, radius = 55, time = 5000 } )
	end
	rotateAbout( plane, 0, 0, { debugEn = true, onComplete = onComplete, radius = 55, time = 5000, update = update } )

	--]]
	for i = 1, 10 do
		local planes = { "plane", "plane2", "plane3" }
		local x = mRand( -120, 120 )
		local y = mRand( -120, 120 )
		-- Plane 1
		local plane = newImageRect( nil, 0, 0, "images/" .. planes[mRand(1,3)] .. ".png", { w = 32, h = 32 } )
		local radius = mRand( 10, 155 )
		local function onComplete( self )
			rotateAbout( self, x, y, { onComplete = onComplete, update = update, radius = radius, time = 3000 } )
		end
		rotateAbout( plane, x, y, { debugEn = true, onComplete = onComplete, radius = radius, time = 3000, update = update } )
	end


	vcloner.setInitialPositions()
	vcloner.randomize()

	----[[
	for i = 2, #views do
		views[i]:scale(0.95, 0.95)
		views[i].rotation = mRand(-5, 5)
		--transition.to( views[i], { delay = 3000, time = 1000, rotation = mRand(-5, 5), xScale = 0.95, yScale = 0.95 } )
		--views[i].isVisible = false
	end
	--]]

	views[1].isVisible = false

	--views[6]:scale(1.5, 1.5)
	

	-- must be done last (after all other enterframes that modify peer objects)
	vcloner:start()
	--vcloner:stop()

	-- test auto purge
	--timer.performWithDelay( 1000, function() display.remove( tmp ) end )
	--]]


	-- ==
	--    isInBounds( obj, obj2 ) - Is the center of obj over obj2 (inside its axis aligned bounding box?)
	-- ==
	local function isInBounds( obj, obj2 )

		if(not obj2) then return false end

		local bounds = obj2.contentBounds
		if( obj.x > bounds.xMax ) then return false end
		if( obj.x < bounds.xMin ) then return false end
		if( obj.y > bounds.yMax ) then return false end
		if( obj.y < bounds.yMin ) then return false end
		return true
	end	

	local function onTouch( self, event )
		local phase = event.phase

		if( phase == "began" ) then
			self.isFocus = true
			display.currentStage:setFocus( event.target, event.id )
			self._x0 = self.x
			self._y0 = self.y

		elseif( self.isFocus ) then
			if( phase == "ended" or phase == "cancelled" ) then
				self.isFocus = false
				display.currentStage:setFocus( event.target, nil )

				for i = 2, #views do
					if(views[i] ~= self) then
						if( isInBounds( event, views[i] ) ) then
							--views[i].rotation = 0
							transition.to( self, { x = views[i].x, y = views[i].y, time = 250 } )
							transition.to( views[i], { x = self._x0, y = self._y0, time = 500 } )

						end
					end
				end

			end
			local dx = event.x - event.xStart
			local dy = event.y - event.yStart

			self.x = self._x0 + dx
			self.y = self._y0 + dy
		end
		return false
	end

	for i = 2, #views do
		views[i].touch = onTouch
		views[i]:addEventListener("touch")
	end
end


return game