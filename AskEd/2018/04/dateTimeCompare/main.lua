-- =============================================================
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( {} )
-- =============================================================

local minTimeBetweenRuns = 10 -- 10 seconds

-- Standard Lua:
-- https://docs.coronalabs.com/api/library/os/time.html
local curTimeInSeconds = os.time(os.date( '*t' ))

-- SSK Extention of Lua Tables: 
-- https://roaminggamer.github.io/RGDocs/pages/SSK2/extensions/#saving-loading-tables
local lastRun = table.load( "lastRun.json" )  -- returns 'nil' if file not found


-- First Run
if( lastRun == nil ) then 
	display.newText( "First Run", centerX, centerY )

   local lastRun = {}
   lastRun.ranAt = curTimeInSeconds
   lastRun.runs = 1

   table.save( lastRun, "lastRun.json" )

-- Subsequent Run
else

	local timeSinceLastRun = curTimeInSeconds - lastRun.ranAt

	display.newText( "Ran " .. tostring( lastRun.runs ) .. " times" , centerX, centerY )

	display.newText( "Ran " .. tostring( timeSinceLastRun ) .. " seconds ago" , centerX, centerY + 50 )

	if( timeSinceLastRun < minTimeBetweenRuns ) then

		local tmp = display.newText( "Please wait " .. tostring( minTimeBetweenRuns - timeSinceLastRun ) .. " seconds" , centerX, centerY + 100 )
		tmp:setFillColor(1,0,0)
		local tmp = display.newText( "Then restart the app." , centerX, centerY + 150 )
		tmp:setFillColor(1,0,0)

	else
		local tmp = display.newText( "Welcome back!" , centerX, centerY + 100 )
		tmp:setFillColor(0,1,0)

	   lastRun.ranAt = curTimeInSeconds
	   lastRun.runs = lastRun.runs + 1
	   table.save( lastRun, "lastRun.json" )

	end

end


