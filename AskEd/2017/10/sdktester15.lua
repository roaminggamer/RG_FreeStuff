-- RG - I changed this to 3-space indent as 2- is too hard for me to read...

--explosion.lua

-- Locals (need only define these once; doing it on each call to 'new' was a waste)
local explosionInfo  = require "sprite.lua.explosion"
local explosionSheet = graphics.newImageSheet("sprite/png/explosion.png", explosionInfo:getSheet())
local explosionData  = {name = "explosion", start = explosionInfo:getFrameIndex("explosion1"), count = 8, time = 500, loopCount = 1}

local M = {}

function M.new( group, x, y, xScale, yScale, xOffset, yOffset)
   -- It is nice to provide defaults for those variables you might not always want to pass
   xScale = xScale or 1
   yScale = yScale or 1
   xOffset = xOffset or 0
   yOffset = yOffset or 0

   local explosion = display.newSprite(group, explosionSheet, explosionData)
   explosion.x, explosion.y = x + xOffset, y + yOffset    
   explosion.xScale, explosion.yScale = xScale, yScale
   explosion:play()
   end
return M

-------------------------------------------------------------------------------------------------------------------------------------

--bullet.lua

-- Requires
local explosion = require "other.explosion"

-- Locals
local bulletCollisionFilter = {categoryBits = 4, maskBits = 2}

-- Localize math functions 
-- (FASTER execution; Makes typing function names EASIER; Makes code more LEGIBLE)
local angle2Vector   = ssk.math2d.angle2Vector
local vecNorm        = ssk.math2d.normalize
local vecScale       = ssk.math2d.scale
local vecAdd         = ssk.math2d.add

-- Forward decalare common functions/methods
local createBullet
local collision1 -- needs a better name...

local M = {}

   function M.new(group, object)   
      object.bullets = {}
      object.bullets[1] = createBullet( group, object.x, object.y, bulletCollisionFilter, -26, -20)
      object.bullets[2] = createBullet( group, object.x, object.y, bulletCollisionFilter, 26, -20)


      for i = 1, #object.bullets do
         local bullet = object.bullets[i]
         local vx, vy = object:getLinearVelocity()

         local vec1 = angle2Vector( object.rotation + 180, true)
         vec1 = vecNorm( vec1 )
         vec1 = vecScale( vec1, bullet.yOffset )
         vec1 = vecAdd( vec1, object )

         local vec2 = angle2Vector( object.rotation + 90, true )
         vec2 = vecNorm( vec2 )
         vec2 = vecScale( vec2, bullet.xOffset )

         bullet.rotation = object.rotation - 90 -- RG: Why -90?
         bullet.x = vec1.x + vec2.x
         bullet.y = vec1.y + vec2.y
         bullet:setLinearVelocity(vx * 4, vy * 4)

         -- This is more compact and still 100% safe
         -- Compare it to your original to see that this is the same action.
         -- Also, there is no need to specify 1 as it is the default iteration count
         bullet.timer = display.remove
         timer.performWithDelay( 5000, bullet ) 
         
         bullet.collision = collision1
         
         -- RG INCORRECT (you are confusing listener types/categories; 
         --           we talked about this in another thread)
         -- listen("collision", bullet)
         
         -- RG CORRECT
         bullet:addEventListener("collision")
      end
   end

-- Define common functions (forward declared above)
createBullet function (group, x, y, filter, xOffset, yOffset)
   local bullet = display.newImageRect(group, "sprite/ship/Bullet.png", 32, 33)
   physics.addBody(bullet, "dynamic", {filter = filter})
   bullet.x, bullet.y = x, y
   bullet.damage = 25
   bullet:toBack()
   bullet.xOffset, bullet.yOffset = xOffset, yOffset   
   return bullet
end

collision1 = function (self, event)
   if event and event.phase == "began" then
      -- RG notice how I'm putting the explision in the object's parent?  That is the group the object
      -- is in.  All objects are in a group even if you don't do it explicitly.
      -- The implied group is display.currentStage (top group)
      -- In your case, the group is the one you passed in.      
      explosion.new( self.parent, self.x, self.y, 0.5, 0.5, math.random(-10, 10), math.random(-10, 10))

      -- Tip: If you need the group to be something other than the 'ship' group, do this:
      --[[
         ship.bulletGroup = ... other group here
         ... then later
         explosion.new( self.bulletGroup, self.x, self.y, 0.5, 0.5, math.random(-10, 10), math.random(-10, 10))
      ]]
      -- However, I think this will do what you want..

      display.remove(self)
   end
end

-- Very last... return the module
return M

-------------------------------------------------------------------------------------------------------------------------------------

--ship.lua
local bullet = require "bullet"

local function shoot()
   local vx, vy = ship:getLinearVelocity()
   if (vx < -100 or vx > 100) or (vy < -100 or vy > 100) then
      bullet.new(group, ship)
   end
end

local shootTimer = timer.performWithDelay(100, shoot, 0)