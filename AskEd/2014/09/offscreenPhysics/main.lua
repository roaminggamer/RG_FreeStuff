io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
require "ssk.loadSSK"
local newCircle,newRect,newImageRect,easyIFC,ternary,quickLayers,isDisplayObject,easyPushButton,isInBounds,angle2Vector,vector2Angle,scaleVec,addVec,subVec,getNormals,lenVec,lenVec2,normVec,mAbs,mRand,mDeg,mRad,mCos,mSin,mAcos,mAsin,mSqrt,mCeil,mFloor,mAtan2,mPi,getInfo,getTimer,strMatch,strFormat,pairs,fnn;ssk.al.run()
-- IGNORE ALL ABOVE

local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode( "hybrid" )

-- Collisions calculator (names are easier than numbers!)
local myCC = ssk.ccmgr:newCalculator()
myCC:addNames( "ball", "wall" )
myCC:collidesWith( "ball", "wall"  )


-- Group to contain all physics objects.
local group = display.newGroup()
group.x = centerX
group.y = centerY

local top = newRect( group, 0, 0 - 100, 
                     { w = 300, h = 20, fill = _ORANGE },
                     { calculator = myCC, colliderName = "wall", bodyType = "static",
                       bounce = 1, density = 1  } ) 

local bot = newRect( group, 0, 0 + 100, 
                     { w = 300, h = 20, fill = _ORANGE },
                     { calculator = myCC, colliderName = "wall", bodyType = "static",
                       bounce = 1, density = 1  } ) 

local left = newRect( group, 0 - 140 , 0, 
                     { w = 20, h = 180, fill = _ORANGE },
                     { calculator = myCC, colliderName = "wall", bodyType = "static",
                       bounce = 1, density = 1  } ) 

local right = newRect( group, 0 + 140 , 0, 
                     { w = 20, h = 180, fill = _ORANGE },
                     { calculator = myCC, colliderName = "wall", bodyType = "static",
                       bounce = 1, density = 1  } ) 

local ball1 = newCircle( group, 0, 0, 
                     { radius = 10, fill = _Y_ },
                     { calculator = myCC, colliderName = "ball", bounce = 1, density = 1  } )
local ball2 = newCircle( group, 0, 0, 
                     { radius = 10, fill = _C_ },
                     { calculator = myCC, colliderName = "ball", bounce = 1, density = 1  } )

local angle = mRand( 1, 359 )
local vec = angle2Vector( angle, true )
vec = scaleVec( vec, 200 )
ball1:setLinearVelocity( vec.x, vec.y  )

local angle = mRand( 1, 359 )
local vec = angle2Vector( angle, true )
vec = scaleVec( vec, 200 )
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