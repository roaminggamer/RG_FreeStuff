local lifetime = 5000
local projectileCount = 3
local spread = 7
local bulletSpeed = 300

local turretM = {}

local function enterFrame( self )
   if( autoIgnore( "enterFrame", self ) ) then return end

   local curTime = system.getTimer()

   if( not self.lastTime ) then
      self.lastTime = curTime 
      return
   end

   local dt = self.lastTime - curTime

   self.lastTime = curTime

   local vec = ssk.math2d.diff( self, self.target )

   local dm = self.params.moveRate * dt/1000
   local dr = self.params.rotRate * dt/1000

   local len = ssk.math2d.length( vec )

   if( len <= dm or len <= 10 ) then 
      ignore("enterFrame", self)
      display.remove(self)
      return
   end

   local angle = ssk.math2d.vector2Angle( vec )

   angle = angle + dr   
   local vec = ssk.math2d.angle2Vector( angle, true )

   vec = ssk.math2d.scale( vec, len + dm )

   vec = ssk.math2d.add( vec, self.target )

   self.rotation = angle - 180

   self.x = vec.x
   self.y = vec.y

end


local function createTurretList( target, numTurrets, radius )
   local turrets = {}
   local angle = 0
   for i = 1, numTurrets do
      local vec = ssk.math2d.angle2Vector( angle, true )
      vec = ssk.math2d.scale( vec, radius )
      vec = ssk.math2d.add( target, vec )
      turrets[#turrets+1] = vec 
      angle = angle + 360/numTurrets  
   end
   return turrets
end

local function onCollision( self, event ) 
   if( event.other.myType == "bullet" ) then return false end
   ignore("enterFrame",self)
   display.remove(self) 
   return false
end

function turretM.fireInward( target, params )
   local angle = 0
   local turrets = createTurretList( target, params.numBullets, params.radius )

   for i = 1, #turrets do
      local turret = turrets[i] 
      local vec = ssk.math2d.diff( turret, target )  
      local angle = ssk.math2d.vector2Angle(vec)

      local bullet = ssk.display.newImageRect( target.group, turret.x, turret.y, 
                                               "arrow.png", 
                                               { size = 20, rotation = angle, 
                                                 collision = onCollision,
                                                 myType = "bullet", 
                                                 fill = _Y_ },
                                               { isSensor = true, radius = 10} ) 

      bullet.target = { x = target.x, y = target.y }
      bullet.params = params

      bullet.enterFrame = enterFrame
      listen("enterFrame", bullet)
   end
end

return turretM
