-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  main.lua
-- =============================================================
-- https://gumroad.com/l/EATFrameOneTime
-- =============================================================

io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

local composer = require "composer"
composer.gotoScene( "scenes.splash" )
--composer.gotoScene( "scenes.home" )