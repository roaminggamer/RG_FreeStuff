-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Debug 
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

local debug

if( not _G.ssk.debug ) then
	_G.ssk.debug = {}
end

debug = _G.ssk.debug

-- ==
--    func() - what it does
-- ==
debug.dumpFonts = function()
-- Print all known (loaded and useable) font names
	local sysFonts = native.getFontNames()
	for k,v in pairs(sysFonts) do print(v) end
end

-- ==
--    func() - what it does
-- ==
debug.printLuaVersion = function ()
	print("Corona SDK is using " .. _VERSION)
end

-- ==
--    func() - what it does
-- ==
debug.monitorMem = function( maxMemLabel, textureMemLabel, maxSizeLabel, maxUnitsLabel )
    
	collectgarbage()

	local mainMem = collectgarbage("count")
	local vidMem = system.getInfo( "textureMemoryUsed" )
	local maxTextureSize = system.getInfo( "maxTextureSize" )
	local maxTextureUnits = system.getInfo( "maxTextureUnits" )

	local maxMemUsage = "Main Memory: " .. round(mainMem,2)  .. " KB"
	local textMem = "Texture Memory:   " .. round(system.getInfo( "textureMemoryUsed" ) / (1024 * 1024),4) .. " MB"

    print(maxMemUsage)
	print(textMem)
	print(maxTextureSize)
	print(maxTextureUnits)
    
    if(maxMemLabel) then maxMemLabel.text = maxMemUsage end
	if(textureMemLabel) then textureMemLabel.text = textMem end
	if(maxSizeLabel) then maxSizeLabel.text = "Max Texture Size: " .. maxTextureSize end
	if(maxUnitsLabel) then maxUnitsLabel.text = "Max Texture Units: " .. maxTextureUnits end

	return maxMemUsage, textMem, maxTextureSize, maxTextureUnits
end


-- ==
--    func() - what it does
-- ==
debug.dumpScreenMetrics = function()

	print("\n************************************************* " )
	print("\nDesign Specs")
	print("------------")
	print("       design width (w) = " .. w)
	print("      design height (h) = " .. h)
	print("x-axis center (centerX) = " .. centerX)
	print("y-axis center (centerY) = " .. centerY)
	
	print("\nDevice Specs")
	print("------------")
	print("  device width (deviceWidth) = " .. deviceWidth)
	print("device height (deviceHeight) = " .. deviceHeight)

	print("\nDesign --> Device Scaling")
	print("-------------------------")
	print("content scale X (scaleX) = " .. round(scaleX,3))
	print("content scale Y (scaleY) = " .. round(scaleY,3))

	print("\nVisible scaled screen")
	print("---------------------")
	print(" displayWidth = " .. displayWidth)
	print("displayHeight = " .. displayHeight)

	print("\nUnused scaled pixels")
	print("--------------------")
	print(" unusedWidth = " .. unusedWidth)
	print("unusedHeight = " .. unusedHeight)

	print("\nScreen Orientation")
	print("------------------")
	print(system.orientation )
	
	print("\n************************************************* \n" )

end


-- ==
--    func() - what it does
-- ==
debug.enableGlobalWatch = function()
	if(debug.globalWatchEnabled) then return end
	debug.globalWatchEnabled = true	

	local function globalWatch(g, key, value)
		print("GlobalWatch --- ", tostring(key) .. " has been added to _G\n" .. debug.traceback())
		rawset(g, key, value)
	end
	setmetatable(_G, { __index = globalWatch })
end