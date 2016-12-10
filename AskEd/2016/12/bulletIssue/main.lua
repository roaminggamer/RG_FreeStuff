io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

-- IGNORE ABOVE THIS LINE
-- =============================================
-- EXAMPLE BEGIN
-- =============================================
local physics=require("physics")
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode('hybrid')

--[[
local rect = display.newRect( display.contentCenterX, display.contentCenterY, 70, 15 )
rect:setFillColor( 0.5, 0.2, 0.2 )
physics.addBody(rect, "static", { friction = 2, density=5 } )

local ball = display.newCircle( display.contentCenterX, display.contentCenterY - 150, 10)
physics.addBody(ball, "dynamic", {radius=10, bounce = 0.1, density=.1})
ball:setFillColor( 1.5, 0.2, 0.2 )
ball:setStrokeColor( 0, 0, 5 )
ball.isBullet = true
ball:applyLinearImpulse( 0, 100 * ball.mass, ball.x, ball.y )
--]] 
--[[

local function touch(self,event)
   display.remove( self )
end

local numberball = 3

local function spawnball()
   for i = 1 , numberball do
      local ball = display.newCircle(60, 60, 13) 

      ball.x = math.random(10, 300);
      ball.y = 50;

      ball:setFillColor( 0, 5, 0 )

      physics.addBody(ball, "dynamic", {density=0.1, bounce=0.1, friction=0.1, radius=0})
      ball:applyLinearImpulse(-.05, .05, 0, 0) -- you first need to add a physics body before you apply linear impulse

      ball.touch = touch
      ball:addEventListener("touch")

    end
end

spawnball()
--]]