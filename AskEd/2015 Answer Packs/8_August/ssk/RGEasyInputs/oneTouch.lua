-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- One Touch - Touch Pad Builder
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

local newRect   = ssk.display.rect
local inputs
local pressed 	= false

local function create( group, params )
	group 	= group or display.currentStage
	params 	= params or {}

	local debugEn 		= params.debugEn or false
	local fill 			= params.fill or {1,0,0}
	local alpha 		= params.alpha or debugEn and 0.25 or 0
	local eventName 	= params.eventName or "onOneTouch"
	local keyboardEn	= fnn(params.keyboardEn, false)	
	
	local function onTouch( self, event )
		local phase = event.phase

		if( phase == "began" ) then
			self.isFocus = true
			display.currentStage:setFocus( event.target, event.id )
			if( debugEn ) then self:setFillColor( unpack( _W_ ) ) end			

		elseif( self.isFocus ) then			
			if( phase == "ended" or phase == "cancelled" ) then
				self.isFocus = false
				display.currentStage:setFocus( event.target, nil )
				if( debugEn ) then self:setFillColor( unpack( fill ) ) end
			end
		end
		
		if( not( phase == "moved" and self.__lfc == ssk.__lfc ) ) then
			local newEvent = table.shallowCopy( event )
			newEvent.name = nil
			post(eventName,newEvent)
		end
		self.__lfc = ssk.__lfc
		return false
	end

	inputs = display.newGroup()
	group:insert(inputs)

	local tmp = newRect( inputs, centerX, centerY,
		{ w = fullw, h = fullh, fill = fill, alpha = alpha, touch = onTouch, isHitTestable = true })

	--tmp:addEventListener( "touch" )

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
					post( eventName, newEvent )
				elseif(event.phase == "up") then
					newEvent.phase = "ended"
					newEvent.name = nil
					if( debugEn ) then self:setFillColor( unpack( fill ) ) end
					pressed	= false
					post( eventName, newEvent )
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
