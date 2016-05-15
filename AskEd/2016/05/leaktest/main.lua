-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  main.lua
-- =============================================================
-- 'Empty Framework' Generated using 'EAT - Frameworks'
-- https://gumroad.com/l/EATFrameOneTime
-- =============================================================

io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

-- Load and Create Basic Meters
local meters = require "com.roaminggamer.basic_meters"
meters.create_fps()
meters.create_mem()

local maxIter = 10

if( true ) then
	-- Approximation of original code (modified to make it re-runable)

	local i
	local object = {}
	local function create()
		for i = 1, 50000 do
			object[i] = display.newRect( math.random(0,320), math.random(0,480), math.random(0,50), math.random(0,50) )
		end
	end
	
	local function destroy()
		for i = 1, 50000 do
		object[i]:removeSelf()
		object[i] = nil
		end
	end

	
	local curIter = 0
	local function doTest()	
		curIter = curIter + 1
		print(curIter)
		if( curIter > maxIter ) then return end
		create()
		timer.performWithDelay( 500, destroy)
		timer.performWithDelay( 1000, doTest)
	end
	timer.performWithDelay( 3000, doTest)
else
	-- My modified version

	local objects = {}
	local count = 50000
	local function create()
		for i = 1, count do
			local tmp = display.newRect( math.random(0,320), math.random(0,480), math.random(0,50), math.random(0,50) )
			objects[tmp] = tmp
		end
	end

	local function destroy()
		for k,v in pairs( objects ) do
			display.remove(v)		
		end
		objects = {}
	end

	
	local curIter = 0
	local function doTest()	
		curIter = curIter + 1
		print(curIter)
		if( curIter > maxIter ) then return end
		create()
		timer.performWithDelay( 500, destroy)
		timer.performWithDelay( 1000, doTest)
	end
	timer.performWithDelay( 3000, doTest)
end