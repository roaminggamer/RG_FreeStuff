-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2016
-- =============================================================
-- WIP
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
-- =============================================================
-- EFM - Add outliner capability
-- =============================================================
local easyPositioner = {}
_G.ssk.easyPositioner = easyPositioner

local easyMoverTray
local easyMoverText
local curObject
local snapEn = false
-- Possible modes "leftcenter", "rightcenter", "centertop", "centerbottom", "middle"
local snapMode = "rightcenter"
local ctrlPressed = false
local baseMoveBy = { 0.25, 0.5, 1, 2, 5, 10 }
local baseMoveByIndex = 3
local shiftMult = 10

local lastMove 

local undo

local function reset()
	Runtime:removeEventListener( "enterFrame", easyMoverTray )
	Runtime:removeEventListener( "enterFrame", easyMoverText )
	display.remove(easyMoverTray)
	easyMoverTray = nil
	display.remove(easyMoverText)
	easyMoverText = nil
	curObject = nil
	snapEn = false
	ctrlPressed = false
end

local function snapTo( target )
	undo = { curObject, curObject.x, curObject.y }
	local tleft 	= (target.anchorX == 0) and target.x or (target.anchorX == 1) and target.x - target.contentWidth or target.x - target.contentWidth/2
	local tright 	= (target.anchorX == 0) and target.x + target.contentWidth or (target.anchorX == 1) and target.x or target.x + target.contentWidth/2
	local tbot 		= (target.anchorY == 0) and target.y + target.contentHeight or (target.anchorY == 1) and target.y or target.y + target.contentHeight/2 
	local ttop		= (target.anchorY == 0) and target.y or (target.anchorY == 1) and target.y - target.contentHeight or target.y - target.contentHeight/2
	local tcx 		= (target.anchorX == 0) and target.x + target.contentWidth/2 or (target.anchorX == 1) and target.x - target.contentWidth or target.x
	local tcy		= (target.anchorY == 0) and target.y + target.contentHeight or (target.anchorY == 1) and target.y - target.contentHeight/2 or target.y

	-- Possible modes "leftcenter", "rightcenter", "centertop", "centerbottom", "middle"
	if( snapMode == "leftcenter" ) then
		curObject.x = tleft - curObject.contentWidth/2
		curObject.y = tcy
		easyMoverText.text = "< " .. curObject.x .. ", " .. curObject.y .. " >"
	elseif( snapMode == "rightcenter" ) then
		curObject.x = tright + curObject.contentWidth/2
		curObject.y = tcy
		easyMoverText.text = "< " .. curObject.x .. ", " .. curObject.y .. " >"
	end

end

local onKey = function( event )
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
		elseif( keyName == "s" ) then
			snapEn = not snapEn
			if( snapEn ) then
				easyMoverText.text = "Snap Enable: " .. snapMode
			else
				easyMoverText.text = "Snap Disabled"
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
			easyMoverText.text = "< " .. curObject.x .. ", " .. curObject.y .. " >"		
		
		elseif( keyName == "down" ) then
			undo = { curObject, curObject.x, curObject.y }
			curObject.y = curObject.y + moveBy
			easyMoverText.text = "< " .. curObject.x .. ", " .. curObject.y .. " >"		
		
		elseif( keyName == "left" ) then
			undo = { curObject, curObject.x, curObject.y }
			curObject.x = curObject.x - moveBy
			easyMoverText.text = "< " .. curObject.x .. ", " .. curObject.y .. " >"		
		
		elseif( keyName == "right" ) then
			undo = { curObject, curObject.x, curObject.y }
			curObject.x = curObject.x + moveBy
			easyMoverText.text = "< " .. curObject.x .. ", " .. curObject.y .. " >"		
		end
		
	end
end; listen( "key", onKey )


-- Editing tool to easily position objects
--
easyPositioner.attach = function( obj )
	local w 				= display.contentWidth
	local h 				= display.contentHeight
	local centerX 			= display.contentCenterX
	local centerY 			= display.contentCenterY
	local fullw				= display.actualContentWidth 
	local fullh				= display.actualContentHeight
	local unusedWidth		= fullw - w
	local unusedHeight		= fullh - h
	local left				= 0 - unusedWidth/2
	local top 				= 0 - unusedHeight/2
	local right 			= w + unusedWidth/2
	local bottom 			= h + unusedHeight/2

	local strokeColor = { 0.5, 0.5, 0.5 }
	local textColor = { 0, 0, 0}
	local trayWidth = 150
	local trayHeight = 20

	obj.touch = function( self, event )
		local target  = event.target
		local eventID = event.id

		local curPos
		local function onEnterFrame( self )
			self:toFront()
		end

		if( event.phase == "began" and curObject and snapEn and target ~= curObject	) then
			snapTo( target )
			--reset()
			snapEn = false
			return false
		end


		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			target._x0 = target.x
			target._y0 = target.y

			if( not easyMoverTray ) then
				easyMoverTray = display.newRoundedRect( centerX, top + 2, trayWidth, trayHeight, 8 )
				easyMoverTray.enterFrame = onEnterFrame
				Runtime:addEventListener( "enterFrame", easyMoverTray )
				easyMoverTray.anchorY = 0
				easyMoverTray:setStrokeColor(unpack(strokeColor))
				easyMoverTray.strokeWidth = 2
				easyMoverText = display.newText( "< " .. target.x .. ", " .. target.y .. " >", 
											       easyMoverTray.x, 
											       easyMoverTray.y + trayHeight/2,
											       native.systemFont, 12 )
				easyMoverText:setFillColor( unpack(textColor) )
				easyMoverText.enterFrame = onEnterFrame
				Runtime:addEventListener( "enterFrame", easyMoverText )

				easyMoverTray.touch = function( self, event )
					reset()
					return true
				end; easyMoverTray:addEventListener("touch")

			end
			easyMoverText.text = "< " .. target.x .. ", " .. target.y .. " >"


		elseif(target.isFocus) then
			local dx = event.x - event.xStart
			local dy = event.y - event.yStart
			target.x = target._x0 + dx
			target.y = target._y0 + dy

			easyMoverText.text = "< " .. target.x .. ", " .. target.y .. " >"

			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				target.isFocus = false
				if( curObject and target ~= curObject ) then
					curObject = target
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
	end; obj:addEventListener( "touch" )
end

return easyPositioner