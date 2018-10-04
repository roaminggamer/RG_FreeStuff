-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- =============================================================
-- main.lua
-- =============================================================

----------------------------------------------------------------------
--  Misc Configuration & Initialization
----------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)  
system.activate("multitouch")
--io.output():setvbuf("no") 
math.randomseed(os.time());


local pinkyInfo 	= require "pinky"
local pinkySheet 	= graphics.newImageSheet("pinky.png", pinkyInfo:getSheet() )
local pinkySeqData =  { name = "rightwalk", frames = {3,4,5,6,7,8,9,10,11,12,13 }, time = 500, loopCount = 0, loopDirection = "forward", }


-- Create sprite
local pinky = display.newSprite( pinkySheet, pinkySeqData )
pinky.x = display.contentCenterX
pinky.y = display.contentCenterY
pinky:setSequence( "rightwalk" )
display.newText(  "Touch To Advance Frame", pinky.x, pinky.y + 100, native.systemFontBold, 30 )

function pinky.touch( self, event )
	if(event.phase == "ended" ) then
		local frame = self.frame
		frame = frame + 1
		if( frame > #pinkySeqData.frames ) then
			frame = 1
		end		
		self:setFrame( frame )
	end
	return true
end
pinky:addEventListener("touch")

