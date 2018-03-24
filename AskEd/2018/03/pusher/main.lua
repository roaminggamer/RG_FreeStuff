io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local fullw = display.actualContentWidth
local fullh = display.actualContentWidth
--
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode("hybrid")
--

-- GROUND
local ground = display.newRect( centerX, centerY + 60, 1000, 40 )
physics.addBody(ground,"static", { bounce = 0, friction = 1 })
ground:setFillColor(0,0.8,0)
ground.friction = 0.5

-- BALL
local ball = display.newCircle( centerX, centerY, 40 )
physics.addBody(ball, { bounce = 0, friction = 1 })
ball:setFillColor(0,1,1)
ball.isSleepingAllowed = false
ball.linearDamping = 2


-- PIPE & PUSHER
local pipe = display.newRect( centerX + 140, ball.y, 80, 20 )
pipe.anchorX = 1
pipe:setFillColor(1,0,0)
--
local pusher = display.newRect( pipe.x - pipe.width, pipe.y, 10, 20 )
pusher.anchorX = 0
pusher:setFillColor(1,1,0)
pusher.myPipe = pipe
physics.addBody(pusher, { bounce = 0, friction = 1 })
pusher.isSleepingAllowed = false
pusher.isFixedRotation = true
pusher.touchJoint = physics.newJoint( "touch", pusher, pusher.x, pusher.y )
--pusher.isVisible = false
pusher.touchJoint.maxForce = 1e6
pusher.touchJoint.frequency = 1e9
pusher.touchJoint.dampingRatio = 0

local ox = 2 -- transition leads position, so offset a little
function pusher.enterFrame( self )
	local pipe = self.myPipe
	local joint = self.touchJoint
	joint:setTarget( pipe.x - pipe.width - ox, pipe.y )
end; Runtime:addEventListener( "enterFrame", pusher)

local tx = - 200
transition.to( pipe.path, { time = 3000,  x1 = tx , x2 = tx } )

