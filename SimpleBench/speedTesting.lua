-- http://forums.coronalabs.com/topic/48914-how-to-deal-with-arrays-of-a-lot-of-spawned-objects/
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
local mSqrt = math.sqrt
local function test2()
	for i = 1, 100000 do
		mSqrt( i )
	end
end

-- Measuring attempt 1 (one iteration per test)
--
local time1,time2,delta,speedup = bench.measureABTime( test1, test2 )
print( "\nSingle run 100,000 calculations.")
print( "Test 1: " .. round(time1/1000,2) .. " seconds.")
print( "Test 2: " .. round(time2/1000,2) .. " seconds.")
print( "Test 2 is " .. speedup .. " percent faster .")
if( speedup == 0 ) then
	print( "Tests may have run too fast to measure appreciable speedup.")
end

-- Measuring attempt 2 (100 iteration per test)
--
local time1,time2,delta,speedup = bench.measureABTime( test1, test2, 100 )
print( "\n100 runs x 100,000 calculations each.")
print( "Test 1: " .. round(time1/1000,2) .. " seconds.")
print( "Test 2: " .. round(time2/1000,2) .. " seconds.")
print( "Test 2 is " .. speedup .. " percent faster .")

-- Measuring attempt 3 (200 iteration per test)
--
local time1,time2,delta,speedup = bench.measureABTime( test1, test2, 200 )
print( "\n200 runs x 100,000 calculations each.")
print( "Test 1: " .. round(time1/1000,2) .. " seconds.")
print( "Test 2: " .. round(time2/1000,2) .. " seconds.")
print( "Test 2 is " .. speedup .. " percent faster .")

-- Measuring attempt 4 (300 iteration per test)
--
local time1,time2,delta,speedup = bench.measureABTime( test1, test2, 300 )
print( "\n300 runs x 100,000 calculations each.")
print( "Test 1: " .. round(time1/1000,2) .. " seconds.")
print( "Test 2: " .. round(time2/1000,2) .. " seconds.")
print( "Test 2 is " .. speedup .. " percent faster .")


