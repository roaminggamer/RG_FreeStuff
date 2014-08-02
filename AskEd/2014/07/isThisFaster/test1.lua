local bench = require "simpleBench"
local round = bench.round
local mAbs  = math.abs

-- Is This Faster #1
--[[
	Is this:

	for _,v in pairs( tbl ) do -- Uses '_' to say, don't store value
	end

	faster/slower than this:

	for k,v in pairs( tbl ) do
	end
--]]

local runs = 100
local iterations = 1000000
local testArray = {}
for i = 1, iterations do
	testArray[i] = i		
end

-- Version 1
local function test1( iter)
	for _,v in pairs( testArray) do
		-- No work
	end
end

-- Version 2
local function test2()
	for k,v in pairs( testArray) do
		-- No work
	end
end

-- Measuring attempt 1 (one iteration per test)
--
print("\n\n--------------------------")
print("Question #1")
print("--------------------------")
print( "\n" .. runs .. " runs x " .. iterations .. " iterations.")
local time1,time2,delta,speedup = bench.measureABTime( test1, test2, runs )
print( "Test 1: " .. round(time1/1000,2) .. " seconds.")
print( "Test 2: " .. round(time2/1000,2) .. " seconds.")
print( "Test 2 is " .. speedup .. " percent faster/slower .")
if( mAbs(speedup) < 1 ) then
	print( "No appreciable difference.")
end

