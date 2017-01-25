require "ssk2.loadSSK"
_G.ssk.init( {} )

require "physics"
physics.start( )
physics.setGravity(0,0)

local turretM = require "turretM"
local turrets = {}
local currentTurret

local background = display.newGroup()
local content = display.newGroup()

local function onCollision( self, event ) 
   display.remove(self) 
   return false
end


local function onTouch( self, event )
  if( event.phase ~= "began" ) then return end
  local target = ssk.display.newImageRect( content, event.x, event.y, 
                                         "corona256.png", 
                                         { size = 40, collision = onCollision }, 
                                         { radius = 20 } ) 
  turretM.fire( currentTurret, target )
end

ssk.display.newRect( background, centerX, centerY, 
                     { w = fullw, h = fullh, 
                       fill = _G_, alpha = 0.2,
                       touch = onTouch } )

local function onDropped( self )
  for k,v in pairs( turrets ) do
    v:setFillColor( unpack(_P_) )
  end
  self:setFillColor( unpack(_G_) )
  currentTurret =  self
end

currentTurret = ssk.display.newImageRect( content, centerX - 200, bottom - 75, 
                                         "rg256.png", 
                                         { size = 100, fill = _P_, 
                                           onDropped = onDropped } ) 
ssk.misc.addSmartDrag( currentTurret, { retval = true } )
turrets[currentTurret] = currentTurret


currentTurret = ssk.display.newImageRect( content, centerX, bottom - 75, 
                                         "rg256.png", 
                                         { size = 100, fill = _P_, 
                                           onDropped = onDropped } ) 
ssk.misc.addSmartDrag( currentTurret, { retval = true } )
turrets[currentTurret] = currentTurret

currentTurret = ssk.display.newImageRect( content, centerX + 200, bottom - 75, 
                                         "rg256.png", 
                                         { size = 100, fill = _G_, 
                                           onDropped = onDropped } ) 
ssk.misc.addSmartDrag( currentTurret, { retval = true } )
turrets[currentTurret] = currentTurret



