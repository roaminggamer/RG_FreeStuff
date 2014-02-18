-- =============================================================
-- main.lua
-- =============================================================
-- Empty Project Using SSKCorona Library
-- =============================================================
--
-- Register a dummy handler 'FIRST' if we are using the simulator
--
-- Tip: If you don't do this early, you'll get pop-ups in the simulator (and on devices)
--      This is great for device debugging, but I personally prefer the console output
--      when using the console
--
if( system.getInfo( "environment" ) == "simulator" ) then
	local function myUnhandledErrorListener( event )
		return true
	end
	Runtime:addEventListener("unhandledError", myUnhandledErrorListener)
end

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
-- Load SSK Globals & Libraries
--
require "ssk.globals"
require "ssk.loadSSK"


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar



----------------------------------------------------------------------
-- 3. Declarations
----------------------------------------------------------------------
-- Additional Globls, Locals, and Function Forward Declartions


----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------
-- Local and Global Function Implementations


----------------------------------------------------------------------
-- 5. Execution
----------------------------------------------------------------------
local samples = {}
for i = 1, 7 do
	samples[i] = "samples." .. string.format("%3.3d", i )
end

local function showSamples( num )

	if(num <= #samples) then
		local theSample = require( samples[num] )
		display.newText( "#" .. num .. " - " .. theSample.title, 245, 12, native.systemFont, 14 )
	end 
end

showSamples( 7 )
--showSamples( math.random(1,7) )



