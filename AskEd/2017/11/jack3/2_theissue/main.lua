io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

--
-- Run in simulated "Borderless 610 x 960 iPhone"
--
local fullw = display.actualContentWidth
local fullh = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
--
-- This example explores any issues with bar
-- 
local group = display.newGroup()
local group2 = display.newGroup()
group:insert(group2)
group2.x = centerX
group2.y = centerY
--
local fbm = require "lib.fillbar_m"
local bar = fbm.new( {
  parent=group2,
  x=0,
  y=0, 
  barprefix="runnerlife", 
  useback = true,
  maxval=1000
})
local width = bar.contentWidth
local height = math.floor(1.5 * width)

--
local back = display.newRect( group2, 0, 0, width, height )
back:setFillColor(0.25,0.25,0.25)
back:toBack()
-- align bar right at bottom of 'back'
bar.y = back.y + math.ceil(back.contentHeight/2 - bar.contentHeight/2)
-- Create a bounding rect to show bounds of the bar
local tmp = display.newRect( group2, bar.x, bar.y, bar.contentWidth-2, bar.contentHeight-2 )
tmp:setFillColor(0,0,0,0)
tmp.strokeWidth = 2
--
-- Scale up by factor of 1.5
--local scaleFactor = 1.5
--group2:scale(scaleFactor,scaleFactor)

-- Create a bounding rect to show bounds of group
local tmp = display.newRect( group2.x, group2.y, group2.contentWidth-2, group2.contentHeight-2 )
tmp:setFillColor(0,0,0,0)
tmp.strokeWidth = 2

