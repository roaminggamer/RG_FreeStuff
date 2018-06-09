io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
-- == Uncomment following lines if you need  physics
local physics = require "physics"
physics.start()
physics.setGravity(0,20)
--physics.setDrawMode("hybrid")
--
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================
-- EXAMPLE BELOW
-- =====================================================
local ballRadius = 20

local ball = display.newCircle( cx, bottom - 80, ballRadius )
ball.factor = 0.06
ball.limit = 50
ball:setFillColor( 1, 0, 0 )

physics.addBody( ball, "dynamic", { radius = ballRadius, bounce = 0 } )
ball.linearDamping = 1

function ball.enterFrame(self)
	display.remove(self.line)
	if( not self.lx ) then return end	
	self.line = display.newLine( self.x, self.y, self.lx, self.ly )
	self.line:setStrokeColor(1,1,0)
	self.line.strokeWidth = 4

end
Runtime:addEventListener( "enterFrame", ball )

function ball.finalize( self )
	Runtime:removeEventListener( "enterFrame", self )
end
ball:addEventListener("finalize")


local ground = display.newRect( cx, bottom - 50, fullw, 40)
physics.addBody( ground, "static")

function ball:touch( event )
   local id = event.id
   if(event.phase=="began") then
      display.getCurrentStage( ):setFocus( self, id )
      self.isFocus = true
      --
      self.t0 = system.getTimer()
      --

   elseif(self.isFocus) then
      if(event.phase=="moved") then
   	   self.lx = event.x
	      self.ly = event.y

      elseif((event.phase=="ended")or(event.phase=="cancelled")) then
         display.getCurrentStage( ):setFocus( self, nil )
         self.isFocus = nil
         --
         local dt = (system.getTimer() - self.t0)/1000
         --
         local dx = event.x - event.xStart
         local dy = event.y - event.yStart
         print(dx,dy)
         local distance = math.sqrt( dx * dx + dy * dy )  
         -- This is how you normalize (not by using math.abs()):
         local vx = dx/distance
         local vy = dy/distance
         --
         local magnitude = self.factor * distance/dt                 
         --print( distance, dt, magnitude, self.t0, system.getTimer(), dx, dy )
         magnitude = (magnitude > self.limit) and self.limit or magnitude
         magnitude = magnitude * self.mass         
         --
         self:applyLinearImpulse( vx * magnitude, vy * magnitude, self.x, self.y )
         --
   	   self.lx = nil
	      self.ly = nil
	      --
       end
   end
end
ball:addEventListener( "touch" )

-- =====================================================
-- EXAMPLE ABOVE
-- =====================================================


