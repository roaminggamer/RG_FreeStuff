-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Changes:
-- 18 AUG 2017 - Saves are now defered 15 ms.  This allows multipe-sets
--               in the same window to coallesce into a single save.
-- =============================================================
local saveDelay = 15

local persist = {}
if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.persist = persist

local fileCache = {}

local tableLoad = table.load
local tableSave = table.save

local deferedSaves = {}
local function scheduleSave( record, fileName, base  )
	local baseName 
	if( base == nil or base == system.DocumentsDirectory ) then
		baseName = "documents"
	elseif( base == system.TemporaryDirectory ) then
		baseName = "documents"
	else -- RG: not perfect, but shoul rarely be hit.
		baseName = "other"
	end
	--
	local saveName = fileName .. '_' .. baseName
	--
	if( deferedSaves[saveName] ) then return end
	--
	deferedSaves[saveName] = {
		id = -1,
		func = 
		function()
			deferedSaves[saveName] = nil
			tableSave( record, fileName, base ) 
		end
	}
	--
	deferedSaves[saveName].id = timer.performWithDelay( saveDelay, deferedSaves[saveName].func )	
end
-- Force run oustanding saves if suspend or exit occurs
local function onSystemEvent( event )
	if( event.type == 'applicationSuspend' or 
		 event.type == 'applicationExit') then
		for k,v in pairs( deferedSaves ) do
			timer.cancel(v.id)
			v.func()
			deferedSaves[k] = nil
		end
	end
end  
Runtime:addEventListener( "system", onSystemEvent )

persist.setSaveDelay = function( delay )
	delay = tonumber(delay) or 15
	saveDelay = (delay <= 0 ) and 15 or delay
end

persist.setSecure = function( )
	tableLoad = table.secure_load
	tableSave = table.secure_save
end

-- DANGER: DESTROYS ENTIRE FILE CONTENTS!
persist.reset = function( fileName, params )
	params = params or {}
	local record = { defaults = {} }
	fileCache[fileName] = record
	scheduleSave( record, fileName, params.base  )	
	return record
end


-- DEBUG FEATURE TO GET ENTIRE RECORD
persist.getRaw = function( fileName, params  )
	params = params or {}
	local record 	= fileCache[fileName] 
	if( record == nil ) then		
		record = tableLoad( fileName, params.base ) or { defaults = {} }
	end
	fileCache[fileName] = record
	return record
end

persist.get = function( fileName, fieldName, params )
	params			= params or {}
	local record 	= fileCache[fileName] 
	if( record == nil ) then		
		record = tableLoad( fileName, params.base ) or { defaults = {} }
	end

	fileCache[fileName] = record
	
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

	fileCache[fileName] = record

	record[fieldName] = value

	scheduleSave( record, fileName, params.base  )
end

persist.setDefault = function( fileName, fieldName, value, params )
	params		= params or {}

	local record = fileCache[fileName] 
	if( not record ) then
		record = tableLoad( fileName, params.base ) or { defaults = {} }
	end

	fileCache[fileName] = record

	record.defaults[fieldName] = value

	scheduleSave( record, fileName, params.base   )
end

return persist