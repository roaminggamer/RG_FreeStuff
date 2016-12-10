-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user asked if it was possible to record physics info and replay a physics body.", 
	"",
	"What a cool idea.  Let's see if we can do it."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--
-- Load SSK
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs               = ..., 
                enableAutoListeners     = true,
                exportCore              = true,
                exportColors            = true,
                exportSystem            = true,
                exportSystem            = true,
                debugLevel              = 0 } )
--
-- Forward Declarations
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
-- Create lable to show current style
local actionLabel = display.newText( "Recording", display.contentCenterX, 200, native.systemFont, 42 )

--
-- Set up physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 10 )
--physics.setDrawMode("hybrid")


--
-- Recording and Playback Logic
local recordedFrames = {}
local isRecording   = true
local isPaused      = false
local maxBounces    = 5
local enterFrame
local onCollision
local drawTrail

local currentFrame = 0
local recordFrame
local replayFrame
local startReplay

local function onCollision( self, event )
    if( event.phase == "began" ) then
        self.bounces = self.bounces + 1
        print("Bounce ", self.bounces)

        if( self.bounces > maxBounces ) then
            self:removeEventListener("collision")
            isPaused = true
            timer.performWithDelay( 1, function() startReplay( self ) end )
        end
    end
    return true
end

enterFrame = function( self )
    if( isRecording ) then
        drawTrail( self )
    end
    
    if( isRecording ) then        
        recordFrame( self )
    else
        if( not isPaused ) then
            replayFrame( self )
        end
    end
end

drawTrail = function( self )
    local tmp = display.newRect( self.parent, self.x, self.y, 25, 25 )
    tmp.rotation = self.rotation
    tmp.alpha = 0.1
    tmp:toBack()
    -- Don't fill up memory.  Delete this trail marker after 5.2 seconds.
    --timer.performWithDelay( 5200, function() display.remove( tmp ) end )
end

startReplay = function( self )
    print("Start replay @ ", getTimer())
    isRecording = false
    actionLabel.text = "Playing Back"
    currentFrame = 0
    replayFrame( self )
    isPaused = false
end

replayFrame = function( self )
    --print(currentFrame, #recordedFrames)
    currentFrame = currentFrame + 1
    if( currentFrame > #recordedFrames ) then
        isPaused = true
        timer.performWithDelay( 1, function() startReplay( self ) end )
        return
    end
    local oldFrame = recordedFrames[currentFrame]
    self.x = oldFrame.x
    self.y = oldFrame.y
    self.rotation = oldFrame.rotation
    self.angularVelocity = oldFrame.angularVelocity
    self:getLinearVelocity( oldFrame.vx, oldFrame.vy )
end

recordFrame = function( self )
    currentFrame = currentFrame + 1
    local newFrame = {}
    recordedFrames[currentFrame] = newFrame
    newFrame.x = self.x
    newFrame.y = self.y
    newFrame.rotation = self.rotation
    newFrame.angularVelocity = self.angularVelocity
    newFrame.vx, newFrame.vy = self:getLinearVelocity()
end


--
-- Function to create and fire a block.  
local function fireBlock( turret, angle )
    -- a. Create a 'block' 
    local block = display.newRect( turret.x, turret.y, 25, 25 )

    block.rotation = 15

    block.bounces = 0

	physics.addBody( block, "dynamic", { friction = 0.1, bounce = 0.9 } )
	block:setFillColor(1,1,1,0.5)

	-- b. Generate a random velocity vector and apply to the block
	local speed = 500
	local vec = angle2Vector( angle, true )
	vec = scaleVec( vec, speed )
    block:setLinearVelocity( vec.x, vec.y )

    block:setFillColor(1,0,0)

    -- d. Apply trail
    local count  = 0

    recordFrame( block )

	block.enterFrame = enterFrame
    Runtime:addEventListener( "enterFrame", block )

    block.collision = onCollision
    block:addEventListener("collision")
end

--
-- Create a 'Turret'
local turret = display.newCircle( display.contentCenterX - 380, display.contentCenterY, 15 )
turret:setFillColor(1,0,0,0.5)
turret:setStrokeColor(1,0,1)
turret.strokeWidth = 2

-- Create two walls to hit
--
local ground = display.newRect( display.contentCenterX, display.contentCenterY + 200, 
                                display.actualContentWidth * 5, 40  )
physics.addBody( ground, "static"  )
ground:setFillColor(0,1,0,0.5)

--
-- Fire a block
fireBlock( turret, 135) 
