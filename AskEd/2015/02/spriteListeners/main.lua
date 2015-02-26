-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- main.lua
-- =============================================================

local diceData    = require("dice")
local diceSheet = graphics.newImageSheet( "dice.png", diceData:getSheet() )
local sequenceData =
{
    name="rolling",
    start=1,
    count=6,
    time=6000,
    loopCount = 0, 
    loopDirection = "bounce"    -- Optional ; values include "forward" or "bounce"
}

local dieAnim = display.newSprite( diceSheet, sequenceData )
dieAnim.x = 160
dieAnim.y = 240
dieAnim.myLabel = display.newText( "TBD", dieAnim.x, dieAnim.y + 100,  native.systemFont, 32 )

local function spriteListener( self,  event )
    self.myLabel.text = "Frame: " .. self.frame
end

dieAnim.sprite = spriteListener
dieAnim:addEventListener("sprite")
dieAnim:play()
