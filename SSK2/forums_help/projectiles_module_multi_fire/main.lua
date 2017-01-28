require "ssk2.loadSSK"
_G.ssk.init( {} )

require "physics"
physics.start( )
physics.setGravity(0,0)

local turretM = require "turretM"
local turrets = {}

local background = display.newGroup()
local content = display.newGroup()

local function onTouch( self, event )
  if( event.phase ~= "began" ) then return end
  local target = ssk.display.newImageRect( content, event.x, event.y, 
                                         "corona256.png", 
                                         { size = 40, collision = display.remove }, 
                                         { radius = 20 } ) 

  turretM.fire( turrets, target )
end

ssk.display.newRect( background, centerX, centerY, 
                     { w = fullw, h = fullh, 
                       fill = _G_, alpha = 0.2,
                       touch = onTouch } )

-- line of 5 turrets across the bottom of the example
local ox = fullw/5
for i = 1, 5 do  
   local turret = ssk.display.newImageRect( content, left + (i-1) * ox + ox/2, bottom - 75, 
                                          "rg256.png", { size = 100, fill = _W_ } ) 
   turrets[#turrets+1] = turret
end


