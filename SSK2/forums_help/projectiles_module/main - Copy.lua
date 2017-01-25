require "ssk2.loadSSK"
_G.ssk.init( {} )

require "physics"
physics.start( )
physics.setGravity(0,0)

local lifetime = 5000
local projectileCount = 3
local spread = 7
local bulletSpeed = 300
local turret
local fireTurret
local lastTarget

local background = display.newGroup()
local content = display.newGroup()

local function onCollision( self, event ) 
   display.remove(self) 
   return false
end
local function onCollision2( self, event ) 
   if( event.other.myType == "bullet" ) then return false end
   display.remove(self) 
end

local function onTouch( self, event )
  if( event.phase ~= "began" ) then return end
  lastTarget = ssk.display.newImageRect( content, event.x, event.y, 
                                         "corona256.png", 
                                         { size = 40, collision = onCollision }, 
                                         { radius = 20 } ) 
  fireTurret()
end

ssk.display.newRect( background, centerX, centerY, 
                     { w = fullw, h = fullh, 
                       fill = _G_, alpha = 0.2,
                       touch = onTouch } )

turret = ssk.display.newImageRect( content, centerX, bottom - 75, 
                                         "rg256.png", { size = 100 } ) 
ssk.misc.addSmartDrag( turret )

fireTurret = function()
   local vec = ssk.math2d.diff( turret, lastTarget )  
   local angle0 = ssk.math2d.vector2Angle(vec)
   
   local angle = angle0 - spread * (projectileCount-1)/2 
   for i = 1, projectileCount do      
      local vec2 = ssk.math2d.angle2Vector( angle, true )
      vec2 = ssk.math2d.normalize(vec2)
      vec2 = ssk.math2d.scale( vec2, bulletSpeed )

      local bullet = ssk.display.newImageRect( content, turret.x, turret.y, 
                                               "arrow.png", 
                                               { size = 20, rotation = angle, 
                                                 collision = onCollision2,
                                                 myType = "bullet", 
                                                 fill = randomColor() },
                                               { isSensor = true, radius = 10} ) 

      bullet:toBack()
      bullet:setLinearVelocity( vec2.x, vec2.y )      
      bullet.timer = display.remove
      timer.performWithDelay( lifetime, bullet )
      angle = angle + spread
   end
end






-- Assuming this is MM/DD/YYYY
--
-- Personal Note: I hate civilian dates for this very reason: Ambiguous and easy to forget.
--
local date = "12/4/2016"
local parts = string.split( date, "/" )
print( parts[1], parts[2], parts[3] ) -- Prints: 12 4 2016
local encoded = os.time( { day = tonumber(parts[2]), 
                         month = tonumber(parts[1]),
                         year = tonumber(parts[3]) } )
print( encoded )
local weekday = os.date("%A",encoded)
local month = os.date("%B",encoded)
print( weekday, month)