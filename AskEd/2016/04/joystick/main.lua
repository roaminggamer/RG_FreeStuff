io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs           = ..., 
               enableAutoListeners  = true,
               exportCore           = true,
               exportColors         = true,
               exportSystem         = true,
               exportSystem         = true,
               debugLevel           = 0 } )

-- 1. Always use groups to contain objects
local group = display.newGroup()

-- 2.  Let's make a background
-- centerX, centerY, fullw, fullh  - All globals from SSK 
local back = display.newRect( group, centerX, centerY, fullw, fullh )
back:setFillColor( unpack(_CYAN_) ) -- _CYAN_ from SSK
back.alpha = 0.10


-- 3. It is NOT suggested that you use the joystick code directly. 
--    Use the oneStick easy input instead.  That is why I wrote the easy input helpers. :)
--    Yes, I know this stuff is not well documented.
--
ssk.easyInputs.oneStick.create( group, 
			{ 
				-- Parameters to oneStick builder:
				eventName = "myJoystickEvent", -- defaults to onJoystick

				-- Parameters to joystick builder:
				joyParams = 
				{ 
					doNorm = true, -- Calculate normalized vectors and send in event
					               -- This is expensive by default it is false
				} 
			} )


-- 4. Now make an object to listen for joystick events and to do something
--    when it gets them.
local bob = display.newImageRect( group, "smiley.png", 48, 48 )
bob.x = centerX
bob.y = centerY
bob.mx = 0
bob.my = 0
bob.rate = 250 -- pixels-per-second
bob.lastTime = system.getTimer()

function bob.myJoystickEvent( self, event )
	if( autoIgnore( "myJoystickEvent", self) ) then return end

	-- Table dumper from SSK (for debug)
	table.dump(event)

	self.mx = -event.nx
	self.my = -event.ny
	self.rotation = event.angle
end; listen( "myJoystickEvent", bob )

-- Not a great way to move, but hey its a quick example...
--
function bob.enterFrame( self )
	if( autoIgnore( "enterFrame", self) ) then return end

	local curTime = system.getTimer()
	dt = self.lastTime - curTime
	self.lastTime = curTime



	self.x = self.x + self.mx * self.rate * dt/1000
	self.y = self.y + self.my * self.rate * dt/1000
end; listen( "enterFrame", bob )