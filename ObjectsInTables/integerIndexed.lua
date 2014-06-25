-- Example for this question: http://forums.coronalabs.com/topic/48914-how-to-deal-with-arrays-of-a-lot-of-spawned-objects/#entry253053
-- and for Bud's private question.

local bench = require "simpleBench"
local round = bench.round
local mRand = math.random

local function rcolor()
	return mRand(20,255)/255
end

-- Create a list 10,000 randomly chosen display objects
local myObjects = {}
for i = 1, 10000 do
	local x = mRand( 30, 450)
	local y = mRand( 30, 290)
	local type = mRand(1,2)
	if(type == 1) then
		tmp = display.newCircle( x, y, 20)
	else
		tmp = display.newRect( x, y, 40, 40 )
	end

	-- Store references using integer indexes
	myObjects[#myObjects+1] = tmp
end

-- Three tests that iterate over the list 'myObjects' but do no work
--
local function numericIteration_noWork()
	local tmp
	for i = 1, #myObjects do
		tmp = myObjects[i]
		-- Do some work here on 'tmp'
	end
end

local function numericIterationWithNilTest_noWork()
	local tmp
	for i = 1, #myObjects do
		tmp = myObjects[i]
		if( tmp ) then
			-- Do some work here on 'tmp'			
		else
			-- Do nothing, this entry is 'nil'			
		end
	end
end


-- Three tests that iterate over the list 'myObjects' and randomly change the color of each object
--
local function numericIteration_withWork()
	local tmp
	for i = 1, #myObjects do
		tmp = myObjects[i]
		tmp:setFillColor(rcolor(),rcolor(),rcolor())
	end
end

local function numericIterationWithNilTest_withWork()
	local tmp
	for i = 1, #myObjects do
		tmp = myObjects[i]
		if( tmp ) then
			tmp:setFillColor(rcolor(),rcolor(),rcolor())
		else
			-- Do nothing, this entry is 'nil'			
		end
	end
end

-- Run each test 10 times to get a good measurement
--
local t1 = bench.measureTime(numericIteration_noWork,10)
local t2 = bench.measureTime(numericIterationWithNilTest_noWork,10)
local t3 = bench.measureTime(numericIteration_withWork,10)
local t4 = bench.measureTime(numericIterationWithNilTest_withWork,10)


print("'#' iteration + No Work              x 10 iterations: " .. t1 .. " ms ")
print("'#' iteration + 'nil' Test + No Work x 10 iterations: " .. t2 .. " ms ")

print("'#' iteration + Work                 x 10 iterations: " .. t3 .. " ms ")
print("'#' iteration + 'nil' Test + Work    x 10 iterations: " .. t4 .. " ms ")
