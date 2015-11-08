-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Two Touch - Touch Pads Builder
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
local inputs
local leftPressed 	= false
local rightPressed 	= false
local left
local right

local function create( group, params )
	group 	= group or display.currentStage
	params 	= params or {}

	system.activate("multitouch")
	
	local debugEn 			= params.debugEn or false
	local leftFill			= params.leftFill or {0,0,1}
	local rightFill			= params.rightFill or {1,0,0}
	local alpha 			= params.alpha or debugEn and 0.25 or 0
	local leftEventName 	= params.leftEventName or "onTwoTouchLeft"
	local rightEventName 	= params.rightEventName or "onTwoTouchRight"
	local keyboardEn			= fnn(params.keyboardEn, false)	

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
				if( debugEn ) then self:setFillColor( unpack( self.myFill ) ) end
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

	left = newRect( inputs, centerX - fullw/4, centerY,
		{ w = fullw/2, h =  fullh, fill = leftFill, alpha = alpha, 
		  myEventName = leftEventName, touch = onTouch, myFill = leftFill, isHitTestable = true })

	right = newRect( inputs, centerX + fullw/4, centerY,
		{ w = fullw/2, h = fullh, fill = rightFill, alpha = alpha, 
		  myEventName = rightEventName, touch = onTouch, myFill = rightFill, isHitTestable = true })

	--left:addEventListener( "touch" )
	--right:addEventListener( "touch" )

	if(keyboardEn == true) then
		left.ON_KEY = function( self, event )			
			--if(not self or self.removeSelf == nil) then
			if(event.keyName == "a" or event.keyName == "left") then
				local newEvent = table.deepCopy( event )
				if(event.phase == "down") then
					newEvent.phase = "began"
					newEvent.name = nil
					if( debugEn ) then left:setFillColor( unpack( _W_ ) ) end
					leftPressed = true
					post( leftEventName, newEvent )
				elseif(event.phase == "up") then
					newEvent.phase = "ended"
					newEvent.name = nil
					if( debugEn ) then left:setFillColor( unpack( left.myFill ) ) end
					leftPressed = false
					post( leftEventName, newEvent )
				end
			end
		end
		listen("ON_KEY", left)
	end

	left.finalize = function( self )		
		if( self.ON_KEY ) then
			ignore( "ON_KEY", self )
			self.ON_KEY = nil
		end
		inputs = nil
		leftPressed = false
		left = nil
	end; left:addEventListener("finalize")

	if(keyboardEn == true) then
		right.ON_KEY = function( self, event )			
			--if(not self or self.removeSelf == nil) then
			if(event.keyName == "d" or event.keyName == "right") then				
				local newEvent = table.deepCopy( event )
				if(event.phase == "down") then
					newEvent.phase = "began"
					newEvent.name = nil
					if( debugEn ) then right:setFillColor( unpack( _W_ ) ) end
					rightPressed = true
					post( rightEventName, newEvent )
				elseif(event.phase == "up") then
					newEvent.phase = "ended"
					newEvent.name = nil
					rightPressed = false
					if( debugEn ) then right:setFillColor( unpack( right.myFill ) ) end
					post( rightEventName, newEvent )
				end
			end
		end
		listen("ON_KEY", right)
	end

	right.finalize = function( self )
		if( self.ON_KEY ) then
			ignore( "ON_KEY", self )
			self.ON_KEY = nil
		end
		inputs = nil
		rightPressed = false
		right = nil
	end; right:addEventListener("finalize")	
end

local function destroy()
	display.remove(inputs)
	inputs = nil
	leftPressed = false
	rightPressed = false
	left = nil
	right = nil
end

local function getPressed()
	return leftPressed, rightPressed
end

local function reset()
	leftPressed = false
	rightPressed = false
	left.isFocus = false
	right.isFocus = false
	display.currentStage:setFocus( left, nil )
	display.currentStage:setFocus( right, nil )
end


local public = {}
public.reset 		= reset
public.getPressed 	= getPressed
public.create 		= create
public.destroy 		= destroy
return public