-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Script patcher - Allows user to replace locally bundled scripts with  downloaded patches.
-- =============================================================
--   Last Updated: 13 OCT 2017
-- =============================================================
local lib = {}

local loadedModules 	= {}
local verbose 			= false
local caching 			= true
local enabled 			= true
local orig_require 	= _G.require
local strGSub 			= string.gsub
local lfs 				= orig_require "lfs"
local io 				= orig_require "io"

--
-- First Not Nil helper.
--
local function fnn( ... ) 
	for i = 1, #arg do
		local theArg = arg[i]
		if(theArg ~= nil) then return theArg end
	end
	return nil
end

--
-- Local file helper - Returns 'true' if file exists at path
--
local function exists( fileName, base )
   local base = base or system.DocumentsDirectory	
   if( base ) then
      fileName = system.pathForFile( fileName, base )
   end   
   if not fileName then return false end
   local attr = lfs.attributes( fileName )
   return (attr and (attr.mode == "file" or attr.mode == "directory") )
end

--
-- Local file helper - Reads and returns contents of file.
--
function readFile( fileName, base )
   local base = base or system.DocumentsDirectory
   local fileContents
   if( exists( fileName, base ) == false ) then
      return nil
   end
   local fileName = fileName
   if( base ) then
      fileName = system.pathForFile( fileName, base )
   end
   local f=io.open(fileName,"r")
   if (f == nil) then 
      return nil
   end
   fileContents = f:read( "*a" )
   io.close(f)
   return fileContents
end

--
-- Local file helper - Writes data to file
--
local function writeFile( dataToWrite, fileName, base )
   base = base or system.DocumentsDirectory
   local fileName = fileName
   if( base ) then
      fileName = system.pathForFile( fileName, base )
   end
   local f=io.open(fileName,"w")
   if (f == nil) then 
      return nil
   end
   f:write( dataToWrite )
   io.close(f)
end


