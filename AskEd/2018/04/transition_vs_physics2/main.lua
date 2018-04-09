io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local physics = require "physics"
physics.start()
physics.setGravity(0,10)
--physics.setDrawMode("hybrid")
-- =====================================================
local w             	= display.contentWidth
local h             	= display.contentHeight
local centerX       	= display.contentCenterX
local centerY       	= display.contentCenterY
local fullw         	= display.actualContentWidth 
local fullh         	= display.actualContentHeight
-- =====================================================

local speed = 100
local pushToX = centerX + fullw/2 - 400

-- =====================================================
-- TRANSITION
-- =====================================================
local ground = display.newRect( centerX, centerY, fullw, 40)
ground.anchorY = 1
ground:setFillColor(0,0.3,0)
physics.addBody( ground, "static", { friction = 1, bounce = 0.2 } )

local ball = display.newCircle( centerX, centerY - 65, 20 )
physics.addBody( ball, "dynamic", { friction = 1, bounce = 0.2, radius = 20 } )
ball.fill = { type = "image", filename = "checkerboard.png" }
ball:setFillColor(1,1,0)
ball.linerDamping = 1
ball.angularDamping = 2

transition.to( ball, { x = centerX - fullw/2, time = 6000  } )

local pusher = display.newRect( ball.x - 280, ball.y, 40, 40 )
physics.addBody( pusher, "kinematic", { friction = 0, bounce = 0 } )
pusher.isSleepingAllowed = false
pusher.isBullet = true
pusher:setFillColor(1,0,0)

transition.to( pusher, { x = pushToX, time = 1000 * (pushToX - pusher.x)/speed  } )



-- =====================================================
-- PHYSICS
-- =====================================================
local ground = display.newRect( centerX, centerY + fullh/2, fullw, 40)
ground.anchorY = 1
ground:setFillColor(0,0.3,0)
physics.addBody( ground, "static", { friction = 1, bounce = 0.2 } )

local ball = display.newCircle( centerX, centerY +fullh/2 - 65, 20 )
physics.addBody( ball, "dynamic", { friction = 1, bounce = 0.2, radius = 20 } )
ball.fill = { type = "image", filename = "checkerboard.png" }
ball:setFillColor(1,1,0)
ball.linerDamping = 1
ball.angularDamping = 2

ball:setLinearVelocity( -speed, 0 )

local pusher = display.newRect( ball.x - 280, ball.y, 40, 40 )
physics.addBody( pusher, "kinematic", { friction = 0, bounce = 0 } )
pusher.isSleepingAllowed = false
pusher.isBullet = true
pusher:setFillColor(1,0,0)

pusher:setLinearVelocity( speed, 0 )

function pusher.enterFrame( self )
	if( self.x >= pushToX ) then
		self:setLinearVelocity(0,0)
		Runtime:removeEventListener('enterFrame', self )
	end
end
Runtime:addEventListener('enterFrame',pusher)

