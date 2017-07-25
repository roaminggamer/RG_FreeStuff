-- =============================================================
-- Wait Module - Credit: Starcrunch of 'Xibalba Studios'
-- =============================================================
--
-- Check out more stuff by 'Starcrunch': 
-- https://www.xibalbastudios.com/
-- https://github.com/ggcrunchy
--
-- =============================================================
--   Last Updated: 23 NOV 2016
-- Last Validated: 
-- =============================================================


--- Coroutine wait utilities.

--
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- [ MIT license: http://www.opensource.org/licenses/mit-license.php ]
--

local getTimer = system.getTimer
local yield = coroutine.yield

-- Exports --
local wait = {}
if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.wait = wait


-- All of these have optional updates.

-- Wait some number of milliseconds.
wait.ms = function( time, update )
	local now = getTimer()
	local ends_at = now + time
	while now < ends_at do
		if update then
			update()
		end
		yield()		
		now = getTimer()
	end
end

-- Wait for some property to be true.
wait.untilPropertyTrue = function( object, name, update )
	while not object[name] do
		if update then
			update()
		end
		yield()
	end
end

-- Wait for some predicate to be true.
wait.untilTrue = function( func , update )
	while not func() do
		if update then
			update()
		end
		yield()
	end
end

wait.run = function( func )
	local timerID
	local wrapped = coroutine.wrap( 
		function( event ) 
			timerID = event.source
			func()
			timer.cancel(timerID)
		end )
	timer.performWithDelay( 1, wrapped, 0 )
end

-- Export the module.
return wait




--[[
-- Wait in a timer:
timer.performWithDelay(20, 
	coroutine.wrap(
		function(event)
		local source = event.source -- GOTCHA: save this now!

		ssk.wait.ms( 500 )
		print("1")
		ssk.wait.ms( 500 )

		print("2")

		ssk.wait.ms( 500 )
		print("3")

		timer.cancel(source)
	end), 0)
--]]

--[[
local function testSeq()
	local start = system.getTimer()
	print("YO " .. tostring(start) )
	ssk.wait.ms( 500 )
	print("1 " .. tostring(system.getTimer() - start) )
	
	ssk.wait.ms( 500 )
	print("2 " .. tostring(system.getTimer() - start) )

	ssk.wait.ms( 500 )
	print("3 " .. tostring(system.getTimer() - start) )
end

ssk.wait.run( testSeq )
--]]
