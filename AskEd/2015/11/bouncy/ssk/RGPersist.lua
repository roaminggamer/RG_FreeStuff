-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
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
local persist = {}
if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.persist = persist

local fileCache = {}

persist.get = function( fileName, fieldName, params )
	params			= params or {}
	local record 	= fileCache[fileName] 
	if( not record ) then
		record = table.load( fileName, params.base ) or { defaults = {} }
		if( record[fieldName] == nil ) then
			record[fieldName] = record.defaults[fieldName]
		end
	end
	if( tonumber(record[fieldName]) ) then
		return tonumber(record[fieldName])
	end
	return record[fieldName] 
end

persist.set = function( fileName, fieldName, value, params )
	params		= params or {}
	local save	= (params.save == nil) and true or params.save

	local record = fileCache[fileName] 
	if( not record ) then
		record = table.load( fileName, params.base ) or { defaults = {} }
	end

	record[fieldName] = value

	if(save) then 
		table.save( record, fileName, params.base )
	end
end

persist.setDefault = function( fileName, fieldName, value, params )
	params		= params or {}
	local save	= (params.save == nil) and true or params.save

	local record = fileCache[fileName] 
	if( not record ) then
		record = table.load( fileName, params.base ) or { defaults = {} }
	end

	record.defaults[fieldName] = value

	if(save) then 
		table.save( record, fileName, params.base )
	end
end

return persist