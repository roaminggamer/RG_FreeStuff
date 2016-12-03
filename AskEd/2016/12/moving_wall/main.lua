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


-- This bit is a little advanced, but you can learn about it here:
-- https://coronalabs.com/blog/2013/11/07/tutorial-repeating-fills-in-graphics-2-0/
--
local wall = display.newRect( display.contentCenterX, display.contentCenterY, 400, 100 )
display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )
wall.fill = { type = "image", filename = "kenney.png"}
wall.fill.scaleX = 0.25
wall.fill.scaleY = 1
wall.fill.x = 0.5
display.setDefault( "textureWrapX", "clampToEdge" )
display.setDefault( "textureWrapY", "clampToEdge" )


wall.myName   = "wall"
wall.isMoving = false

physics.addBody( wall, "dynamic", { density = 0.1, friction = 0.2 } )

wall.isFixedRotation = true

wall.y0 = wall.y


function wall.enterFrame( self )
   if( self.isMoving == false ) then return end
   print("BOB")
   self:applyForce( 0, -5 * self.mass, self.x, self.y )
end

-- This is another table listener
function wall.touch( self, event )
   local phase = event.phase  

   if( phase == "began" ) then 
   	print("MOVE")
      self.isMoving = true

   elseif( phase == "ended" ) then
   	print("STOP")
      self.isMoving = false
      self:setLinearVelocity( 0, 0 )
      self.y = self.y0
   end
  
   return true
end

-- This function will clean up (remove) the
-- Runtime table-listeners when you delete the wall
function wall.finalize( self )
   Runtime:removeEventListener( "enterScreen", self )
   Runtime:removeventListener( "touch", self )
end


-- Start listening 
wall:addEventListener( "finalize" )
Runtime:addEventListener( "enterFrame", wall )
Runtime:addEventListener( "touch", wall )

