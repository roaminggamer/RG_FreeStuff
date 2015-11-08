-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Corner Buttons - Dual Corner-Buttons  Builder
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
local newRect           = ssk.display.rect
local newImageRect 		= ssk.display.imageRect
local inputs

local function create( group, params )
	group 	= group or display.currentStage
	params 	= params or {}

	system.activate("multitouch")
	
	local debugEn 			= params.debugEn or false
	local button1Fill		= params.button1Fill or {1,0.55,0.55,1}
	local button2Fill		= params.button2Fill or {0,1,1,1}
	local button1Mask 		= params.button1Mask or "ssk/RGEasyInputs/halftouchA1M.png"
	local button2Mask 		= params.button2Mask or "ssk/RGEasyInputs/halftouchA2M.png"
	local alpha 			= params.alpha or 0.25
	local button1EventName 	= params.button1EventName or "onButton1"
	local button2EventName 	= params.button2EventName or "onButton2"
	local keyboardEn			= fnn(params.keyboardEn, false)	
	local size 				= params.size or w/4
	local startRight 		= fnn(params.startRight, true)
	local xOffset 			= params.xOffset or 0
	local yOffset 			= params.yOffset or 0

	local function onTouch( self, event )
		local phase = event.phase

		if( phase == "began" ) then
			self.isFocus = true
			display.currentStage:setFocus( event.target, event.id )
			if( debugEn ) then self.alpha = 1 end

		elseif( self.isFocus ) then
			if( phase == "ended" or phase == "cancelled" ) then
				self.isFocus = false
				display.currentStage:setFocus( event.target, nil )
				if( debugEn ) then self.alpha = alpha end
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

	inputs = display.newGroup()
	group:insert(inputs)

	local x
	local y
	local button1
	local button2

	if( startRight ) then
		x = right - size/2 + xOffset
		y = bottom - size/2 + yOffset
		local mask1 = graphics.newMask( button1Mask )
		local mask2 = graphics.newMask( button2Mask )
		button1 = newRect( inputs, x, y, 
			{ size = size, fill = button1Fill, alpha = alpha, 
			  myEventName = button1EventName, touch = onTouch, 
			  isHitMasked = true })
		button1:setMask( mask1 )

		button2 = newRect( inputs, x, y, 
			{ size = size, fill = button2Fill, alpha = alpha, 
			  myEventName = button2EventName, touch = onTouch, 
			  isHitMasked = true })
		button2:setMask( mask2 )
		
		button1.maskScaleX = -1
		button2.maskScaleX = -1
	else
		x = left + size/2 + xOffset
		y = bottom - size/2 + yOffset
		local mask1 = graphics.newMask( button1Mask )
		local mask2 = graphics.newMask( button2Mask )
		button1 = newRect( inputs, x, y, 
			{ size = size, fill = button1Fill, alpha = alpha, 
			  myEventName = button1EventName, touch = onTouch, 
			  isHitMasked = true })
		button1:setMask( mask1 )

		button2 = newRect( inputs, x, y, 
			{ size = size, fill = button2Fill, alpha = alpha, 
			  myEventName = button2EventName, touch = onTouch, 
			  isHitMasked = true })
		button2:setMask( mask2 )
	end

	--button1:addEventListener( "touch" )
	--button2:addEventListener( "touch" )

	if(keyboardEn == true) then
		button1.ON_KEY = function( self, event )			
			if(not self or self.removeSelf == nil) then
				ignore("ON_KEY", self)
				return
			end
			if(event.keyName == "d" or event.keyName == "right") then
				local newEvent = table.deepCopy( event )
				if(event.phase == "down") then
					newEvent.phase = "began"
					newEvent.name = nil
					if( debugEn ) then self.alpha = 1 end
					post( button1EventName, newEvent )
				elseif(event.phase == "up") then
					newEvent.phase = "ended"
					newEvent.name = nil
					post( button1EventName, newEvent )
					if( debugEn ) then self.alpha = alpha end
				end
			end

		end
		listen("ON_KEY", button1)

		button2.ON_KEY = function( self, event )			
			if(not self or self.removeSelf == nil) then
				ignore("ON_KEY", self)
				return
			end
			if(event.keyName == "a" or event.keyName == "left") then				
				local newEvent = table.deepCopy( event )
				if(event.phase == "down") then
					newEvent.phase = "began"
					newEvent.name = nil
					if( debugEn ) then self.alpha = 1 end
					post( button2EventName, newEvent )
				elseif(event.phase == "up") then
					newEvent.phase = "ended"
					newEvent.name = nil
					post( button2EventName, newEvent )
					if( debugEn ) then self.alpha = alpha end
				end
			end
		end
		listen("ON_KEY", button2)
	end

end

local function destroy()
	display.remove(inputs)
	inputs = nil
end

local public = {}
public.create 	= create
public.destroy 	= destroy
return public