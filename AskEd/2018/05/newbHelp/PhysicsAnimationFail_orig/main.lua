-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Created by: Kris
-- Created on: May 2018
-- 
-- 
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)
 
centerX = display.contentWidth * .2
centerY = display.contentHeight * .5

local sheetOptionsIdle =
{
    width = 587,
    height = 707,
    numFrames = 10
}
local sheetIdleKnight = graphics.newImageSheet( "./assets/spritesheets/knightIdle.png", sheetOptionsIdle )

local sheetOptionsJump =
{
    width = 587,
    height = 707,
    numFrames = 10
}
local sheetJumpKnight = graphics.newImageSheet( "./assets/spritesheets/knightRunning.png", sheetOptionsJump )

local sheetOptionsWalk =
{
    width = 587,
    height = 707,
    numFrames = 10
}
local sheetWalkKnight = graphics.newImageSheet( "./assets/spritesheets/knightWalking.png", sheetOptionsWalk )

-- sequences table
local sequence_data = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 1,
        sheet = sheetIdleKnight
    },
    {
        name = "jump",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 1,
        sheet = sheetJumpKnight
    },
    {
        name = "walk",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 1,
        sheet = sheetWalkKnight
    }
}


local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )
--physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only

local playerBullets = {} -- Table that holds the players Bullets

local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
-- myRectangle.strokeWidth = 3
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
leftWall.alpha = 0.0
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround1 = display.newImage( "./assets/sprites/land.png" )
theGround1.x = 520
theGround1.y = display.contentHeight
theGround1.id = "the ground"
physics.addBody( theGround1, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround2 = display.newImage( "./assets/sprites/land.png" )
theGround2.x = 1520
theGround2.y = display.contentHeight
theGround2.id = "the ground" -- notice I called this the same thing
physics.addBody( theGround2, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local knight = graphics.newImageSheet( "./assets/spritesheets/knightIdle.png", sheetOptionsIdle )
knight.x = display.contentCenterX - 200
knight.y = display.contentCenterY
knight.id = "knight"
physics.addBody( knight, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
knight.isFixedRotation = true

local dPad = display.newImage( "./assets/sprites/d-pad.png" )
dPad.x = 150
dPad.y = display.contentHeight - 150
dPad.alpha = 0.50
dPad.id = "d-pad"

local upArrow = display.newImage( "./assets/sprites/upArrow.png" )
upArrow.x = 150
upArrow.y = display.contentHeight - 260
upArrow.id = "up arrow"

local downArrow = display.newImage( "./assets/sprites/downArrow.png" )
downArrow.x = 150
downArrow.y = display.contentHeight - 45
downArrow.id = "down arrow"

local leftArrow = display.newImage( "./assets/sprites/leftArrow.png" )
leftArrow.x = 40
leftArrow.y = display.contentHeight - 150
leftArrow.id = "left arrow"

local rightArrow = display.newImage( "./assets/sprites/rightArrow.png" )
rightArrow.x = 260
rightArrow.y = display.contentHeight - 150
rightArrow.id = "right arrow"

local jumpButton = display.newImage( "./assets/sprites/jumpButton.png" )
jumpButton.x = display.contentWidth - 50
jumpButton.y = display.contentHeight - 80
jumpButton.id = "jump button"
jumpButton.alpha = 0.5

local shootButton = display.newImage( "./assets/sprites/shootButton.png" )
shootButton.x = display.contentWidth - 200
shootButton.y = display.contentHeight - 80
shootButton.id = "shootButton"
shootButton.alpha = 0.5


-- After a short time, swap the sequence to 'seq2' which uses the second image sheet
local function swapSheet()
    knight:setSequence( "Jump" )
    knight:play()
    print("Jump")
end

local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( knight, { 
            x = 150, 
            y = 0, 
            time = 1000
            } )
        knight:setSequence( "walk" )
        knight:play()
    end

    return true
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( knight, { 
            x = -150, 
            y = 0, 
            time = 1000
            } )
        knight:setSequence( "walk" )
        knight:play()
    end


    return true
end

function downArrow:touch( event )
   if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( knight, { 
            x = 0, 
            y = 150, 
            time = 1000
            } )
        knight:setSequence( "walk" )
        knight:play()
    end


    return true
end

function upArrow:touch( event )
       if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( knight, { 
            x = 0, 
            y = -150, 
            time = 1000
            } )
        knight:setSequence( "jump" )
        knight:play()
    end


    return true
end

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
                transition.moveBy( knight, { 
            x = 0, 
            y = -150, 
            time = 1000
            } )
        knight:setSequence( "jump" )
        knight:play()
        knight:setLinearVelocity( 0, -750 )
    end

    return true
end

-- rest to idle 
local function resetToIdle (event)
    if event.phase == "ended" then
        knight:setSequence("idle")
        knight:play()
    end
end
 
rightArrow:addEventListener( "touch", rightArrow )
leftArrow:addEventListener( "touch", leftArrow )
upArrow:addEventListener( "touch", upArrow )
downArrow:addEventListener( "touch", downArrow )

jumpButton:addEventListener( "touch", jumpButton )
shootButton:addEventListener( "touch", shootButton )

Runtime:addEventListener( "enterFrame", checkCharacterPosition )
Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )
Runtime:addEventListener( "collision", onCollision )

knight:addEventListener("sprite", resetToIdle)
timer.performWithDelay( 2000, swapSheet )

