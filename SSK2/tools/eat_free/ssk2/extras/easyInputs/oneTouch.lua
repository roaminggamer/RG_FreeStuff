-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- One Touch - Touch Pad Factory
-- =============================================================
local easyInputs = _G.ssk.easyInputs or {}
_G.ssk.easyInputs = easyInputs
-- =============================================================
local newRect   = ssk.display.newRect


local function destroy( self )
	if( ssk.__debugLevel > 0 ) then
		print("oneTouch() - destroy()")
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

	local debugEn 		= params.debugEn or false
	local fill 			= params.fill or {1,0,0}
	local alpha 		= params.alpha or debugEn and 0.25 or 0
	local eventName 	= params.eventName or "onOneTouch"
	local keyboardEn	= fnn(params.keyboardEn, false)	
	local appleTVEn		= fnn(params.appleTVEn, false)	
	
	local function onTouch( self, event )
		local phase = event.phase

		if( self.sleeping ) then return false end

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

	local inputHelper = display.newGroup()
	group:insert(inputHelper)

	local tmp = newRect( inputHelper, centerX, centerY,
		{ w = fullw, h = fullh, fill = fill, alpha = alpha, isHitTestable = true })
	tmp.touch = onTouch
	tmp:addEventListener("touch")

	inputHelper.proxy = tmp

	--tmp:addEventListener( "touch" )

	if(keyboardEn == true or appleTVEn == true ) then
		inputHelper.proxy.key = function( self, event )
			if( ssk.__debugLevel > 1 ) then table.dump(event,nil,"easyInputs.oneTouch()") end

			if( self.sleeping ) then return false end

			if(not self or self.removeSelf == nil) then
				ignore("key", self)
				return
			end
			if( keyboardEn and ( event.keyName == "w" or event.keyName == "up" ) ) then
				local newEvent = table.deepCopy( event )
				if(event.phase == "down") then
					newEvent.phase = "began"
					newEvent.name = nil
					if( debugEn ) then self:setFillColor( unpack( _W_ ) ) end
					self.pressed = true
					post( eventName, newEvent )
				elseif(event.phase == "up") then
					newEvent.phase = "ended"
					newEvent.name = nil
					if( debugEn ) then self:setFillColor( unpack( fill ) ) end
					self.pressed	= false
					post( eventName, newEvent )
				end			
			end
			if( appleTVEn and ( event.keyName == "buttonZ" ) ) then
				local newEvent = table.deepCopy( event )
				if(event.phase == "down") then
					newEvent.phase = "began"
					newEvent.name = nil
					if( debugEn ) then self:setFillColor( unpack( _W_ ) ) end
					self.pressed = true
					post( eventName, newEvent )
					timer.performWithDelay( 100, function() self:setFillColor( unpack( fill ) ) end )
				end			
			end
		end
		listen("key", tmp)
	end	

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
easyInputs.oneTouch = public
return public
