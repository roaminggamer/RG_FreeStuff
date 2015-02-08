-- Last Updated: 08 FEB 2015 @ 1225 PST
--
local ced = {}
ced.print = _G.print
ced.print2 = _G.print
ced.promoteToError = function()
  ced.print = _G.error
end
if( system.getInfo( "environment" ) ~= "simulator" ) then 
	return ced
end
local lfs = require "lfs"
local function isDirectory( path )
	path = system.pathForFile( path, system.ResourceDirectory )
	if not path then
		return false
	end
	return lfs.attributes( path, "mode" ) == "directory"
end
local function getFilesInDirectory( path )
	path = system.pathForFile( path, system.ResourceDirectory )
	if path then		
		local files = {}		
		for file in lfs.dir( path ) do		
			if file ~= "." and file ~= ".." and file ~= ".DS_Store" then
				files[ #files + 1 ] = file
			end			
		end
		return files		
	end	
end

local function findAllFiles( path )
	local tmp = getFilesInDirectory( path )
	local files = {}
	for k,v in pairs( tmp ) do
		files[v] = v
	end

	for k,v in pairs( files ) do
		local newPath =  path and (path .. "/" .. v) or v
		local isDir = isDirectory( newPath )
		if( isDir ) then
			files[v] = findAllFiles( newPath )
		else
		end
	end
	return files
end


local flattenNames = function ( t, sep ) 
	local flatNames = {}
	local function flatten(t,indent,prefix)
		local path 
		if (type(t)=="table") then
			for k,v in pairs(t) do
				if (type(v)=="table") then
					path = (prefix) and (prefix .. indent .. tostring(k)) or tostring(k)
					path = flatten(v,indent,path)					
				else
					path = (prefix) and (prefix .. indent .. tostring(k)) or tostring(k)
					flatNames[path] = path
				end
			end
		else
			path = (prefix) and (prefix .. indent .. tostring(t)) or tostring(t)
			flatNames[path] = path
		end
		return prefix or ""
	end
	if (type(t)=="table") then
		flatten(t,sep)
	else
		flatten(t,sep)
	end
	return flatNames
end

local function getLuaFiles( files )
	local luaFiles = flattenNames( files, "." )
	for k,v in pairs(luaFiles) do
		if( string.match( k, "%.lua" ) ) then
			luaFiles[k] = v:gsub( "%.lua", "" )
		else
			luaFiles[k] = nil
		end
	end
	local tmp = luaFiles
	luaFiles = {}
	for k,v in pairs(tmp) do
		luaFiles[v] = v
	end
	return luaFiles
end

local function getResourceFiles( files )
	local resourceFiles = flattenNames( files, "/" )
	for k,v in pairs(resourceFiles) do
		if( string.match( k, "%.lua" ) ) then			
			resourceFiles[k] = nil
		end
	end
	local tmp = resourceFiles
	resourceFiles = {}
	for k,v in pairs(tmp) do
		resourceFiles[v] = v
	end
	return resourceFiles
end

local files = findAllFiles()
local luaFiles = getLuaFiles( files  )
local resourceFiles = getResourceFiles( files  )

--table.dump( luaFiles )
--table.dump( resourceFiles )

-- ********************************************************************************
--
--  IGNORE ABOVE THIS LINE - Make Additions and Changes Below
--
-- ********************************************************************************

-- ************************
-- ************************ require()
-- ************************
local _G_require 			= _G.require
local requireIgnoreList = {
	"ads", "analytics", "gameNetwork", "facebook", 
	
	"composer", "crypto", "json", "lfs", "licensing",
	"media", "physics", "socket", "sprite", "sqlite3",
	"store", "storyboard",  "system", "widget",
	
	"plugin", "CoronaProvider",
}
_G.require = function( path )
	local ignore = false
	for i = 1, #requireIgnoreList do
		ignore = ignore or (path:match( requireIgnoreList[i]) ~= nil)
	end

	if( not ignore and not luaFiles[path] ) then 
		ced.print2("***** WARNING! require( '" .. tostring(path) .. "' ) - does not exit.  Check case of file.")
	end
	return _G_require( path )
end

-- ************************
-- ************************ display.*
-- ************************
local display_newImage 		= _G.display.newImage
local display_newImageRect 	= _G.display.newImageRect


_G.display.newImage = function( ... )
	if( type(arg[1]) == "string" and not resourceFiles[arg[1]] ) then 
		ced.print("***** WARNING! display.newImage() Image file: '" .. tostring(arg[1]) .. "' - does not exit.  Check case of file.")
		return nil
	elseif( type(arg[2]) == "string" and not resourceFiles[arg[2]] ) then 
		ced.print("***** WARNING! display.newImage() Image file: '" .. tostring(arg[2]) .. "' - does not exit.  Check case of file.")
		return nil
	end
	return display_newImage( unpack(arg) )
end

_G.display.newImageRect = function( ... )
	if( type(arg[1]) == "string" and not resourceFiles[arg[1]] ) then 
		ced.print("***** WARNING! display.newImageRect() Image file: '" .. tostring(arg[1]) .. "' - does not exit.  Check case of file.")
		return nil
	elseif( type(arg[2]) == "string" and not resourceFiles[arg[2]] ) then 
		ced.print("***** WARNING! display.newImageRect() Image file: '" .. tostring(arg[2]) .. "' - does not exit.  Check case of file.")
		return nil
	end
	return display_newImageRect( unpack(arg) )
end


-- ************************
-- ************************ graphics.*
-- ************************
local graphics_newImageSheet 	= _G.graphics.newImageSheet
local graphics_newMask 			= _G.graphics.newMask
local graphics_newOutline 		= _G.graphics.newOutline

_G.graphics.newImageSheet = function( ... )
	if( type(arg[1]) == "string" and not resourceFiles[arg[1]] ) then 
		ced.print("***** WARNING! graphics.newImageSheet() Image file: '" .. tostring(arg[1]) .. "' - does not exit.  Check case of file.")
		return nil
	end
	return graphics_newImageSheet( unpack(arg) )
end

_G.graphics.newMask = function( ... )
	if( type(arg[1]) == "string" and not resourceFiles[arg[1]] ) then 
		ced.print("***** WARNING! graphics.newMask() Image file: '" .. tostring(arg[1]) .. "' - does not exit.  Check case of file.")
		return nil
	end
	return graphics_newMask( unpack(arg) )
end

_G.graphics.newOutline = function( ... )
	if( type(arg[2]) == "string" and not resourceFiles[arg[2]] ) then 
		ced.print("***** WARNING! graphics.newOutline() Image file: '" .. tostring(arg[2]) .. "' - does not exit.  Check case of file.")
		return nil
	end
	return graphics_newOutline( unpack(arg) )
end

-- ************************
-- ************************ widget.*
-- ************************
local widget = require( "widget" )
local widget_setTheme 		= widget.setTheme
widget.setTheme = function( themeFile )
	if( type(arg[1]) == "string" and not luaFiles[themeFile] ) then 
		ced.print("***** WARNING! widget.setTheme() Theme file: '" .. tostring(themeFile) .. "' - does not exit.  Check case of file.")
		return nil
	end
	return widget_setTheme( themeFile )
end




return ced