io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
ssk.meters.create_fps(true)
ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
-- == Uncomment following lines if you need  physics
--local physics = require "physics"
--physics.start()
--physics.setGravity(0,10)
--physics.setDrawMode("hybrid")

-- == Uncomment following line if you need widget library
--local widget = require "widget"

-- =====================================================
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end

print(w,h,fullw,fullh)


local nanosvg = require( "plugin.nanosvg" )
 

local slices =  {
	{ percent = .15, color = "#FF0000" },
	{ percent = .75, color = "#00FF00" },
	{ percent = .1, color = "#0000FF" },
	}
	local cumulativePercent = 0
	

for i = 1, #slices do
   
	local percent = slices[i].percent
	local color = slices[i].color
	
	local startX = math.cos( 2 * math.pi * cumulativePercent)
	local startY = math.sin(2 * math.pi * cumulativePercent)
	cumulativePercent = cumulativePercent + percent
	local endX = math.cos( 2 * math.pi * cumulativePercent)
	local endY = math.sin( 2 * math.pi * cumulativePercent)
   
	if percent >= .5 then
		largeArcFlag = 1
	else
		largeArcFlag = 0
	end
	
	local pathData = "M "..startX.." "..startY.." A 1 1 0 "..largeArcFlag.." 1 "..endX.." "..endY.." L 0 0"
	local pathline = "<svg  width='400' height='400' viewBox='-1 -1 2 2' style='transform: rotate(-90deg)'><path d = '"..pathData.."' fill='"..color.."' /></svg>"
	
	--local pill = '<svg version="1.1" width="400" height="400" viewBox="0 0 16 9"><rect x="1" y="1" width="6" height="1.3" fill="silver" stroke="black" stroke-width="0.1" ry="1" rx="1"/></svg>'
	--local pill = '<svg version="1.1" width="500" height="500" viewBox="0 0 10 10"><rect x="1" y="1" width="6" height="1" fill="silver" stroke="green" stroke-width="0.1" ry="1" rx="1"/></svg>'
	local pill = '<svg version="1.1" width="500" height="500" viewBox="0 0 10 10"><rect x="0" y="0" ry="1" rx="1" width="50%" height="20%" stroke="green" stroke-width="0.1" fill = "blue" /></svg>'

	local circle = nanosvg.newImage(
	{
		--data = pathline,
		data = pill,
		x = centerX,
		y = centerY,
	})
   
	--https://codepen.io/deadlygeek/pen/KaqOPG
	--<svg version="1.1" width="1000" height="600" viewBox="0 0 16 9"><rect x="1" y="1" width="6" height="2" fill="silver" stroke="black" stroke-width="0.1" ry="1" rx="1"/></svg>


  

end
