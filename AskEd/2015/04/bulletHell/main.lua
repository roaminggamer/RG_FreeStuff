-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================


io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs               = ..., 
                enableAutoListeners     = true,
                exportCore              = true,
                exportColors            = true,
                exportSystem            = true,
                exportSystem            = true,
                debugLevel              = 0 } )


-- Notes for this example ( not part of example )
--
local notes = {
    "",
    "",
	"The asker wanted to know if Corona was suitable for 'bullet hell' style games.", 
	"This example is a testbench for playing with 'bullet hell' implementations.",
    "It measures FPS and bullet counts.  Right now it creates bullets with physics bodies.",
    "You are encouraged to write your own bullet generators to test ideas.",
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 2. Forward Declarations
-- SSK 
local angle2Vector      = ssk.math2d.angle2Vector
local vector2Angle      = ssk.math2d.vector2Angle
local scaleVec          = ssk.math2d.scale
local addVec            = ssk.math2d.add
local subVec            = ssk.math2d.sub
local normVec           = ssk.math2d.normalize
local getNormals        = ssk.math2d.normals
local vecLen            = ssk.math2d.length
local vecLen2           = ssk.math2d.length2
-- Lua and Corona 
local mAbs              = math.abs
local mRand             = math.random
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format

--
-- 3. Create label and meters to show period, per period, FPS, and bullet counts
local bullets = {}
local bulletsPerPeriod  = 3
local firePeriod        = 1
local periodLabel       = display.newText( "Period: " .. tostring( firePeriod) .. " ; Per Period: " .. tostring( bulletsPerPeriod),
                                            display.contentCenterX, 220, native.systemFont, 42 )
local meter = require "meter"
meter.create_fps()
local bulletCounter = meter.create_extra()
bulletCounter.text = 0
bulletCounter.enterFrame = function( self )
    local count = 0
    for k,v in pairs(bullets) do
        count = count + 1
    end
    self.text = count
end
Runtime:addEventListener( "enterFrame", bulletCounter )


--
-- 4. Set up physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode("hybrid")

--
-- 5. Function to create and fire bullet. 
local function fireBullet( turret )    
    
    for i = 1, bulletsPerPeriod do
        -- a. Create a 'bullet' 
        local bullet = display.newCircle( turret.x, turret.y, 5 )
    	physics.addBody( bullet, "dynamic", { radius = 5, isSensor = true } )
    	bullet:setFillColor(math.random(),math.random(),math.random(),0.5)

    	-- b. Generate a random velocity vector and apply to the bullet
    	local speed = 500
    	local vec = angle2Vector( math.random(0,359), true )
    	vec = scaleVec( vec, speed )
    	--print(vec.x, vec.y)
        bullet:setLinearVelocity( vec.x, vec.y )

        -- c. Schedule 'auto-destruct' 
        timer.performWithDelay( 1500, 
            function() 
                display.remove( bullet ) 
                bullets[bullet] = nil
            end )

        -- d. Store reference to bullet for counting
        bullets[bullet] = bullet
    end

    -- Fire again after fire period delay
    timer.performWithDelay( firePeriod, function() fireBullet( turret ) end )
end

--
-- 6. Create a 'Turret' to act as our visual center
local turret = display.newCircle( display.contentCenterX, display.contentCenterY, 15 )
turret:setFillColor(1,0,0,0.5)
turret:setStrokeColor(1,0,1)
turret.strokeWidth = 2

-- 7. Start firing
--
fireBullet(turret)
