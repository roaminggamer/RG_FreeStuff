-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------

local settings 			= require "scripts.settings"

local RGFiles 		= ssk.files

--local EATFolder = RGFiles.desktop.getMyDocumentsPath("EATStorage")
local EATStorage = settings.EATStorage
print(EATStorage)
if( not RGFiles.util.isFolder( EATStorage ) ) then
	RGFiles.util.mkFolder( EATStorage )
end

local EATSettingsFile = RGFiles.util.repairPath( EATStorage .. "/" .. "settings.json" )


local table_save = RGFiles.util.saveTable
local table_load = RGFiles.util.loadTable

local secure = (not onSimulator)
secure = false

local theSettings = table_load( EATSettingsFile, secure ) or {}

local toolSettings = {}
-- =============================================================
-- Set
-- =============================================================
function toolSettings.set( key, value, skipAutoSave )
	theSettings[key] = value
	if( not skipAutoSave ) then
		table_save( theSettings, EATSettingsFile, secure )
	end
end

-- =============================================================
-- Set
-- =============================================================
function toolSettings.setDefault( key, value, skipAutoSave )
	if( theSettings[key] == nil ) then
		theSettings[key] = value
		if( not skipAutoSave ) then
			table_save( theSettings, EATSettingsFile, secure )
		end
	end
end


-- =============================================================
-- Get
-- =============================================================
function toolSettings.get( key )
	-- Ensure numbers always come back as numbers, because
	-- json save/load can sometimes coerce numbers into strings.
	return tonumber(theSettings[key]) or theSettings[key]
end

return toolSettings
