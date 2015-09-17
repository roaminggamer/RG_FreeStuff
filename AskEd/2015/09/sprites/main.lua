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
local pinkySeqData = 
	{
		{ name = "idle", frames = {2}, time = 1000, loopCount = 0, loopDirection = "forward"}, 
		{ name = "jump", frames = {1}, time = 1000, loopCount = 0, loopDirection = "forward"}, 
		{name = "rightwalk", frames = {3,4,5,6,7,8,9,10,11,12,13 }, time = 500, loopCount = 0, loopDirection = "forward"}, 
		{name = "leftwalk", frames = {3,4,5,6,7,8,9,10,11,12,13 }, time = 500, loopCount = 0, loopDirection = "forward"}, 
	}


-- Create sprite, play 'idle'
local tmp = display.newSprite( pinkySheet, pinkySeqData )
tmp.x = display.contentCenterX - 300
tmp.y = display.contentCenterY
tmp:setSequence( "idle" )
tmp:play()
display.newText(  "idle", tmp.x, tmp.y + 70, native.systemFontBold, 30 )



-- Create sprite, play 'jump'
local tmp = display.newSprite( pinkySheet, pinkySeqData )
tmp.x = display.contentCenterX - 100
tmp.y = display.contentCenterY
tmp:setSequence( "jump" )
tmp:play()
display.newText(  "jump", tmp.x, tmp.y + 70, native.systemFontBold, 30 )



-- Create sprite, play 'rightwalk'
local tmp = display.newSprite( pinkySheet, pinkySeqData )
tmp.x = display.contentCenterX + 100
tmp.y = display.contentCenterY
tmp:setSequence( "rightwalk" )
tmp:play()
display.newText(  "rightwalk", tmp.x, tmp.y + 70, native.systemFontBold, 30 )



-- Create sprite, play 'leftwalk'
local tmp = display.newSprite( pinkySheet, pinkySeqData )
tmp.x = display.contentCenterX + 300
tmp.y = display.contentCenterY
tmp.xScale = -1
tmp:setSequence( "leftwalk" )
tmp:play()
display.newText(  "leftwalk", tmp.x, tmp.y + 70, native.systemFontBold, 30 )
