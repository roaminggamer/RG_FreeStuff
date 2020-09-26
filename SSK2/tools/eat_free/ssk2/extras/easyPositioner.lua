-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Easy Positioner Tool
-- =============================================================

local easyPositioner = {}

local easyMoverTray
local easyMoverText
local curObject
local snapEn = false
local snapModes = { "off", "leftcenter", "rightcenter", "centertop", "centerbottom", "middle" }
local snapMode = 1
local ctrlPressed = false
local baseMoveBy = { 0.25, 0.5, 1, 2, 5, 10 }
local baseMoveByIndex = 3
local shiftMult = 10
local curScale = 1
local rounding = 2
local ox, oy

local lastMove 

local undo

local onKey


local function snapTo( target )
	undo = { curObject, curObject.x, curObject.y }
	local tleft 	= (target.anchorX == 0) and target.x or (target.anchorX == 1) and target.x - target.contentWidth or target.x - target.contentWidth/2
	local tright 	= (target.anchorX == 0) and target.x + target.contentWidth or (target.anchorX == 1) and target.x or target.x + target.contentWidth/2
	local tbot 		= (target.anchorY == 0) and target.y + target.contentHeight or (target.anchorY == 1) and target.y or target.y + target.contentHeight/2 
	local ttop		= (target.anchorY == 0) and target.y or (target.anchorY == 1) and target.y - target.contentHeight or target.y - target.contentHeight/2
	local tcx 		= (target.anchorX == 0) and target.x + target.contentWidth/2 or (target.anchorX == 1) and target.x - target.contentWidth or target.x
	local tcy		= (target.anchorY == 0) and target.y + target.contentHeight or (target.anchorY == 1) and target.y - target.contentHeight/2 or target.y

	-- Possible modes "leftcenter", "rightcenter", "centertop", "centerbottom", "middle"
	if( snapMode == 2 ) then
		curObject.x = tleft - curObject.contentWidth/2
		curObject.y = tcy
		easyMoverText.text = "< " .. round( curObject.x - ox, rounding) .. ", " .. round( curObject.y - oy, rounding) .. " >"
	elseif( snapMode == 3 ) then
		curObject.x = tright + curObject.contentWidth/2
		curObject.y = tcy
		easyMoverText.text = "< " .. round( curObject.x - ox, rounding) .. ", " .. round( curObject.y - oy, rounding) .. " >"
	elseif( snapMode == 4 ) then
		curObject.x = tcx
		curObject.y = ttop - curObject.contentHeight/2
	elseif( snapMode == 5 ) then
		curObject.x = tcx
		curObject.y = tbot + curObject.contentHeight/2
		easyMoverText.text = "< " .. round( curObject.x - ox, rounding) .. ", " .. round( curObject.y - oy, rounding) .. " >"
	elseif( snapMode == 6 ) then
		curObject.x = tcx
		curObject.y = tcy
		easyMoverText.text = "< " .. round( curObject.x - ox, rounding) .. ", " .. round( curObject.y - oy, rounding) .. " >"
	end	
end



function easyPositioner.setMoveBy( newMoveBy )
	baseMoveBy = {}
	for i = 1, #newMoveBy do
		baseMoveBy[i] = newMoveBy[i]
	end
end

function easyPositioner.stop()
	ignore( "key", onKey )
	if( easyMoverTray ) then ignore( "enterFrame", easyMoverTray ) end
	if( easyMoverText ) then ignore( "enterFrame", easyMoverText ) end
	display.remove(easyMoverTray)
	easyMoverTray = nil
	display.remove(easyMoverText)
	easyMoverText = nil
	curObject = nil
	snapEn = false
	ctrlPressed = false
end


