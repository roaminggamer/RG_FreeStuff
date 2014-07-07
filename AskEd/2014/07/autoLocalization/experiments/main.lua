local min,max,sqrt,random; require("autolocalize").go("math")
local getTimer,getInfo; require("autolocalize").go("system")

local mMin,mMax,mSqrt;require("autolocalize2").go()

local bench = require "simpleBench"
local round = bench.round

local mMath = {}

for k, v in pairs( math ) do
    if type( v ) == "function" then
        mMath[k] = v
    end
end



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

-- Measuring attempt 1 (one iteration per test)
--
local time1,time2,delta,speedup = bench.measureABTime( test1, test2, 100 )
print( "\nSingle run 100,000 calculations.")
print( "Test 1: " .. round(time1/1000,2) .. " seconds.")
print( "Test 2: " .. round(time2/1000,2) .. " seconds.")
print( "Test 2 is " .. speedup .. " percent faster .")
if( speedup == 0 ) then
	print( "Tests may have run too fast to measure appreciable speedup.")
end
--]]