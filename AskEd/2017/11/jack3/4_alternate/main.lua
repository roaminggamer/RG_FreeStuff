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
local barWidth = 254
local barHeight = 72
local progressBarM = require "progressBar"
local hud1 = progressBarM.new( group2, 0, 0 - 100, { debugEn = true } )
local hud2 = progressBarM.new( group2, 0, 0, 
                               { width = barWidth, height = barHeight, debugEn = true } )
local hud3 = progressBarM.new( group2, 0, 0 + 80, { debugEn = true } )
--
local percent = 100
hud1:set(percent/100)
hud2:set(percent/100)
hud3:set(percent/100)
--
local label = display.newText( group2, percent, 0, 160 )
--
local back = display.newRect( group2, 0, 0, barWidth, barWidth * 1.5 )
back:setFillColor(0.25,0.25,0.25)
back:toBack()
-- 
--
local outline
local dir = -1
local function scaleAndMore()
	--
	percent = percent + dir
	if( percent == 0 ) then 
	   dir = 1
	elseif( percent == 100 ) then 
	   dir = -1 
	end
	--
	local scaleFactor = 1 + percent/100
	group2.xScale = scaleFactor
	group2.yScale = scaleFactor
	--
	display.remove(outline)
	-- Use back instead of group
	outline = display.newRect( group2.x, group2.y, back.contentWidth-2, back.contentHeight-2 )
	outline:setFillColor(0,0,0,0)
	outline.strokeWidth = 2
	--
	label.text = percent
	hud1:set(percent/100)
	hud2:set(percent/100)
	hud3:set(percent/100)
	hud3.rotation = hud3.rotation + 1  
end

timer.performWithDelay( 10, scaleAndMore, -1)