function easyPositioner.start( params  )
	params = params or {}
	curScale = params.scale or curScale
	rounding = params.roundTo or rounding
	ox = params.ox or 0
	oy = params.oy or 0
	onKey = function( event )
		--table.dump(event)
		local keyName = event.descriptor
		local phase = event.phase
		if( phase == "down" and  string.match( keyName, "Control" ) ~= nil ) then
			ctrlPressed = true
			print(ctrlPressed,keyName)
		elseif( phase == "up" and  string.match( keyName, "Control" ) ~= nil ) then
			ctrlPressed = false
		end

		local isShiftDown = event.isShiftDown == "true" or event.isShiftDown == true
		local moveBy = baseMoveBy[baseMoveByIndex] * (isShiftDown and shiftMult or 1) 

		if( curObject and phase == "down" ) then		
			if( keyName == "u" ) then
				if( undo ) then
					undo[1].x = undo[2]
					undo[1].y = undo[3]
					undo = nil
				end
			elseif( ctrlPressed and keyName == "s" ) then
				snapMode = 1
				easyMoverText.text = "Snap Disabled"
				snapEn = false

			elseif( keyName == "s" ) then				
				snapMode = snapMode + 1
				if( snapMode > #snapModes ) then
					snapMode = 1
					easyMoverText.text = "Snap Disabled"
					snapEn = false
				
				elseif( snapMode > 1 ) then
					easyMoverText.text = "Snap Enable: " .. snapModes[snapMode]
					snapEn = true
				end

			elseif( keyName == "tab" ) then
				baseMoveByIndex = baseMoveByIndex+1
				if(baseMoveByIndex> #baseMoveBy) then 
					baseMoveByIndex = 1
				end
				easyMoverText.text = "Move By: " .. baseMoveBy[baseMoveByIndex] 
			
			elseif( keyName == "up" ) then
				undo = { curObject, curObject.x, curObject.y }
				curObject.y = curObject.y - moveBy
				easyMoverText.text = "< " .. round( curObject.x - ox, rounding) .. ", " .. round( curObject.y - oy, rounding) .. " >"		
			
			elseif( keyName == "down" ) then
				undo = { curObject, curObject.x, curObject.y }
				curObject.y = curObject.y + moveBy
				easyMoverText.text = "< " .. round( curObject.x - ox, rounding) .. ", " .. round( curObject.y - oy, rounding) .. " >"		
			
			elseif( keyName == "left" ) then
				undo = { curObject, curObject.x, curObject.y }
				curObject.x = curObject.x - moveBy
				easyMoverText.text = "< " .. round( curObject.x - ox, rounding) .. ", " .. round( curObject.y - oy, rounding) .. " >"		
			
			elseif( keyName == "right" ) then
				undo = { curObject, curObject.x, curObject.y }
				curObject.x = curObject.x + moveBy
				easyMoverText.text = "< " .. round( curObject.x - ox, rounding) .. ", " .. round( curObject.y - oy, rounding) .. " >"		

			elseif( keyName == "f" ) then
				curObject:toFront()

			elseif( keyName == "b" ) then
				curObject:toBack()

			elseif( keyName == "escape" ) then
				if( curObject ) then
					if( curObject.stroke and curObject.stroke.effect ) then
						curObject.stroke.effect = nil
						curObject.strokeWidth = curObject._origStrokeWidth
					else
						curObject.strokeWidth = curObject._origStrokeWidth
					end
					--					
					curObject._autoFront = nil
				end
				curObject = nil
			end
			if( curObject and curObject._autoFront ) then
				curObject:toFront()
			end			
		end
	end; listen( "key", onKey )
end

-- Attach positioner code to an object
--
easyPositioner.attach = function( obj, params )
	print(obj)
 	params = params or {}
 	--
 	local showAnts = fnn( params.ants, true )
 	local autoFront = fnn( params.autoFront, true )
 	--
 	obj._autoFront = autoFront
 	--
 	print(showAnts, autoFront)
 	--
	local strokeColor = { 0.5, 0.5, 0.5 }
	local textColor = { 0, 0, 0}
	local trayWidth = 150
	local trayHeight = 20

	-- Is this an SSK button?  If so, disable it
	if( obj.disable ) then obj:disable() end

	obj.touch = function( self, event )
		local target  = event.target
		local eventID = event.id

		local curPos
		local function onEnterFrameTray( self )
			self:toFront()
		end
		local function onEnterFrameText( self )
			self:toFront()
			self.x = self.tray.x
			self.y = self.tray.y + self.tray.contentHeight/2
		end

		if( event.phase == "began" and curObject and snapEn and target ~= curObject	) then
			snapTo( target )
			--reset()
			snapEn = false
			return true
		end


		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			target._x0 = target.x
			target._y0 = target.y

			if( not easyMoverTray ) then
				easyMoverTray = display.newRoundedRect( centerX, top + 2, trayWidth * curScale, trayHeight * curScale, 8 )
				easyMoverTray.enterFrame = onEnterFrameTray
				Runtime:addEventListener( "enterFrame", easyMoverTray )
				easyMoverTray.anchorY = 0
				easyMoverTray:setStrokeColor(unpack(strokeColor))
				easyMoverTray.strokeWidth = 2 * curScale
				easyMoverText = display.newText( "< " .. target.x - ox.. ", " .. target.y  - oy .. " >", 
											       easyMoverTray.x, 
											       easyMoverTray.y + curScale * trayHeight/2,
											       native.systemFont, 12 * curScale )
				easyMoverText:setFillColor( unpack(textColor) )
				easyMoverText.tray = easyMoverTray
				easyMoverText.enterFrame = onEnterFrameText
				Runtime:addEventListener( "enterFrame", easyMoverText )

				ssk.misc.addSmartDrag( easyMoverTray )

				curObject = target
				curObject:setStrokeColor(1,1,1)
				if( showAnts ) then
					curObject.stroke.effect = "generator.marchingAnts"
					curObject._origStrokeWidth = curObject.strokeWidth
					curObject.strokeWidth = 4
				else
					curObject._origStrokeWidth = curObject.strokeWidth
					curObject.strokeWidth = 1
				end
				if( autoFront ) then
					curObject:toFront()
				end

			end
			easyMoverText.text = "< " .. round( target.x - ox, rounding) .. ", " .. round( target.y - oy, rounding) .. " >"


		elseif(target.isFocus) then
			local dx = event.x - event.xStart
			local dy = event.y - event.yStart
			target.x = target._x0 + dx
			target.y = target._y0 + dy

			easyMoverText.text = "< " .. round( target.x - ox, rounding) .. ", " .. round( target.y - oy, rounding) .. " >"

			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( target, nil )
				target.isFocus = false
				if( curObject and target ~= curObject ) then
					if( curObject.stroke and curObject.stroke.effect ) then
						curObject.stroke.effect = nil
						curObject.strokeWidth = curObject._origStrokeWidth
					else
						curObject.strokeWidth = curObject._origStrokeWidth
					end
					--
					curObject._autoFront = nil
					--
					curObject = target
					curObject:setStrokeColor(1,1,1)
					if( showAnts ) then
						curObject.stroke.effect = "generator.marchingAnts"
						curObject._origStrokeWidth = curObject.strokeWidth
						curObject.strokeWidth = 4
					else
						curObject._origStrokeWidth = curObject.strokeWidth
						curObject.strokeWidth = 1
					end

					if( autoFront ) then
						curObject:toFront()
					end

					local sx = curObject.xScale
					local sy = curObject.yScale
					local mult = 1.05
					transition.to( curObject, { xScale = sx * mult, yScale = sy * mult, time = 100 } )
					transition.to( curObject, { delay = 200, xScale = sx, yScale = sy, time = 100 } )
				
				elseif( not curObject ) then
					curObject = target
				end
			end
		end
		return true
	end; obj:addEventListener( "touch" )
end

if( not _G.ssk ) then	
	_G.ssk = { }
end
if( not _G.ssk.dialogs ) then
	_G.ssk.easyPositioner = {}
end
_G.ssk.easyPositioner = easyPositioner

return easyPositioner