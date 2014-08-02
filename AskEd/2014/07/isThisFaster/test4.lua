local bench = require "simpleBench"
local round = bench.round
local mAbs  = math.abs

-- Is This Faster #3
--[[
	Is this:

	local index = "fieldName"
	for i = 1, iterations do
		if(obj[index]) then
			-- No work
		end
	end

	faster/slower than this:

	local index = "fieldName"
	function()
		for i = 1, iterations do
			if(obj[index]) then
				-- No work
			end
		end
	end
--]]

local runs = 100
local iterations = 1000000

local testObj = {}

-- Version 1
local function test1( iter)
	local index = "fieldName"
	for i = 1, iterations do
		if(testObj[index]) then
			-- No work
		end
	end
end

-- Version 2
local index = "fieldName"
local function test2()	
	for i = 1, iterations do
		if(testObj[index]) then
			-- No work
		end
	end
end

-- Measuring attempt 1 (one iteration per test)
--
print("\n\n--------------------------")
print("Question #4")
print("--------------------------")
print( "\n" .. runs .. " runs x " .. iterations .. " iterations.")
local time1,time2,delta,speedup = bench.measureABTime( test1, test2, runs )
print( "Test 1: " .. round(time1/1000,2) .. " seconds.")
print( "Test 2: " .. round(time2/1000,2) .. " seconds.")
print( "Test 2 is " .. speedup .. " percent faster/slower .")
if( mAbs(speedup) < 1 ) then
	print( "No appreciable difference.")
end
