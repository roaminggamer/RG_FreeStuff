-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { useExternal = true } )
-- =============================================================

local group
local objs
local size = math.floor(fullh/60)
local cols = 50
local rows = 50

local startX 	= left + size/2
local startY 	= top + size/2
local curX 		= startX
local curY 		= startY


local function createGrid()
	local objs = {}	
	group = display.newGroup()
	for i = 1, cols do
		for j = 1, rows do
			objs[#objs+1] = display.newRect( group, curX, curY, size, size )
			curX = curX + size
		end
		curX = startX
		curY = curY + size
	end
	return objs
end

local function scalingTest( numRuns )	
	local scales = { 1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1  } 
	numRuns = numRuns or 1
	local scale 

	local startTime = system.getTimer()
	for iter = 1, numRuns do
		for i = #scales, 1, -1 do
			local scale = scales[i]
			for j = 1,  #objs do
				objs[j].xScale = scale
				objs[j].yScale = scale
			end
		end
	end
	local endTime = system.getTimer()

	local duration = endTime - startTime

	print("Scaling test ran ", numRuns, " times in ", endTime - startTime, " ms.")	

	return duration
end

local function sizingTest( numRuns )	
	local scales = { 1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1  } 
	for i = 1, #scales do
		scales[i] = scales[i] * size
	end	
	numRuns = numRuns or 1
	local scale 

	local startTime = system.getTimer()
	for iter = 1, numRuns do
		for i = #scales, 1, -1 do
			local scale = scales[i]
			for j = 1,  #objs do
				objs[j].width = scale
				objs[j].height = scale
			end
		end
	end
	local endTime = system.getTimer()

	local duration = endTime - startTime

	print("Sizing test ran ", numRuns, " times in ", endTime - startTime, " ms.")	

	return duration
end



print ("---------------------------")
objs = createGrid()
scalingTest(10)
scalingTest(10)
scalingTest(10)
scalingTest(10)
scalingTest(10)
display.remove(group)
print ("---------------------------")
objs = createGrid()
sizingTest(10)
sizingTest(10)
sizingTest(10)
sizingTest(10)
sizingTest(10)
display.remove(group)
print ("---------------------------")

--]]
