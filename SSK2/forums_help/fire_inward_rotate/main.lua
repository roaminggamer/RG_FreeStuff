require "ssk2.loadSSK"
_G.ssk.init( {} )

require "physics"
physics.start( )
physics.setGravity(0,0)

local turretM = require "turretM"

local background = display.newGroup()
local content = display.newGroup()

local function onTouch( self, event )
  if( event.phase ~= "ended" ) then return end
  local target = ssk.display.newImageRect( content, event.x, event.y, 
                                         "corona256.png", 
                                         { size = 40, collision = display.remove }, 
                                         { radius = 20 } ) 

  turretM.fireInward( target, 
                      { numBullets = math.random( 5, 10 ), 
                        radius = 200, 
                        rotRate = math.random( -180, 180 ),
                        moveRate = 100 } )
end

ssk.display.newRect( background, centerX, centerY, 
                     { w = fullw, h = fullh, 
                       fill = _G_, alpha = 0.2,
                       touch = onTouch } )



