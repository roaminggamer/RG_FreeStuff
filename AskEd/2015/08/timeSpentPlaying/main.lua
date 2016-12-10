-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

--[[		
--]]

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user wanted to count time spend 'playing' the game.", 
	"",
	"This example does exactly that, counting time spent running this example ONLY.", 
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--
-- Load SSK
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            debugLevel 				= 0 } )
-- Provide a place to store timer timer values
-- 
local startTime 	= system.getTimer()
local priorTime 	= 0

-- Check to see if there was a time saved already. If not, save one now.
--
if( io.exists( "timeSpentPlaying.txt" ) ) then
	-- Found an old saved time.  Load it
	priorTime = io.readFile( "timeSpentPlaying.txt" )
	priorTime = tonumber(priorTime)

else
	-- Save current time to file.
	io.writeFile( priorTime, "timeSpentPlaying.txt" )
end


-- Create a basic timer to display the 'delta time'
--
local timerLabel = display.newText( "0:00.00", display.contentCenterX, display.contentCenterY, native.systemFont, 42 )

-- User 'enterFrame' to update timer. (Costly as it executes every frame, but very accurate)
--
timerLabel.enterFrame = function( self )
	local curTime 		= system.getTimer()
	local sessionTime 	= curTime - startTime

	local currentTotalTimePlayed = sessionTime + priorTime
	io.writeFile( currentTotalTimePlayed, "timeSpentPlaying.txt" )

	local seconds = math.floor( currentTotalTimePlayed / 1000 )	

	local nHours = tonumber(string.format("%02.f", math.floor(seconds/3600)))
	local nMins = tonumber(string.format("%02.f", math.floor(seconds/60 - (nHours*60))))
	local nSecs = tonumber(string.format("%02.f", math.floor(seconds - nHours*3600 - nMins *60)))
	local nDays = 0

	while (nHours >= 24) do
		nDays = nDays + 1
		nHours = nHours - 24
	end
	timerLabel.text = string.format("%d days %d hours %2.2d minutes %2.2d seconds", nDays, nHours, nMins, nSecs )
end
Runtime:addEventListener( "enterFrame", timerLabel )


