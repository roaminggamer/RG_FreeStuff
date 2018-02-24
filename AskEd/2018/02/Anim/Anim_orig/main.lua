-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

WIDTH, HEIGHT, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5

local json = require("json")

require "mouths.bubble_1_seq"

APPname = "Lion"

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- try for as much random as we can
math.randomseed(os.time())

-- load menu screen
composer.gotoScene( "words" )
