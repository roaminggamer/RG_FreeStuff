local bench 		= require "simpleBench"
local math2d 		= require "math2d"
local misc 			=  require "misc"

local mRand 		= math.random
local subVec 		= math2d.subVec
local angle2Vec 	= math2d.angle2Vec
local angle2Vec2 	= math2d.angle2Vec2
local vec2Angle 	= math2d.vec2Angle
local normVec 		= math2d.normVec
local lenVec 		= math2d.lenVec
local lenVec2 		= math2d.lenVec2

math.randomseed(1) -- To get same results each time, set same seed

local drawDelay = 100
local maxTargets = 200

local points = misc.genPoints(maxTargets)

--local targets = misc.createTargets(points)
local targets = misc.createTargets2(points)


local function chooseNearest( x, y, targets )
	local nearest
	local maxDist = 1000000
	for i = 1, #targets do
		local t = targets[i]
		if( not t.ignore ) then
			local vx,vy = subVec( x, y, t.x, t.y )
			local dist  = lenVec( vx, vy )
			if( dist <= maxDist ) then
				maxDist = dist
				nearest = targets[i]
			end
		end
	end
	return nearest
end

local function chooseNearest2( x, y, targets )
	local nearest
	local maxDist = 1000000
	for k,v in pairs( targets ) do
		if( not v.ignore ) then
			local vx,vy = subVec( x, y, v.x, v.y )
			local dist  = lenVec( vx, vy )
			if( dist <= maxDist ) then
				maxDist = dist
				nearest = v
			end
		end
	end
	return nearest
end


local function randomDraw()
	for i = 1, maxTargets do
		local t = targets[i]
		timer.performWithDelay( i * drawDelay, 
			function()
				misc.drawLine2Target( 240, 160, targets[i] )
			end )
	end
end

local function randomDraw2()
	local count = 1
	for k,v in pairs( targets ) do
		timer.performWithDelay( count * drawDelay, 
			function()
				misc.drawLine2Target( 240, 160, v )
			end )
		count = count + 1
	end
end

local function nearestDraw()
	for i = 1, maxTargets do
		local t = chooseNearest2( 240, 160, targets )
		t.ignore = true
		timer.performWithDelay( i * drawDelay, 
			function()
				misc.drawLine2Target( 240, 160, t )
			end )
	end
end


--randomDraw()
--randomDraw2()
nearestDraw()



--[[
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

--]]
