io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
-- =====================================================

local raining = true

local function newDrop( oy )
	local x = cx + math.random( -fullw/2, fullw/2)
	local y = top - 100 - oy
	local endY = bottom + 100
	local speed = math.random(200,500)
	local width = math.random(1,4)
	local height = math.random(10,25)
	local time = 1000 * (endY - y)/speed
	local drop = display.newRect( x, y, width, height )
	transition.to( drop, { y = endY, time = time, onComplete = display.remove } )
end

local function doRain()
	if( not raining ) then return end
	for i = 1, 4 do
		newDrop( math.random(0, 200) )
	end
	timer.performWithDelay( math.random(30,120), doRain )
end

doRain()
