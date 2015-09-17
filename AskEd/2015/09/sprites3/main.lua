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


local zzzInfo 	= require "zzz"
local zzzSheet 	= graphics.newImageSheet("zzz.png", zzzInfo:getSheet() )
local zzzSeqData = 
	{
		{name = "snooze", frames = {1,2,3 }, time = 500, loopCount = 0, loopDirection = "forward"}, 
		{name = "snooze2", frames = {1,2,3}, time = 1500, loopCount = 0, loopDirection = "forward"}, 
	}


-- Create sprite, play 'idle'
local tmp = display.newSprite( zzzSheet, zzzSeqData )
tmp.x = display.contentCenterX
tmp.y = display.contentCenterY
tmp:setSequence( "snooze2" )
tmp:play()
display.newText(  "snooze2", tmp.x, tmp.y + 70, native.systemFontBold, 30 )

