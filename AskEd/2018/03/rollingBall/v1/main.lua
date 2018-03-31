io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local physics = require "physics"
physics.start()
physics.setGravity(0,10)
physics.setDrawMode("hybrid")

local screenGroup  = display.newGroup()

local ball = display.newCircle( screenGroup, display.contentCenterX + 200, display.contentCenterY - 50, 10)
physics.addBody(ball, 'dynamic', { friction = 1, bounce = 0.8, radius = 10 } )
ball:applyLinearImpulse( -10 * ball.mass, 0, ball.x, ball.y )
ball.angularDamping = 0.5
ball.linearDamping = 0.5

local rectangle = display.newRect( screenGroup, display.contentCenterX + 100, display.contentCenterY, 300, 20 )
rectangle.strokeWidth = 1
rectangle:setFillColor( 0.25, 0.5, 0.25  )
rectangle:setStrokeColor( 0, 3, 0 )
physics.addBody( rectangle, "static", { friction = 1 } )

local rectangle = display.newRect( screenGroup, display.contentCenterX - 100, display.contentCenterY + 100, 300, 20 )
rectangle.strokeWidth = 1
rectangle.rotation = 15
rectangle:setFillColor( 0.25, 0.5, 0.25  )
rectangle:setStrokeColor( 0, 3, 0 )
physics.addBody( rectangle, "static", { friction = 1 } )

local rectangle = display.newRect( screenGroup, display.contentCenterX + 200, display.contentCenterY + 200, 300, 20 )
rectangle.strokeWidth = 1
rectangle:setFillColor( 0.25, 0.5, 0.25  )
rectangle:setStrokeColor( 0, 3, 0 )
physics.addBody( rectangle, "static", { friction = 1 } )
