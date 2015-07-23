-- answer to this post: https://forums.coronalabs.com/topic/57612-question-about-values/#entry298063
local composer = require( "composer" )
 
local physics = require( "physics" )
physics.start()
physics.setGravity(0, 15)

-- display ground image
local ground = display.newImageRect( "ground.png", 500, 100 )
ground.x = 145 
ground.y = 480
ground.myName = "ground"
 
physics.addBody( ground, "static" , { friction=0.5, bounce=0.1 } )
 
local crate = display.newImageRect( "crate.png", 90, 90 )
crate.x = 60 
crate.y = 20
crate.rotation = 0
physics.addBody( crate, "dynamic" , { friction=0.5, bounce=0.3 } )

local function onCollision( self, event )
   local other = event.other
   print("onCollision()", event.phase, self.isCrate, other.isGround)
   if( event.phase == "began" and self.isCrate and other.isGround ) then
         timer.performWithDelay( 30, 
         	function()
         		print("Calling composer open scene...") 
         		-- composer.openScene( "restart.lua" ) 
         	end )
		self:removeEventListener( "collision") 
    end
   return true
end
  
crate.collision = onCollision
crate:addEventListener( "collision" ) 