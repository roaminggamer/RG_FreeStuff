local mMin,mMax,mSqrt;require("autoLoc").run()

local bench = require "simpleBench"
local round = bench.round


--
-- Test math.sqrt vs localized function.
-- 
-- Slow version
local function test1( iter)
	for i = 1, 100000 do
		math.sqrt( i )
		
	end
end

-- Faster Version
local name = "random"
local function test2()
	for i = 1, 100000 do
		mSqrt( i )		
	end
end

-- Measuring Speedup/Difference 
--
print("\n\n\nMeasuring Speedup/Difference \n\n\n")
local time1,time2,delta,speedup = bench.measureABTime( test1, test2, 100 )
print( "\nOne hundred runs x 100,000 calculations.")
print( "Test 1: " .. round(time1/1000,4) .. " seconds.")
print( "Test 2: " .. round(time2/1000,4) .. " seconds.")
print( "Test 2 is " .. speedup .. " percent faster .")
if( speedup == 0 ) then
	print( "Nominal difference.")
end
