-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua (comments/code)
-- =============================================================
-- Toy: State Calculator (Guess from GPS position)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            gameFont 				= "Prime.ttf",
	            debugLevel 				= 0 } )
-- =============================================================
-- TOY CODE BEGINS BELOW
-- =============================================================


local RGStateCalc 	= require "scripts.RGStateCalc"

local maxTries = 10
local tries = 0
local function printWhenReady()

	-- Increment tries counter
	--
	tries = tries + 1

	-- Did the utility guess a state?
	--
	if( RGStateCalc.isReady() ) then

		-- Get list of guesses.
		--
		local myState = RGStateCalc.getMyState()

		-- Biuld a message and show it.
		--
		local tmp
		if( #myState == 0 ) then
			tmp = "Couldn't find state you are in...darn!"
		elseif( #myState == 1 ) then
			tmp = "Are you in " .. myState[1] .. "?"
		else
			tmp = "Are you in one of these states? ==> "
			for i = 1, #myState do
				if( i == #myState ) then
					tmp = tmp .. myState[i] .. "."
				else
					tmp = tmp .. myState[i] .. ", "
				end
			end
		end
		local msg = display.newText( tmp, display.contentCenterX, display.contentCenterY, "Prime.ttf", 32 )
		
		-- Print extra notes if on simulator
		--
		if( ssk.system.onSimulator ) then
			msg.y = msg.y - 50
			local tmp = "Warning: Guess may be wrong if run in simulator."
			local msg = display.newText( tmp, display.contentCenterX, msg.y + 80, "Prime.ttf", 32 )
			local tmp = "Test on device instead."
			local msg = display.newText( tmp, display.contentCenterX, msg.y + 40, "Prime.ttf", 32 )
		end

		return

	-- Are we out of retries?
	--
	elseif( tries > maxTries ) then
		local tmp = "Could not guess after " .. maxTries .. " attempts.  Is GPS on?"
		display.newText( tmp, display.contentCenterX, display.contentCenterY, "Prime.ttf", 32 )
		return
	end

	-- Try again in 30 ms

	timer.performWithDelay( 30, printWhenReady )
end
timer.performWithDelay( 30, printWhenReady )