--
-- Local string helper - Pads string for 'nice' printing
--
function rpad( theStr, len )
	return theStr .. string.rep(' ', len - #theStr)
end

--
-- Local debug helper - Prints table to console.
--
function table_dump(theTable, marker )
   theTable = theTable or  {}
   local function compare(a,b)
      return tostring(a) < tostring(b)
   end
   local tmp = {}
   for n in pairs(theTable) do table.insert(tmp, n) end
   table.sort(tmp,compare)
   print("\n-------------\nCached Patches:")
   print("-------------")
   if(#tmp > 0) then
      for i,n in ipairs(tmp) do 		

         local key = tmp[i]
         local value = theTable[key]
         local keyType = type(key)
         local valueType = type(value)
         value = tostring(value)
         local keyString = tostring(key) .. " (" .. keyType .. ")"
         local valueString = tostring(value) .. " (" .. valueType .. ")" 
         keyString = rpad(keyString,30)
         valueString = rpad(valueString,30)
         print( keyString .. " == " .. valueString ) 
      end
   else
      print("empty")
   end
   print( marker and ( "-------------\n" ..marker .. "\n-------------" ) or "-------------" )
end

-- ============================================================================
-- PLUGIN CORE IMPLEMENTATION BEGINS
-- ============================================================================

-- ============================================================================
-- debug() - Enable debug messages.
-- ============================================================================
function lib.debug( en )
	if( en == nil ) then return verbose end
	verbose = en
	return verbose
end

-- ============================================================================
-- enableCaching() - Enable patcher caching
-- ============================================================================
function lib.caching( en )
	if( en == nil ) then return caching end
	caching = en
	return caching
end

-- ============================================================================
-- enable() - Enable patcher
-- ============================================================================
function lib.enabled( en )
	if( en == nil ) then return en end
	enabled = en
	return enabled
end

-- ============================================================================
-- getSettings() - Return table with current patcher options as fields.
-- ============================================================================
function lib.getSettings( )
	local params = {}
	params.verbose 	= verbose
	params.caching 	= caching
	params.enabled 	= enabled
	return params
end

-- ============================================================================
-- purge() - Purge a single 'name' patch or all patches if no name is supplied.
-- ============================================================================
function lib.purge( name )
	if( name ) then
		if( verbose ) then
			print("patcher: purging cached patch " .. tostring(name) )
		end
		loadedModules[name] = nil
	else		
		if( verbose ) then
			print("patcher: purging all cached patches." )
		end
		loadedModules = {}
	end
end

-- ============================================================================
-- patched( name ) - Returns 'true' if 'name' script is patched.
-- ============================================================================
function lib.patched( name )
	return (loadedModules[name])
end
-- ============================================================================
-- dump() - Dump list of currently loaded patches to console and returns table.
-- If 'verbose' is set to 'true' do not print list to console
-- ============================================================================
function lib.dump( )
	if( verbose ) then
		print("patcher: Dumping" )
	end

	local tmp = {}
	for k,v in pairs( loadedModules ) do
		tmp[#tmp+1] = k
	end
	table.sort(tmp)

	if( verbose ) then table_dump( tmp ) end
	return tmp
end

-- ============================================================================
-- export() - Replace 'global' require() with patcher.require()
-- ============================================================================
function lib.export()
	_G.require = lib.require
end

-- ============================================================================
-- reset() - Replaces 'global' require() with original require().
-- ============================================================================
function lib.reset()
	_G.require = orig_require
end

-- ============================================================================
-- mkFolder() - Replaces 'global' require() with original require().
-- ============================================================================
function lib.mkFolder( path )
	path = system.pathForFile( path, system.DocumentsDirectory )
   if( exists( path ) ) then return true end
   local result, reason = lfs.mkdir( path )
   if( not result  ) then
      print("Tried to make folder " .. tostring( path ) .. " and failed: " .. tostring( reason ) )
   end
   return result
end

-- ============================================================================
-- get( src, dst [, onSuccess [, onFail [, onProgress ]]] ) - Get remote copy of script.
-- ============================================================================
function lib.get( src, dst, onSuccess, onFail, onProgress )
	onSuccess = onSuccess or function() end
	onFail = onFail or function() end
	onProgress = onProgress or function() end

	dst = strGSub( dst, "%.", "/" ) ..".lua"

	local dstBase = system.DocumentsDirectory

	local expandedDst = system.pathForFile( dst, dstBase )

	if( verbose ) then
  		print("patcher: Attempting to dowload patch " .. tostring(src) .. " to: " .. expandedDst )
  	end


	if( expandedDst == nil ) then
		print("WARNING: patcher: lib.get() - Path not created for: " .. tostring(dst) )
		onFail( 
			{ 
				src 				= src,
				dst 				= dst,
				expandedDst 	= expandedDst,
				success 			= false, 
				reason 			= "Target folder not not found.",
			} )

	else
		local function listener(event)
			if( event.isError == true ) then
				print("WARNING: patcher: lib.get() - Unknown transfer response: " .. tostring(src) )
				onFail( 
					{ 
						src 				= src,
						dst 				= dst,
						expandedDst 	= expandedDst,
						success 			= false,
						reason 			= "Unknown transfer response.",
						response 		= event.response,
						orig_event		= event,
					} )
			
			elseif( event.phase == "ended" ) then
				if( verbose ) then
			  		print("patcher: Download complete " .. tostring(src) .. " to: " .. expandedDst )
			  	end

				onProgress( event )
				onSuccess( 
					{ 
						src 				= src,
						dst 				= dst,
						expandedDst 	= expandedDst,		
						success 			= true, 
						reason 			= "Transfer completed", 
						orig_event		= event,
					} )
			else
				onProgress( event )
			end
		end

		local params = {}
		params.progress = true
		network.download( src, "GET", listener, params, dst, system.DocumentsDirectory )		
	end
end

-- ============================================================================
-- write( path ) - Write contents of 'patch' to path file at path
-- ============================================================================
function lib.write( patch, path )
	if( verbose ) then
  		print("patcher: Writing patch file: " .. tostring(path) )
  	end
  	path = strGSub( path, "%.", "/" ) ..".lua"
	writeFile( patch, path )
end
-- ============================================================================
-- remove( path ) - Remove 'path' patch file from documents.
-- ============================================================================
function lib.remove( path )
	if( verbose ) then
  		print("patcher: Removing patch file: " .. tostring(path) )
  	end
  	path = strGSub( path, "%.", "/" ) ..".lua"
	path = system.pathForFile( path, system.DocumentsDirectory )
   local result, reason = os.remove(path)
   if( not result ) then
      print("Tried to remove " .. tostring( path ) .. " and failed: " .. tostring( reason ) )
   end
   return result
end


-- ============================================================================
-- require( path ) - Replaces traditional require with one capable of loading
--							scripts from resources and/or patches from documents directories.
-- ============================================================================
function lib.require( path )	
	local function loadLocal( msg )
		if( verbose ) then
	  		print("patcher: Using unpatched copy of: " .. tostring(path) )
	  	end
	  	return orig_require( path )
	end
	--
	local module
	local path2 = strGSub( path, "%.", "/" )
	--
	if( enabled ) then
		if( verbose ) then
			print("patcher: Attempting to load patch " .. tostring(path) )
		end

		-- Returned cached copy?
		if( enabled and caching and loadedModules[path] ) then
			if( verbose ) then
				print("patcher: Returning cached copy of patch " .. tostring(path) )
			end
			return loadedModules[path]
		end

		-- Found patch?
		if (not exists( path2 .. ".lua", system.DocumentsDirectory ) ) then		
			if( verbose ) then
		  		print("Patch file not found: " .. tostring(path) )
		  	end
			return loadLocal()
		end

		-- Load and package patch for processing
		local module = 
			"local package = {}\n" ..
			"function package.load()\n" ..
			readFile( path2 .. ".lua", system.DocumentsDirectory ) .. "\n" ..
			"end\n" ..
			"return package\n"

		-- Process patch
		local function processPatchPart1()			
			module = loadstring( module )
		end
		if( not pcall( processPatchPart1 ) ) then
			return loadLocal( "WARNING: patcher: Patch load failed " .. tostring(path) )
		end
		local function processPatchPart2()
			module = module()
		end
		if( not pcall( processPatchPart2 ) ) then
			return loadLocal( "WARNING: patcher: Patch load failed " .. tostring(path) )
		end
		if( not module.load ) then
			return loadLocal( "WARNING: patcher: Patch load failed " .. tostring(path) )
		end
		local function processPatchPart3()
			module = module.load()
		end
		if( not pcall( processPatchPart3 ) ) then
			return loadLocal( "WARNING: patcher: Patch load failed " .. tostring(path) )
		end
		loadedModules[path] = module
		if( verbose ) then
			print("patcher: Successfully patched " .. tostring(path) )
		end
		return module
	end

	return loadLocal()
end
-- ============================================================================
-- PLUGIN CORE IMPLEMENTATION ENDS
-- ============================================================================

return lib
