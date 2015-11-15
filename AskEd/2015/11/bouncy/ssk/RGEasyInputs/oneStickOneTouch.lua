-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- One Stick + One Touch - One Touch Pad + Virtual Joystick
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
local joystick 	= ssk.easyInputs.joystick
local newRect 	= ssk.display.rect
local inputs
local pressed 	= false

local function create( group, params )
	group 	= group or display.currentStage
	params 	= params or {}

	system.activate("multitouch")

	local debugEn 			= params.debugEn or false
	local leftFill			= params.leftFill or {0,0,1}
	local rightFill			= params.rightFill or {1,0,0}
	local alpha 			= params.alpha or debugEn and 0.25 or 0
	local stickOnRight		= fnn(params.stickOnRight, false)

	local touchEventName 	= params.touchEventName or "onOneTouch"
	local keyboardEn	= fnn(params.keyboardEn, false)	

	local stickEventName 	= params.stickEventName or "onJoystick"
	local joyParams 	= params.joyParams or params.joyParams or {}


	local function onTouch( self, event )
		local phase = event.phase

		if( phase == "began" ) then
			self.isFocus = true
			display.currentStage:setFocus( event.target, event.id )
			if( debugEn ) then self:setFillColor( unpack( _W_ ) ) end
			pressed = true

		elseif( self.isFocus ) then
			if( phase == "ended" or phase == "cancelled" ) then
				self.isFocus = false
				display.currentStage:setFocus( event.target, nil )
				if( debugEn ) then self:setFillColor( unpack( self.myFill ) ) end
				pressed = false
			end
		end

		if( not( phase == "moved" and self.__lfc == ssk.__lfc ) ) then
			local newEvent = table.shallowCopy( event )
			newEvent.name = nil
			post(self.myEventName,newEvent)
		end
		self.__lfc = ssk.__lfc

		return false
	end
	
	joyParams.eventName = stickEventName
	joyParams.inUseAlpha = fnn( joyParams.inUseAlpha, 1 )
	joyParams.notInUseAlpha = fnn( joyParams.notInUseAlpha, 0.25 )

	local sx = centerX - fullw/2 + 60
	local sy = centerY + fullh/2 - 60

	inputs = display.newGroup()
	group:insert(inputs)

	local tmp
	local fill
	if( stickOnRight == false) then -- Default
		-- Create Stick
		local left = newRect( inputs, centerX - fullw/4, centerY,
			{ w = fullw/2, h = fullh, fill = leftFill, alpha = alpha, 
			  myFill = leftFill, isHitTestable = true })

		joyParams.inputObj = left

		joystick.create( inputs, sx, sy, joyParams )

		-- Create One Touch
		local right = newRect( inputs, centerX + fullw/4, centerY,
			{ w = fullw/2, h = fullh, fill = rightFill, alpha = alpha, 
			  myEventName = touchEventName, touch = onTouch, myFill = rightFill, isHitTestable = true })
		--right:addEventListener( "touch" )		
		tmp = right
		fill = rightFill

	else 
		-- Create One Touch
		local left = newRect( inputs, centerX - fullw/4, centerY,
			{ w = fullw/2, h = fullh, fill = leftFill, alpha = alpha, 
			  myEventName = touchEventName, touch = onTouch, myFill = leftFill, isHitTestable = true })
		--left:addEventListener( "touch" )
		tmp = left
		fill = leftFill

		-- Create Stick
		local right = newRect( inputs, centerX + fullw/4, centerY,
			{ w = fullw/2, h = fullh, fill = rightFill, alpha = alpha, 
			  myFill = rightFill, isHitTestable = true })

		joyParams.inputObj = right

		sx = centerX + fullw/2 - 60
		joystick.create( inputs, sx, sy, joyParams )

	end

	if(keyboardEn == true) then
		tmp.ON_KEY = function( self, event )			
			if(not self or self.removeSelf == nil) then
				ignore("ON_KEY", self)
				return
			end
			if(event.keyName == "w" or event.keyName == "up") then
				local newEvent = table.deepCopy( event )
				if(event.phase == "down") then
					newEvent.phase = "began"
					newEvent.name = nil
					if( debugEn ) then self:setFillColor( unpack( _W_ ) ) end
					pressed = true
					post( touchEventName, newEvent )
				elseif(event.phase == "up") then
					newEvent.phase = "ended"
					newEvent.name = nil
					if( debugEn ) then self:setFillColor( unpack( fill ) ) end
					pressed	= false
					post( touchEventName, newEvent )
				end			
			end
		end
		listen("ON_KEY", tmp)
	end	

end

local function destroy()
	display.remove(inputs)
	inputs = nil
	pressed	= false
end

local function getPressed()
	return pressed
end

local public = {}
public.getPressed 	= getPressed
public.create 		= create
public.destroy 		= destroy
return public
