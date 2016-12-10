io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs         = ..., 
              enableAutoListeners   = true,
              exportCore        = true,
              exportColors      = true,
              exportSystem      = true,
              exportSystem      = true,
              debugLevel        = 0 } )


-- IGNORE ALL ABOVE

local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode( "hybrid" )

-- Collisions calculator (names are easier than numbers!)
local myCC = ssk.cc:newCalculator()
myCC:addNames( "ball", "wall" )
myCC:collidesWith( "ball", { "wall" } )


-- Group to contain all physics objects.
local group = display.newGroup()
group.x = centerX
group.y = centerY

local top = ssk.display.newRect( group, 0, 0 - 100, 
                     { w = 300, h = 20, fill = _ORANGE },
                     { calculator = myCC, colliderName = "wall", bodyType = "static",
                       bounce = 1, density = 1  } ) 

local bot = ssk.display.newRect( group, 0, 0 + 100, 
                     { w = 300, h = 20, fill = _ORANGE },
                     { calculator = myCC, colliderName = "wall", bodyType = "static",
                       bounce = 1, density = 1  } ) 

local left = ssk.display.newRect( group, 0 - 140 , 0, 
                     { w = 20, h = 180, fill = _ORANGE },
                     { calculator = myCC, colliderName = "wall", bodyType = "static",
                       bounce = 1, density = 1  } ) 

local right = ssk.display.newRect( group, 0 + 140 , 0, 
                     { w = 20, h = 180, fill = _ORANGE },
                     { calculator = myCC, colliderName = "wall", bodyType = "static",
                       bounce = 1, density = 1  } ) 

local ball1 = ssk.display.newCircle( group, 0, 0, 
                     { radius = 10, fill = _Y_ },
                     { calculator = myCC, colliderName = "ball", bounce = 1, density = 1  } )
local ball2 = ssk.display.newCircle( group, 0, 0, 
                     { radius = 10, fill = _C_ },
                     { calculator = myCC, colliderName = "ball", bounce = 1, density = 1  } )

local angle = math.random( 1, 359 )
local vec = ssk.math2d.angle2Vector( angle, true )
vec = ssk.math2d.scale( vec, 200 )
ball1:setLinearVelocity( vec.x, vec.y  )

local angle = math.random( 1, 359 )
local vec = ssk.math2d.angle2Vector( angle, true )
vec = ssk.math2d.scale( vec, 200 )
ball2:setLinearVelocity( vec.x, vec.y )


local sizeUp
local sizeDown

sizeUp = function( )
    transition.to( group, { xScale = 10, yScale = 10, delay = 1000, time = 7000, onComplete = sizeDown } )
end

sizeDown = function( )
    transition.to( group, { xScale = 1, yScale = 1, delay = 1000, time = 7000, onComplete = sizeUp } )
end

sizeUp()