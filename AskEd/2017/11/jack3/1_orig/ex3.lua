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
--bar.setValue(500)

local width = bar.contentWidth
local height = math.floor(1.5 * width)

--
local back = display.newRect( group2, 0, 0, width, height )
back:setFillColor(0.25,0.25,0.25)
back:toBack()
-- align bar right at bottom of 'back'
bar.y = back.y + math.ceil(back.contentHeight/2 - bar.contentHeight/2)
--
local tmp1 = display.newRect( group2, -width/2, -height/2, 10, 10  )
tmp1:setFillColor(1,0,0)
tmp1.anchorX = 0
tmp1.anchorY = 0
--
local tmp2 = display.newRect( group2, width/2, -height/2, 10, 10  )
tmp2:setFillColor(0,1,0)
tmp2.anchorX = 1
tmp2.anchorY = 0
--
local tmp3 = display.newRect( group2, width/2, height/2, 10, 10  )
tmp3:setFillColor(0,0,1)
tmp3.anchorX = 1
tmp3.anchorY = 1
--
local tmp4 = display.newRect( group2, -width/2, height/2, 10, 10  )
tmp4:setFillColor(1,1,0)
tmp4.anchorX = 0
tmp4.anchorY = 1

--
-- Scale up by factor of 2 after short delay
local scaleFactor = fullw/width
--[[transition.to( group2, { 
    delay = 1000, 
    time = 5000, 
    xScale = scaleFactor, 
    yScale = scaleFactor 
})]]--

