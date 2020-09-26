-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- One Stick + One Touch - One Touch Pad + Virtual Joystick Factory
-- =============================================================
local easyInputs = _G.ssk.easyInputs or {}
_G.ssk.easyInputs = easyInputs
-- =============================================================
local joystick = ssk.easyInputs.joystick
local newRect 	= ssk.display.newRect
local pressed 	= false

local function destroy( self )
	if( ssk.__debugLevel > 0 ) then
		print("oneStickOneTouch() - destroy()")
	end
	if( self.proxy.key ) then 
		ignore("key", self.proxy)
		self.proxy.key = nil
	end
	self.destroy = nil
end


local function sleep( self )
	self.proxy.sleeping = true
end


local function wake( self )
	self.proxy.sleeping = false
end

local function getPressed( self )
	return self.proxy.pressed
end

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

		if( self.sleeping ) then return false end

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

	local inputHelper = display.newGroup()
	group:insert(inputHelper)

	local tmp
	local fill
	if( stickOnRight == false) then -- Default
		-- Create Stick
		local left = newRect( inputHelper, centerX - fullw/4, centerY,
			{ w = fullw/2, h = fullh, fill = leftFill, alpha = alpha, 
			  myFill = leftFill, isHitTestable = true })

		joyParams.inputObj = left

		joystick.create( inputHelper, sx, sy, joyParams )

		-- Create One Touch
		local right = newRect( inputHelper, centerX + fullw/4, centerY,
			{ w = fullw/2, h = fullh, fill = rightFill, alpha = alpha, 
			  myEventName = touchEventName, myFill = rightFill, isHitTestable = true })
		--right:addEventListener( "touch" )		
		tmp = right
		fill = rightFill
		tmp.touch = onTouch
		tmp:addEventListener("touch")


	else 
		-- Create One Touch
		local left = newRect( inputHelper, centerX - fullw/4, centerY,
			{ w = fullw/2, h = fullh, fill = leftFill, alpha = alpha, 
			  myEventName = touchEventName,  myFill = leftFill, isHitTestable = true })
		--left:addEventListener( "touch" )
		tmp = left
		fill = leftFill
		tmp.touch = onTouch
		tmp:addEventListener("touch")

		-- Create Stick
		local right = newRect( inputHelper, centerX + fullw/4, centerY,
			{ w = fullw/2, h = fullh, fill = rightFill, alpha = alpha, 
			  myFill = rightFill, isHitTestable = true })

		joyParams.inputObj = right

		sx = centerX + fullw/2 - 60
		joystick.create( inputHelper, sx, sy, joyParams )

	end

	if(keyboardEn == true) then
		tmp.key = function( self, event )			

			if( self.sleeping ) then return false end

			if(event.keyName == "w" or event.keyName == "up") then
				if( ssk.__debugLevel > 1 ) then table.dump(event,nil,"easyinputHelper.twoTouch()") end
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
		listen("key", tmp)
	end

	inputHelper.proxy = tmp	


	inputHelper.finalize = function( self )
		if( self.destroy ) then
			self:destroy()
		end
	end; inputHelper:addEventListener("finalize")

	inputHelper.proxy.sleeping 	= false
	inputHelper.proxy.pressed  	= false

	inputHelper.destroy = destroy
	inputHelper.wake = wake
	inputHelper.sleep = sleep
	inputHelper.getPressed = getPressed

	return inputHelper

end

local public = {}
public.create 		= create
-- =============================================================
easyInputs.oneStickOneTouch = public

return public
