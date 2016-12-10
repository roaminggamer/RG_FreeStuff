-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages
-- =============================================================

-- WARNING: As of 09 DEC 2016 These features are not official.
-- I am including them in SSK2 for legacy purposes and they may become 
-- official later.  But for now I am not supporting them.

-- =============================================================
-- Step 1. - Load SSK (optionally select default font)
-- =============================================================
--_G.gameFont = native.systemFont  -- optional

require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs           = ..., 
               enableAutoListeners  = true,
               exportCore           = true,
               exportColors         = true,
               exportSystem         = true,
               exportSystem         = true,
               debugLevel           = 0 } )


-- =============================================================
-- Step 2. - Example
-- =============================================================

local group = display.newGroup()


-- Localizations
local newSprite = ssk.display.newSprite
local easyIFC   = ssk.easyIFC

easyIFC:quickLabel( group, "Sonic Sprite", centerX, centerY - 140, gameFont, 14 )

local tmp = newSprite( group, centerX, centerY - 110, "sonic.png", 
	                   {  frames = { 1,2,3,4,5 }, time = 5 * 150, loopCount = 0 }, { autoPlay = true, scale = 2 } )


easyIFC:quickLabel( group, "Animated Sprite In One Line Using SSK", centerX, centerY - 50, gameFont, 14 )

local tmp = newSprite( group, centerX, centerY - 10, "kenney_numbers.png", 
	                   {  frames = { 1,2,3,4,5,6,7,8,9,10 }, time = 1000, loopCount = 0 }, { autoPlay = true, scale = 2 } )


easyIFC:quickLabel( group, "More Complex Sequence Data, Same Simple SSK", centerX, centerY + 60, gameFont, 14 )

local sequenceData = 
{
	{
	    name = 1, time = 500, loopCount = 2,
	    frames = { 1,2,3,4,5,6,7,8,9,9 },
	},
	{
	    name = 2, time = 500, loopCount = 3,
	    frames = { 1,2,3,4,5,6,7,8,9,7 },
	},
	{
	    name = 3, time = 500, loopCount = 4,
	    frames = { 1,2,3,4,5,6,7,8,9,8 },
	},
	{
	    name = 4, time = 500, loopCount = 5,
	    frames = { 1,2,3,4,5,6,7,8,9,6 },
	},
	{
	    name = 5, time = 500, loopCount = 6,
	    frames = { 1,2,3,4,5,6,7,8,9,4 },
	},
	{
	    name = 6, time = 500, loopCount = 7,
	    frames = { 1,2,3,4,5,6,7,8,9,1 },
	},
	{
	    name = 7, time = 500, loopCount = 8,
	    frames = { 1,2,3,4,5,6,7,8,9,10 },
	},
}

for i = 1, #sequenceData do
	local tmp = newSprite( group, centerX - 90 + (i-1) * 30, centerY + 100, 
		                   "kenney_numbers.png", sequenceData,
	                       { autoPlay = true, sequence = i, scale = 1.5 } )
end
