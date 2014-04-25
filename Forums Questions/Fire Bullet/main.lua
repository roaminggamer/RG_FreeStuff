
-- Including (trimmed down version of my lib) SSK to get useful globals
-- and to do HEAVY math and collision calculation lifting
--
require "ssk.globals.variables"
require "ssk.globals.functions"
local math2d = require "ssk.RGMath2D"
local ccmgr = require "ssk.RGCC"

-- Localizing a bunch of functions for speedup ( and )
--
-- SSK Forward Declarations
local angle2Vector      = math2d.angle2Vector
local vector2Angle      = math2d.vector2Angle
local scaleVec          = math2d.scale
local addVec            = math2d.add
local subVec            = math2d.sub
local normVec           = math2d.normalize
local getNormals        = math2d.normals
local vecLen            = math2d.length
local vecLen2           = math2d.length2

-- Lua and Corona Forward Declarations
local mAbs              = math.abs
local mRand             = math.random
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format


local physics = require "physics"


-- ===========================
-- Change following line to try examples
-- =========================== 
local version  = 1 -- 1, 2, or 3 (try each)

-- Forward Declare Variables and Functions
local bulletMoveTime    = 10000 -- used for transition bullets
local bulletSpeed       = 150 -- Used for velocity bullets
local playerMoveTime    = 750
local thePlayer 
local theTurret

local fireBullet

local createPlayer

-- Define Touch Mover Function (to move player)
local function onCompleteMove( self )
    self.isMoving = false
end
local onTouch = function( self, event )
    if( event.phase ~= "ended" ) then return true end

    -- Don't allow new touch till player is done moving from last touch
    if( self.isMoving == true) then return true end

    self.isMoving = true

    transition.to( thePlayer, { x = event.x, y = event.y, time = playerMoveTime, onComplete = onCompleteMove  } )

    return true
end

local function selfDestruct( self )
    display.remove(self)
end


-- ==========================================
-- Use transitions and no collision check
-- ==========================================
if( version == 1 ) then 

    createPlayer = function()
        thePlayer = display.newCircle( centerX, centerY + 100, 10 )
        thePlayer:setFillColor(0,1,0)
        thePlayer:setStrokeColor(1,1,0)
        thePlayer.strokeWidth = 2
        thePlayer.touch = onTouch
        thePlayer.isMoving = false
        -- Listen for touches and move the player when it happens
        Runtime:addEventListener( "touch", thePlayer )
        return thePlayer
    end

    fireBullet = function( )
        -- 1. Calculate vector from turret to player
        local destVec = subVec( theTurret, thePlayer )

        -- 2. Normalize the vector
        destVec = normVec( destVec ) 

        -- 3. Scale it so it is bigger than any possible crossing of screen
        destVec = scaleVec( destVec, w * 3 )

        -- 4. Add to turret position to get destination position
        destVec = addVec( destVec, theTurret )    


        local bullet = display.newCircle( theTurret.x, theTurret.y, 5 )
        bullet:toBack()

        transition.to( bullet, { x = destVec.x, y = destVec.y, time = bulletMoveTime, onComplete = selfDestruct } )
    end



-- ==========================================
-- Use transitions and physics body for collision check
-- ==========================================
elseif( version == 2 ) then 
    physics.start()
    physics.setGravity( 0, 0 )

    local myCC = ssk.ccmgr:newCalculator()
    myCC:addNames( "bullet", "player" )
    myCC:collidesWith( "bullet", "player" )


    createPlayer = function()
        thePlayer = display.newCircle( centerX, centerY + 100, 10 )
        thePlayer:setFillColor(0,1,0,0.5)
        thePlayer:setStrokeColor(1,1,0)
        thePlayer.strokeWidth = 2
        thePlayer.touch = onTouch
        thePlayer.isMoving = false
        -- Listen for touches and move the player when it happens
        Runtime:addEventListener( "touch", thePlayer )
        physics.addBody( thePlayer, "dynamic", { radius = 10, filter = myCC:getCollisionFilter( {"player"} ) } ) 
        return thePlayer
    end

    fireBullet = function( )
        -- 1. Calculate vector from turret to player
        local destVec = subVec( theTurret, thePlayer )

        -- 2. Normalize the vector
        destVec = normVec( destVec ) 

        -- 3. Scale it so it is bigger than any possible crossing of screen
        destVec = scaleVec( destVec, w * 3 )

        -- 4. Add to turret position to get destination position
        destVec = addVec( destVec, theTurret )    


        local bullet = display.newCircle( theTurret.x, theTurret.y, 5 )
        bullet:toBack()

        bullet.collision = function( self, event )
            if( event.other == thePlayer ) then 

                timer.performWithDelay(1,
                    function()
                        display.remove(self)
                    end )
            end
            return true 
        end
        bullet:addEventListener( "collision" )

        physics.addBody( bullet, "dynamic", { radius = 5, isSensor = true, filter = myCC:getCollisionFilter( {"bullet"} ) } )

        transition.to( bullet, { x = destVec.x, y = destVec.y, time = bulletMoveTime, onComplete = selfDestruct } )
    end


-- ==========================================
-- Use pure physics no transitions (except player movement)
-- ==========================================
elseif( version == 3 ) then 
    physics.start()
    physics.setGravity( 0, 0 )

    local myCC = ssk.ccmgr:newCalculator()
    myCC:addNames( "bullet", "player" )
    myCC:collidesWith( "bullet", "player" )


    createPlayer = function()
        thePlayer = display.newCircle( centerX, centerY + 100, 10 )
        thePlayer:setFillColor(0,1,0,0.5)
        thePlayer:setStrokeColor(1,1,0)
        thePlayer.strokeWidth = 2
        thePlayer.touch = onTouch
        thePlayer.isMoving = false
        -- Listen for touches and move the player when it happens
        Runtime:addEventListener( "touch", thePlayer )
        physics.addBody( thePlayer, "dynamic", { radius = 10, filter = myCC:getCollisionFilter( {"player"} ) } ) 
        return thePlayer
    end

    fireBullet = function( )
        -- 1. Calculate vector from turret to player
        local velocityVec = subVec( theTurret, thePlayer )

        -- 2. Normalize the vector
        velocityVec = normVec( velocityVec ) 

        -- 3. Scale it so we have the right velocity
        velocityVec = scaleVec( velocityVec, bulletSpeed )


        local function selfDestruct( self )
            display.remove(self)
        end

        local bullet = display.newCircle( theTurret.x, theTurret.y, 5 )
        bullet:toBack()


        bullet.collision = function( self, event )
            if( event.other == thePlayer ) then 

                timer.performWithDelay(1,
                    function()
                        display.remove(self)

                    end )
            end
            return true 
        end
        bullet:addEventListener( "collision" )

        physics.addBody( bullet, "dynamic", { radius = 5, isSensor = true, filter = myCC:getCollisionFilter( {"bullet"} ) } )

        bullet:setLinearVelocity( velocityVec.x, velocityVec.y )

        -- Destroy bullet in 10 seconds regardless of collision
        timer.performWithDelay( 10000, function() display.remove( bullet ) end )

    end

end

-- Create a 'Turret'
theTurret = display.newCircle( centerX, centerY, 15 )
theTurret:setFillColor(1,0,0,0.5)
theTurret:setStrokeColor(1,0,1)
theTurret.strokeWidth = 2

-- Create The Player
createPlayer()

-- Fire a bullet once per second, forever
timer.performWithDelay( 1000, fireBullet, -1  ) 






