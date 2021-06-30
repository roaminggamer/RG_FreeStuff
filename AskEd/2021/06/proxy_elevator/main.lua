local physics = require("physics")
local proxy = require "proxy"

physics.start()
physics.setDrawMode("hybrid")


-- 
-- Elevator 1
-- 
local elevator1 = display.newRect( 200, 600, 100, 25 )
physics.addBody( elevator1, "kinematic", { bounce = 0,friction = 1 } )

local player1 = display.newRect( elevator1.x, elevator1.y - 50, 50, 50 )
physics.addBody( player1, "dynamic", { bounce = 0,friction = 1 } )

--convert 'elevator' to a proxy-based display object
elevator1 = proxy.get_proxy_for( elevator1 )

-- next, let's set up a listener for property updates
function elevator1:propertyUpdate( event )
	print( "Changed " .. event.key .. " to " .. event.value )

	if( event.key == "yVel" ) then
		elevator1:setLinearVelocity( 0, event.value )
	end
end
elevator1:addEventListener( "propertyUpdate" )

-- Start elevator in 1 second
timer.performWithDelay( 1000,
	function() 
		-- Elevator is going up
		elevator1.yVel = -500

		-- elevator1:setLinearVelocity( 0, elevator1.yVel )

		transition.to( elevator1, { yVel = 0, time = 1500, transition = easing.inOutSine } )
	end )


-- 
-- Elevator 2
-- 
local elevator2 = display.newRect( 500, 600, 100, 25 )
physics.addBody( elevator2, "kinematic", { bounce = 0,friction = 1 } )

local player2 = display.newRect( elevator2.x, elevator2.y - 50, 50, 50 )
physics.addBody( player2, "dynamic", { bounce = 0,friction = 1 } )

--convert 'elevator' to a proxy-based display object
elevator2 = proxy.get_proxy_for( elevator2 )

-- next, let's set up a listener for property updates
function elevator2:propertyUpdate( event )
	print( "Changed " .. event.key .. " to " .. event.value )

	if( event.key == "yVel" ) then
		elevator2:setLinearVelocity( 0, event.value )
		if( math.abs(event.value) < 0.1 ) then
			player2.linearDamping = 0
		end
	end
end
elevator2:addEventListener( "propertyUpdate" )

-- Start elevator in 1 second
timer.performWithDelay( 1000,
	function() 
		-- Elevator is going up
		elevator2.yVel = -500
		player2.linearDamping = 20

		-- elevator2:setLinearVelocity( 0, elevator2.yVel )

		transition.to( elevator2, { yVel = 0, time = 1500, transition = easing.inOutSine } )
	end )

