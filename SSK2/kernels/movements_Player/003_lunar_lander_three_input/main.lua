-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua (72/135)
-- =============================================================
-- Kernel: Lunar Lander Movement ( Custom Inputs )
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- 1. LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            gameFont 				= "Prime.ttf",
	            debugLevel 				= 0 } )
-- =============================================================
-- KERNEL CODE BEGINS BELOW
-- =============================================================

-- =============================================================
-- Localizations
-- =============================================================
local newRect 			= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local twoTouch 		= ssk.easyInputs.twoTouch
local actions 			= ssk.actions

-- =============================================================
-- Locals
-- =============================================================
local group 		= display.newGroup()
local playerSize 	= 40
local player
local target
local angle 		= 0


-- ==
--    1. Start and Configure  physics
-- ==
local physics = require "physics"
physics.start()
physics.setGravity(0,10)
physics.setDrawMode("hybrid")


-- ==
--    2. Create a 'wrapRect' as a proxy for wrapping calculations
-- ==
local wrapRect = newRect( group, centerX, centerY, 
	                       { w = fullw + playerSize, h = fullh + playerSize,
	                         fill = { 0, 1, 1, 0.1}, stroke = {1,1,0,0.5}, strokeWidth = 1 } )


-- ==
--    3. Create primary object: Player/Ship
-- ==
player = newImageRect( group, centerX, centerY, "images/arrow.png", { size = playerSize }, { } )
player.linearDamping = 0.5
player.angularDamping = 1
player.leftInput  = false
player.rightInput = false
player.thrustPercent = 0
player.maxThrust = 25

-- ==
--    4. Add event listeners to primary object.
-- ==

-- onTurn() - Custom event produced by left/right turn
-- buttons.
--
function player.onTurn( self, event )
	if( event.isLeft ) then
		player.leftInput = event.turning
	else
		player.rightInput = event.turning
	end
end; listen( "onTurn", player )

-- onThrust() - Custom event produced by throttle.
--
function player.onThrust( self, event )
	player.thrustPercent = event.percent
end; listen( "onThrust", player )

-- enterFrame() - Called every frame, this moves the player based on input values
--                and calculations.
--
function player.enterFrame( self )
	if( self.leftInput and not self.rightInput ) then
		actions.face( self, { angle = self.rotation - 90, rate = 90 } )

	elseif( not self.leftInput and self.rightInput ) then
		actions.face( self, { angle = self.rotation + 90, rate = 90 } )

	else
		actions.face( self, { pause = true } )
	end

	local rate = self.thrustPercent * self.maxThrust
	if( rate > 0 ) then
		actions.movep.thrustForward( self, { rate = rate } )
	end

	-- Limit Velocity to maximum rate of 300 pixels per second
	actions.movep.dampDown( self, { rate = 100, damping = 2 })

	actions.scene.rectWrap( self, wrapRect )		

end; listen( "enterFrame", player )


-- ==
--    5. Create input objects - Two buttons and 'throttle'
-- ==

-- Common touch listener for left/right buttons
--
local function onTouch( self, event)
	if( event.phase == "began" ) then
		-- Send all future events associated with this
		-- touch to this object's event listener.
		display.currentStage:setFocus( self, event.id )
		self.isFocus = true

		-- Post 'onTurn' event to start turning
		post("onTurn", { isLeft = self.isLeft, turning = true })
		self:setFillColor(0,1,0)

	elseif( self.isFocus ) then

		if( event.phase == "ended" ) then
			-- Stop sending touches to this object's listener.  
			-- The touch is over.
			display.currentStage:setFocus( self, nil )
			self.isFocus = false

			-- Post 'onTurn' event to stop turning
			post("onTurn", { isLeft = self.isLeft, turning = false })

			self:setFillColor(1,1,1)
		end			
	end
	return false
end

-- Left Button
--
local tmp = newImageRect( group, left + 75, bottom - 75, "images/arrowLeft.png",
              { size = 100, isLeft = true } )
tmp.touch = onTouch
tmp:addEventListener("touch")

-- Right Button
--
local tmp = newImageRect( group, left + 200, bottom - 75, "images/arrowRight.png",
             { size = 100, touch = onTouch, isLeft = false } )
tmp.touch = onTouch
tmp:addEventListener("touch")


-- Touch Listener for Throttle
--
local function onTouch( self, event)
	local minY = self.bar.minY
	local maxY = self.bar.maxY
	local mag = maxY - minY

	if( event.phase == "began" ) then
		-- Send all future events associated with this
		-- touch to this object's event listener.
		display.currentStage:setFocus( self, event.id )
		self.isFocus = true

		-- Move bar to y-position of touch
		self.bar.y = event.y

	elseif( self.isFocus ) then

		-- Move bar to y-position of touch
		self.bar.y = event.y

		if( event.phase == "ended" ) then
			-- Stop sending touches to this object's listener.  
			-- The touch is over.
			display.currentStage:setFocus( self, nil )
			self.isFocus = false

			-- Move bar to off position
			self.bar.y = maxY
		end			
	end

	-- Ensure bar is not moved too low or high
	if( self.bar.y < minY ) then
		self.bar.y = minY
	
	elseif(self.bar.y > maxY ) then
		self.bar.y = maxY
	end

	-- Calculate thrust		
	local dist = maxY - self.bar.y
	local percent = dist/ mag
	--print(thrustPercent, dist, mag)
	post("onThrust", { percent = percent })

	return false
end

-- Create the throttle from several rectangles
--
local throttleBox = newRect( group, right - 125, bottom - 75,
                             { w = 200, h = 100, strokeWidth = 2, 
                               fill = _DARKGREY_} )

local groove = newRect( group, throttleBox.x - 75, throttleBox.y,
                             { w = 20, h = 90, fill = _K_,
                               anchorX = 0 } )

local groove = newRect( group, throttleBox.x + 75, throttleBox.y,
                             { w = 20, h = 90, fill = _K_,
                               anchorX = 1 } )

local minY = throttleBox.y - throttleBox.contentHeight/2 + 15
local maxY = throttleBox.y + throttleBox.contentHeight/2 - 15
throttleBox.bar = newRect( group, throttleBox.x, maxY,
                             { w = 190, h = 20, fill = _W_,
                               minY = minY, maxY = maxY } )

throttleBox.touch = onTouch
throttleBox:addEventListener("touch")

-- ==
--    6. Create 'plaforms' to practice landing on.
-- ==
local plat = newRect( group, centerX, centerY+ 50, 
	                   { w = 50, h = 50, fill = _O_}, 
	                   { bodyType = "static"} )

local plat = newRect( group, centerX - 200, centerY + 0, 
	                   { w = 80, h = 100, fill = _O_}, 
	                   { bodyType = "static"} )

local plat = newRect( group, centerX + 200, centerY + 0, 
	                   { w = 80, h = 100, fill = _O_}, 
	                   { bodyType = "static"} )