-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--   Last Updated: 29 NOV 2016
-- Last Validated: 29 NOV 2016
-- =============================================================
-- Development Notes:
-- 1. Consider adding delay to save to make this more battery efficient and less likely to 
--    block under heavy usage.
-- =============================================================

local persist = {}
if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.persist = persist

local fileCache = {}

local tableLoad = table.load
local tableSave = table.save

persist.setSecure = function( )
	tableLoad = table.secure_load
	tableSave = table.secure_save
end

persist.get = function( fileName, fieldName, params )
	params			= params or {}
	local record 	= fileCache[fileName] 
	if( record == nil ) then		
		record = tableLoad( fileName, params.base ) or { defaults = {} }
	end
	if( record[fieldName] == nil ) then
		record[fieldName] = record.defaults[fieldName]
	end
	if( tonumber(record[fieldName]) ) then
		return tonumber(record[fieldName])
	end
	return record[fieldName] 
end

persist.set = function( fileName, fieldName, value, params )
	params		= params or {}

	local record = fileCache[fileName] 
	if( not record ) then
		record = tableLoad( fileName, params.base ) or { defaults = {} }
	end

	record[fieldName] = value

	if(params.save ~= false ) then 
		--print("save", record, fileName, fieldName, value, system.getTimer())
		tableSave( record, fileName, params.base )
	end
end

persist.setDefault = function( fileName, fieldName, value, params )
	params		= params or {}

	local record = fileCache[fileName] 
	if( not record ) then
		record = tableLoad( fileName, params.base ) or { defaults = {} }
	end

	fileCache[fileName] = record

	record.defaults[fieldName] = value

	if(params.save ~= false ) then 
		tableSave( record, fileName, params.base )
	end
end

return persist