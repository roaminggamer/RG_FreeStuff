-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
--  main.lua
-- =============================================================
-- Start (code/comments)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { } )
-- =============================================================
-- Optionally enable meters to check FPS and Memory usage.
-- =============================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
-- =============================================================
local font = "saranaigame-bold-webfont.ttf" -- FROM : https://github.com/chewax/web-site/tree/master/games/superhero/assets/fonts/webfonts
--local font = "saranaigamebold.ttf"

local newText = display.newText
local text = ssk.misc.getLorem( 100, " ", true )
local fontSize = 20
local tmp
local curY = top + 5
for i = 1, 20 do
	tmp = newText( text, 10, curY, font, fontSize )
	tmp.anchorX = 0
	tmp.anchorY = 0
	curY = curY + tmp.contentHeight + 10
	fontSize = fontSize + 1 
end