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

-- replace this to change all animations for debugging 
local testAnim = "rightwalk" --  idle jump rightwalk leftwalk
local timeScale = 1


-- =============================================================
-- Normal anchors
local tmp = display.newSprite( pinkySheet, pinkySeqData )
local x = display.contentCenterX - 300
local y = display.contentCenterY
tmp.x = x
tmp.y = y
tmp:setSequence( testAnim )
tmp:play()
tmp.timeScale = timeScale
display.newText(  testAnim, x, y + 70, native.systemFontBold, 30 )
display.newText(  "anchors == 0.5", x, y + 100, native.systemFontBold, 20 )
display.newCircle( tmp.x, tmp.y, 5 ):setFillColor(1,0,0)
local tmp = display.newRect( x, y, 100, 100) 
tmp:setStrokeColor(1,0,0)
tmp.strokeWidth = 2
tmp:setFillColor(1,1,1,0)
tmp:toBack()

-- =============================================================
-- 0,0
local tmp = display.newSprite( pinkySheet, pinkySeqData )
local x = display.contentCenterX - 100
local y = display.contentCenterY
tmp.anchorX = 0
tmp.anchorY = 0
tmp.x = x - 50
tmp.y = y - 50
tmp:setSequence( testAnim )
tmp:play()
tmp.timeScale = timeScale
display.newText(  testAnim, x, y + 70, native.systemFontBold, 30 )
display.newText(  "anchors == 0", x, y + 100, native.systemFontBold, 20 )
display.newCircle( tmp.x, tmp.y, 5 ):setFillColor(1,0,0)
local tmp = display.newRect( x, y, 100, 100) 
tmp:setStrokeColor(1,0,0)
tmp.strokeWidth = 2
tmp:setFillColor(1,1,1,0)
tmp:toBack()


-- =============================================================
-- 1,1
local tmp = display.newSprite( pinkySheet, pinkySeqData )
local x = display.contentCenterX + 100
local y = display.contentCenterY
tmp.anchorX = 1
tmp.anchorY = 1
tmp.x = x + 50
tmp.y = y + 50
tmp:setSequence( testAnim )
tmp:play()
tmp.timeScale = timeScale
display.newText(  testAnim, x, y + 70, native.systemFontBold, 30 )
display.newText(  "anchors == 1", x, y + 100, native.systemFontBold, 20 )
display.newCircle( tmp.x, tmp.y, 5 ):setFillColor(1,0,0)
local tmp = display.newRect( x, y, 100, 100) 
tmp:setStrokeColor(1,0,0)
tmp.strokeWidth = 2
tmp:setFillColor(1,1,1,0)
tmp:toBack()


-- =============================================================
-- 0.2, 0.8
local tmp = display.newSprite( pinkySheet, pinkySeqData )
local x = display.contentCenterX + 300
local y = display.contentCenterY
tmp.anchorX = 0.2
tmp.anchorY = 0.8
tmp.x = x - 20
tmp.y = y + 20
tmp:setSequence( testAnim )
tmp:play()
tmp.timeScale = timeScale
display.newText(  testAnim, x, y + 70, native.systemFontBold, 30 )
display.newText(  "anchors == <0.2,0.8>", x, y + 100, native.systemFontBold, 20 )
display.newCircle( tmp.x, tmp.y, 5 ):setFillColor(1,0,0)
local tmp = display.newRect( x, y, 100, 100) 
tmp:setStrokeColor(1,0,0)
tmp.strokeWidth = 2
tmp:setFillColor(1,1,1,0)
tmp:toBack()
