io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
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
-- START
-- =====================================================
local function doWork( n )
	for i = 1, n do
		local varName = "test" .. tostring(math.random(1,1e6))
		_G[varName] = display.newImageRect( "protoBackX.png", 720, 1386 )
      display.remove(_G[varName])
      --_G[varName] = nil -- PREVENT LEAK
   end
	collectgarbage("collect") -- Collect garbage every frame to get 'true' current memory usage
end

local function baseline()
	local meters = require "meters"
	meters.create_fps(true)
	meters.create_mem(true)
end

local function verifyLeakNoLeak()

	doWork(3e4)

	local meters = require "meters"
	meters.create_fps(true)
	meters.create_mem(true)
end

local function profileIt()
	ProFi = require 'ProFi'
	ProFi:start()

	doWork(3e4)


	ProFi:stop()
	ProFi:checkMemory( )
	local filename = system.pathForFile( 'profilerReport.txt', system.DocumentsDirectory ) -- EFM
	ProFi:writeReport( filename )
end

-- Run only one of these per restart

--baseline()
--verifyLeakNoLeak()
profileIt()

-- =====================================================
-- END
-- =====================================================


