local lifetime = 5000
local projectileCount = 3
local spread = 7
local bulletSpeed = 300

local turretM = {}



local function onCollision2( self, event ) 
   if( event.other.myType == "bullet" ) then return false end
   display.remove(self) 
   return false
end

function turretM.fire( turret, target )
   local vec = ssk.math2d.diff( turret, target )  
   local angle0 = ssk.math2d.vector2Angle(vec)
   
   local angle = angle0 - spread * (projectileCount-1)/2 
   for i = 1, projectileCount do      
      local vec2 = ssk.math2d.angle2Vector( angle, true )
      vec2 = ssk.math2d.normalize(vec2)
      vec2 = ssk.math2d.scale( vec2, bulletSpeed )

      local bullet = ssk.display.newImageRect( target.group, turret.x, turret.y, 
                                               "arrow.png", 
                                               { size = 20, rotation = angle, 
                                                 collision = onCollision2,
                                                 myType = "bullet", 
                                                 fill = _Y_ },
                                               { isSensor = true, radius = 10} ) 

      bullet:toBack()
      bullet:setLinearVelocity( vec2.x, vec2.y )      
      bullet.timer = display.remove
      timer.performWithDelay( lifetime, bullet )
      angle = angle + spread
   end
end

return turretM
