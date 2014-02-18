-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Debug Printer
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
--[[
To use a debug printer in your own code do the following:
 
At the top of your code/file, add these lines:

--local debugLevel = 1 -- Comment out to get global debugLevel from main.lua
local debugPrinter = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = debugPrinter.print

Later to call the debug printer in this file use code like this:

dprint( 2, "Some message", "that should", "only print at level 2 or higher")

--]]

local debugPrinter = {}

local debugPrinter

if( not _G.ssk.debugPrinter ) then
	_G.ssk.debugPrinter = {}
end

debugPrinter = _G.ssk.debugPrinter

-- ==
--    debugPrinter.newPrinter( debugLevel ) - Creates a new debug printer that only prints messages at the specified debugLevel or higher.
-- ==
function debugPrinter.newPrinter( debugLevel )

	if(debugLevel == nil) then
		print("Warning: Passed nil when initializing debugLevel in debugPrinter.newPrinter()")
	end

	local printerInstance = {}

	-- Debug messaging level: 
	-- 0  - None
	-- 1  - Basic messages
	-- 2  - Intermediate debug output
	-- 3+ - Full debug output (may be very noisy)
	printerInstance.debugLevel = debugLevel or 0

	-- ==
	--    printerInstance:setLevel( debugLevel ) - Changes the debug level for this debug printer instance.
	-- ==
	function printerInstance:setLevel( level )
		self.debugLevel = level			
	end

	-- ==
	--    printerInstance:print( level, ... ) - Changes the debug level for this debug printer instance.
	-- ==
	function printerInstance.print( level, ... )
		if(printerInstance.debugLevel >= level ) then
			print( unpack(arg) )
		end
	end

	return printerInstance
end
