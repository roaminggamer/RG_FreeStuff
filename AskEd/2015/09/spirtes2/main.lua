-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- SSK Sampler
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages
-- =============================================================

-- =============================================================
-- Step 1. - Load SSK (optionally select default font)
-- =============================================================
--_G.gameFont = native.systemFont  -- optional
require "ssk.loadSSK"


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
