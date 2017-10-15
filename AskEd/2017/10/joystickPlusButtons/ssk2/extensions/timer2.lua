-- Timer 2.0 Library for Corona SDK
-- Copyright (c) 2015 Jason Schroeder
-- http://www.jasonschroeder.com
-- http://www.twitter.com/schroederapps

----------------------------------------
-- HOW TO USE THIS LIBRARY
----------------------------------------
-- Step One: put this lua file in your project's root directory
-- Step Two: require the module in your project as such:
	-- require("timer2")

-- Taking the steps above modifies Corona's built-in timer Library as follows:
	-- timer.performWithDelay() now accepts two new optional function arguments: TAG and EXCLUDE.
		-- TAG is a string that appends a tag to the created timer that can be used to pause, resume, or cancel all timers with the same tag at once. Defaults to nil.
		-- EXCLUDE is a boolean (true/false) parameter that, when set to true, excludes the timer from being impacted by timer.pause(), timer.resume(), or timer.cancel() calls that do not specifically target it by passing the timer's handle or tag. Timers that are mission-critical and should always run should have their EXCLUDE parameter set to true. Defaults to false.
		-- These new arguments can be added in any order to the end of any existing timer.performWithDelay() call.
		-- As an example, the following code would create a timer with the tag "myTag" that is excluded from non-specific pause, resume, or cancel calls:
			-- timer.performWithDelay(1000, myFunction, 1, "myTag", true)
	-- timer.pause(), timer.resume(), and timer.cancel() still work as before, with the following new features:
		-- You can pause, resume, or cancel all active timers (unless they have their exclude parameter set to true) by calling timer.pause(), timer.resume(), or timer.cancel() with no arguments.
		-- You can pause, resume, or cancel all timers with a specific tag by passing the tag as a parameter. For example, the following code would pause all timers with the tag "myTag":
			-- timer.pause("myTag")

----------------------------------------
-- CAPTURE OLD TIMER 1.0 FUNCTIONS
----------------------------------------
timer.performWithDelay0 = timer.performWithDelay
timer.pause0 = timer.pause
timer.resume0 = timer.resume
timer.cancel0 = timer.cancel

----------------------------------------
-- CREATE TABLE TO HOLD TIMERS
----------------------------------------
timer.timer2timers = {}
local timers = timer.timer2timers

----------------------------------------
-- MODIFY TIMER.PERFORMWITHDELAY
----------------------------------------
function timer.performWithDelay(...)
	-- set up local parameters
	local args = {...}
	local delay = args[1]
	local listener = args[2]
	local iterations = 1
	local tag = nil
	local exclude = false
	for i = 3, 5 do
		local arg = args[i]
		if type(arg) == "number" then
			iterations = arg
		elseif type(arg) == "string" then
			tag = arg
		elseif type(arg) == "boolean" then
			exclude = arg
		end
	end

	-- create timer
	local newTimer = timer.performWithDelay0(delay, listener, iterations)
	newTimer.tag = tag
	newTimer.exclude = exclude
	timers[#timers+1] = newTimer

	return newTimer
end

----------------------------------------
-- MODIFY TIMER.PAUSE
----------------------------------------
function timer.pause(timerID)
	if timerID == nil then
		for i = #timers, 1, -1 do
			if not timers[i].exclude then
				local timeLeft = timer.pause0(timers[i])
				if timeLeft <=0 and (timers[i]._iterations ==  nil or timers[i]._iterations == 0) then
					timers[i] = nil
					table.remove(timers, i)
				end
			end
		end
	else
		for i = #timers, 1, -1 do
			if timerID == timers[i] or timerID == timers[i].tag then
				local timeLeft = timer.pause0(timers[i])
				if timeLeft <=0 and (timers[i]._iterations ==  nil or timers[i]._iterations == 0) then
					timers[i] = nil
					table.remove(timers, i)
				end
			end
		end
	end
end

----------------------------------------
-- MODIFY TIMER.RESUME
----------------------------------------
function timer.resume(timerID)
	if timerID == nil then
		for i = #timers, 1, -1 do
			if not timers[i].exclude then
				local timeLeft = timer.resume0(timers[i])
				if timeLeft <=0 and (timers[i]._iterations ==  nil or timers[i]._iterations == 0) then
					timers[i] = nil
					table.remove(timers, i)
				end
			end
		end
	else
		for i = #timers, 1, -1 do
			if timerID == timers[i] or timerID == timers[i].tag then
				local timeLeft = timer.resume0(timers[i])
				if timeLeft <=0 and (timers[i]._iterations ==  nil or timers[i]._iterations == 0) then
					timers[i] = nil
					table.remove(timers, i)
				end
			end
		end
	end
end

----------------------------------------
-- MODIFY TIMER.CANCEL
----------------------------------------
--function timer.cancel(...)
--	local timerID
--	if( arg ) then
--		timerID = arg[1]
--	end
	--print("CANCELLING", unpack(arg), system.getTimer() )
function timer.cancel( timerID )
	if timerID == nil then
		for i = #timers, 1, -1 do
			if not timers[i].exclude then
				timer.cancel0(timers[i])
				table.remove(timers, i)
			end
		end
	else
		for i = #timers, 1, -1 do
			if timerID == timers[i] or timerID == timers[i].tag then
				timer.cancel0(timers[i])
				timers[i] = nil
				table.remove(timers, i)
			end
		end
	end
end

return true
