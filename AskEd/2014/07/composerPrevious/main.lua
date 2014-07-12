-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

local composer = require "composer"

composer.gotoScene( "scene1" )
