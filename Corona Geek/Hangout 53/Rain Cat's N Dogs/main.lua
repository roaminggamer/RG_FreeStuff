-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local screenW, screenH = display.contentWidth, display.contentHeight

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

group = display.newGroup()

local g = graphics.newGradient(
  { 100, 100, 100 },
  { 100, 100, 100 },
  "down" )

--local bg = display.newRect( 0, 0, screenW, screenH-50)
--bg:setFillColor( g )
--bg.alpha = 0.2
--group:insert(bg)

local rain = require("rain")

rain.new(group, {})