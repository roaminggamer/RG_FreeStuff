-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Prototyping Objects
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

-- Create the display class if it does not yet exist
--
local displayExtended
if( not _G.ssk.display ) then
	_G.ssk.display = {}
end
displayExtended = _G.ssk.display

-- ==
--    func() - what it does
-- ==
function displayExtended.quitButton( callback, group )
	local group = group or display.currentStage
	local quitButton = ssk.buttons:new 
	{
		unselImg = imagesDir .. "homeButtonRed.png",
		selImg = imagesDir .. "homeButtonRedOver.png",
		x = w-16,
		y = 16,
		w = 32,
		h = 32,
		fontSize = 30,
		onRelease = callback,
		text = "",
		scaleFont = true,
		textOffset = {0,0},
	}
	group:insert(quitButton)

	return quitButton
end
