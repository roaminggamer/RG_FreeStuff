io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
-- == Uncomment following lines if you need  physics
--local physics = require "physics"
--physics.start()
--physics.setGravity(0,10)
--physics.setDrawMode("hybrid")



-- =====================================================
-- EXAMPLE STARTS
-- =====================================================

--
-- 1. Create some groups to help with layering
--

local layers = {}
layers.back = display.newGroup()
layers.trail = display.newGroup()
layers.player = display.newGroup()

--
-- 2. Create a simple background
--
local back = display.newImageRect( layers.back, "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end


--
-- 3.  Create circle and move it around a path
--

local circle = display.newCircle( layers.player, cx, cy, 32 )

local path = { 
	{ cx - 200, cy - 200 },
	{ cx + 200, cy - 200 },
	{ cx + 200, cy + 200 },
	{ cx - 200, cy + 200 },
}

circle.curPos = 1

circle.x = path[circle.curPos][1]
circle.y = path[circle.curPos][2]


local function randomMover() 
	circle.curPos = circle.curPos + 1
	
	if( circle.curPos > #path ) then
		circle.curPos = 1
	end

	print(circle.curPos, path[circle.curPos][1], path[circle.curPos][2])

	transition.to( circle, { x = path[circle.curPos][1], y = path[circle.curPos][2], time = 1000, onComplete = randomMover }  )
end

randomMover()


--
-- 4.  Create a trail making mechanism
--
local minTrailDT = 130  -- in milliseconds
local lastTime = system.getTimer()

local function onEnterFrame( )
	local curTime = system.getTimer()
	local dt = curTime - lastTime

	if (dt> minTrailDT) then
		lastTime = curTime
		local trail = display.newCircle( layers.trail, circle.x, circle.y, 30 )
		trail.alpha = 0.7
		transition.to( trail, { alpha = 0, xScale = 0.01, yScale = 0.01, time = 1500, onComplete = display.remove } )
	end
end

Runtime:addEventListener( "enterFrame", onEnterFrame )



--
-- 5. Safely stop trail making and delete circle after a 10 second delay
--

timer.performWithDelay( 10000, 
	function()
		transition.cancel( circle )
		display.remove(circle)
		Runtime:removeEventListener( "enterFrame", onEnterFrame )
		circle = nil -- so circle can be garbage collected
	end )





