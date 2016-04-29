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
local lfs 			= require "lfs"
local json        = require "json"

local strGSub		= string.gsub
local strSub		= string.sub
local strFormat 	= string.format
local strFind     = string.find

local pathSep = ( onWin ) and "\\" or "//"


local rgFiles = {}

-- =====================================================
-- The Standard Corona (Base) Directories
-- =====================================================
local resourceRoot = system.pathForFile('main.lua', system.ResourceDirectory)
local documentRoot = system.pathForFile('', system.DocumentsDirectory) .. pathSep
if( not resourceRoot ) then
	resourceRoot = ""
else
	resourceRoot = resourceRoot:sub(1, -9)
end
local temporaryRoot = system.pathForFile('', system.TemporaryDirectory)
function rgFiles.getResourceRoot() return resourceRoot end
function rgFiles.getDocumentsRoot() return documentRoot  end
function rgFiles.getTemporaryRoot() return temporaryRoot end

-- =====================================================
-- General File and Folder Helper Functions
-- =====================================================

--
-- repairPath( path ) -- Converts path to 'OS' correct style
--
function rgFiles.repairPath( path )
   if( onOSX or onAndroid ) then
      path = strGSub( path, "\\", "/" )
      path = path strGSub( path, "//", "/" )
   elseif( onWin ) then
      path = strGSub( path, "/", "\\" )
   end
   return path
end


--
-- isFolder( path ) -- Returns 'true' if path is a folder.
--
function rgFiles.isFolder( path )
	if not path then
		return false
	end
	return lfs.attributes( path, "mode" ) == "directory"
end

--
-- isFile( path ) -- Returns 'true' if path is a file.
--
function rgFiles.isFile( path )
	if not path then
		return false
	end
	return lfs.attributes( path, "mode" ) == "file"
end


--
-- dumpAttributes( path ) -- Returns 'true' if path is a file.
--
function rgFiles.dumpAttributes( path )
   table.print_r( lfs.attributes( path  ) or { result = tostring( path ) .. " : not found?" }  )
end


--
-- getFilesInFolder( path ) -- Returns table of file names in folder
--
function rgFiles.getFilesInFolder( path )
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

--
-- findAllFiles( path ) -- Returns table of all files in folder.
--
function rgFiles.findAllFiles( path )
	local tmp = rgFiles.getFilesInFolder( path )
	local files = {}
	for k,v in pairs( tmp ) do
		files[v] = v
	end
	for k,v in pairs( files ) do
		local newPath =  path and (path .. "/" .. v) or v
		local isDir = rgFiles.isFolder( newPath )
		if( isDir ) then
			files[v] = rgFiles.findAllFiles( newPath )
		else
		end
	end
	return files
end

--
-- flattenNames -- EFM
--
function rgFiles.flattenNames( t, sep, prefix ) 
	local flatNames = {}
	local function flatten(t,indent,_prefix)
		local path 
		if (type(t)=="table") then
			for k,v in pairs(t) do
				if (type(v)=="table") then
					path = (_prefix) and (_prefix .. indent .. tostring(k)) or tostring(k)
					path = flatten(v,indent,path)	
               path = (prefix) and (prefix .. path) or path
				else
					path = (_prefix) and (_prefix .. indent .. tostring(k)) or tostring(k)
               path = (prefix) and (prefix .. path) or path
					flatNames[path] = path
				end
			end
		else
			path = (_prefix) and (_prefix .. indent .. tostring(t)) or tostring(t)
         path = (prefix) and (prefix .. path) or path
			flatNames[path] = path
		end
		return _prefix or ""
	end
	if (type(t)=="table") then
		flatten(t,sep)
	else
		flatten(t,sep)
	end
	return flatNames
end

--
-- getLuaFiles - EFM
--
function rgFiles.getLuaFiles( files )
	local luaFiles = rgFiles.flattenNames( files, "." )
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

--
-- getResourceFiles - EFM
--
function rgFiles.getResourceFiles( files )
	local resourceFiles = rgFiles.flattenNames( files, "/" )
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

--
-- keepFileTypes - EFM
--
function rgFiles.keepFileTypes( files, extensions )
   for i = 1, #extensions do
      extensions[i] = strGSub( extensions[i], "%.", "" ) 
   end	
   local filesToKeep = {}
	for k,v in pairs(files) do
      local isMatch = false
      for i = 1, #extensions do
         if( string.match( v, "%." .. extensions[i] ) ) then
            isMatch = true    
            print(v)
         end
      end
      if( isMatch ) then
         filesToKeep[k] = v         
      end
	end
	return filesToKeep
end


-- =====================================================
-- Desktop (OSX and Windows) Specific Functions & Helpers
-- =====================================================
rgFiles.DesktopDirectory = {}
rgFiles.MyDocumentsDirectory = {}

--
-- getDesktop() - Returns the desktop path as a string.
--
local desktopPath = ""
if( onWin ) then
	desktopPath = os.getenv("appdata")
	local appDataStart = string.find( desktopPath, "AppData" )
	if( appDataStart ) then
		desktopPath = string.sub( desktopPath, 1, appDataStart-1 )
		desktopPath = desktopPath .. "Desktop"
	end
elseif( onOSX ) then
end
function rgFiles.getDesktop( ) return desktopPath end

--
-- getMyDocuments() - Returns the users' documents path as a string.
--
local myDocumentsPath = ""
if( onWin ) then
	myDocumentsPath = os.getenv("appdata")
	local appDataStart = string.find( myDocumentsPath, "AppData" )
	if( appDataStart ) then
		myDocumentsPath = string.sub( myDocumentsPath, 1, appDataStart-1 )
      if( rgFiles.isFolder(myDocumentsPath .. "Documents") ) then         
         myDocumentsPath = myDocumentsPath .. "Documents"
      else
         myDocumentsPath = myDocumentsPath .. "My Documents" -- EFM - is this right?  Win 7 and before?
      end
	end
elseif( onOSX ) then
end
function rgFiles.getMyDocuments( ) return myDocumentsPath end

--
-- mkdir( path, base ) -- Make a directory. (base defaults to rgFile.DesktopDirectory)
--
function rgFiles.mkDesktopDir( path, base )
   base = base or rgFiles.DesktopDirectory   
   local fullPath = (base == rgFiles.DesktopDirectory ) and desktopPath or myDocumentsPath
   fullPath = fullPath .. "\\" .. path
   return lfs.mkdir( fullPath )
end   

function rgFiles.mkDocumentsDir( dirName )
	local temp_path = system.pathForFile( "", system.DocumentsDirectory )
	local success = lfs.chdir( temp_path ) 
	local new_folder_path
	if success then
		success = lfs.mkdir( dirName )
		new_folder_path = lfs.currentdir() .. "/" .. dirName
	end
	return success
end


--
-- rmdir( path, base ) -- Remove a directory. (base defaults to rgFile.DesktopDirectory)
--
function rgFiles.rmdir( path, base )
   base = base or rgFiles.DesktopDirectory   
   local fullPath = (base == rgFiles.DesktopDirectory ) and desktopPath or myDocumentsPath
   fullPath = fullPath .. "\\" .. path
   return lfs.rmdir( fullPath )
end 

function rgFiles.rmDocumentsFile( dirName )
	local temp_path  = system.pathForFile( dirName , system.DocumentsDirectory )
	if(onWin) then
		command = "del " .. '"' .. temp_path .. '"'
	else
		--command = "rm -rf " .. '"' .. temp_path .. '"'
		command = "rm " .. '"' .. temp_path .. '"'
	end
	------print( command )
	local retVal =  os.execute( command )
	if( retVal == 0 ) then return true end
	return false
end

--
-- getPath( path, base ) -- Converts a partial path to a full path. (base defaults to rgFile.DesktopDirectory)
--
function rgFiles.getPath( path, base )
   base = base or rgFiles.DesktopDirectory   
   local fullPath = (base == rgFiles.DesktopDirectory ) and desktopPath or myDocumentsPath
   return ( fullPath .. "\\" .. path )
end   

function rgFiles.getDocumentsPath( path )
   local root = documentRoot
   local fullPath = root .. path
   fullPath = rgFiles.repairPath( fullPath )
   return fullPath
end   


--
-- saveTable( tbl, path, base ) -- Save a table. (base defaults to rgFile.DesktopDirectory)
--
function rgFiles.saveTable( tbl, path, base )
   local path = rgFiles.getPath( path, base )
   print(path)   
   local fh = io.open( path, "w" )
   if( fh ) then
      fh:write(json.encode( tbl ))
      --fh:flush()
      io.close( fh )
      return true    
   end
   return false
end

--
-- loadTable( path, base ) -- Load a table. (base defaults to rgFile.DesktopDirectory)
--
function rgFiles.loadTable( tbl, path, base )
   local path = rgFiles.getPath( "/test.json", base )
   print(path)   
   local fh = io.open( path, "r" )
 	if( fh ) then
		local contents = fh:read( "*a" )
		io.close( fh )
		local newTable = json.decode( contents )
		return newTable
	else
		return nil
	end
end


--
-- EFM - TBD
function rgFiles.osCopy( src, dst, srcBase, dstBase )
   srcBase = srcBase or rgFiles.DesktopDirectory
   dstBase = dstBase or system.DocumentsDirectory
   local srcPath
   local dstPath
   if( rgFiles.isFile( src ) ) then
      srcPath = src
   else
      srcPath = rgFiles.getPath( "/" .. src, srcBase )
      srcPath = strGSub( srcPath, "//", "/" ) 
   end
   
   dstPath = system.pathForFile( dst, dstBase )      
   
   print(srcPath,dstPath)

	local command  
	if(onWin) then
		command = "copy /Y " .. '"' .. srcPath  .. '" "' .. dstPath .. '"'
	else
		command = "cp " .. '"' .. srcPath  .. '" "' .. dstPath .. '"'
	end
	print(command)
	local retVal =  os.execute( command )
	return ( retVal == 0 ) 
end

function rgFiles.directOSCopy( src, dst )
	local command  
	if(onWin) then
		--command = "copy /Y " .. '"' .. src  .. '" "' .. dst .. '"'
      command = "xcopy " .. '"' .. src  .. '" "' .. dst .. ' /A /Y "'
	else
		command = "cp " .. '"' .. src  .. '" "' .. dst .. '"'
	end
	print(command)
	local retVal =  os.execute( command )
	return ( retVal == 0 ) 
end



   
   --[[
   local path = rgFiles.getPath( path, base )
   print(path)   
   local fh = io.open( path, "w" )
   if( fh ) then
      fh:write(json.encode( tbl ))
      --fh:flush()
      io.close( fh )
      return true    
   end
   return false
end

--
-- loadTable( path, base ) -- Load a table. (base defaults to rgFile.DesktopDirectory)
--
function rgFiles.loadTable( tbl, path, base )
   local path = rgFiles.getPath( "/test.json", base )
   print(path)   
   local fh = io.open( path, "r" )
 	if( fh )then
		local contents = fh:read( "*a" )
		io.close( fh )
		local newTable = json.decode( contents )
		return newTable
	else
		return nil
	end
end
--]]


--[[

-- ==
--    table.load( fileName [, base ] ) - Loads table from file (Uses JSON library as intermediary)
-- ==
function table.load( fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	if(path == nil) then return nil end
	local fh, reason = io.open( path, "r" )
	
	if fh then
		local contents = fh:read( "*a" )
		io.close( fh )
		local newTable = json.decode( contents )
		return newTable
	else
		return nil
	end
end

--]]



if( _G.ssk ) then
	_G.ssk.rgFiles = rgFiles
end

return rgFiles


--
-- SCRATCH KEEP FOR NOW *** SCRATCH KEEP FOR NOW *** SCRATCH KEEP FOR NOW *** SCRATCH KEEP FOR NOW *** 
-- SCRATCH KEEP FOR NOW *** SCRATCH KEEP FOR NOW *** SCRATCH KEEP FOR NOW *** SCRATCH KEEP FOR NOW *** 
-- SCRATCH KEEP FOR NOW *** SCRATCH KEEP FOR NOW *** SCRATCH KEEP FOR NOW *** SCRATCH KEEP FOR NOW *** 
--

--[[
--
-- mkdir - EFM
--
function rgFiles.mkdir( dirName )
	local temp_path = system.pathForFile( "", system.DocumentsDirectory )
	local success = lfs.chdir( temp_path ) 
	local new_folder_path
	if success then
		success = lfs.mkdir( dirName )
		new_folder_path = lfs.currentdir() .. "/" .. dirName
	end
	return success
end

--
-- rmdir - EFM
--
function rgFiles.rmdir( dirName )
	local temp_path  = system.pathForFile( dirName , system.DocumentsDirectory )
	if(onWin) then
		command = "rmdir /Q /S " .. '"' .. temp_path .. '"'
	else
		command = "rm -rf " .. '"' .. temp_path .. '"'
	end
	------print( command )
	local retVal =  os.execute( command )
	if( retVal == 0 ) then return true end
	return false
end

--
-- mkdir2 - EFM
--
function rgFiles.mkdir2( dirName )
	local temp_path = dirName
	local new_folder_path
	success = lfs.mkdir( dirName )
	return success
end

--
-- rmdir2 - EFM
--
function rgFiles.rmdir2( dirName )
	local temp_path  = dirName
	if(onWin) then
		command = "rmdir /Q /S " .. '"' .. temp_path .. '"'
	else
		command = "rm -rf " .. '"' .. temp_path .. '"'
	end
	------print( command )
	local retVal =  os.execute( command )
	return ( retVal == 0 ) 
end

--
-- copyDocumentToResource - EFM
--
function rgFiles.copyDocumentToResource( fileName )
	local from = documentRoot
	local to = resourceRoot
	if(onWin) then
		from = from .. "\\"
	else
		from = from .. "/"
		to = to .. "/"
	end

	local command  
	if(onWin) then
		command = "copy /Y " .. '"' .. from .. fileName  .. '" "' .. to .. fileName .. '"'
	else
		command = "cp " .. '"' .. from .. fileName  .. '" "' .. to .. fileName .. '"'
	end
	print(command)
	local retVal =  os.execute( command )
	return ( retVal == 0 ) 
end

--
-- cdhome - EFM
--
function rgFiles.cdhome( )
	local temp_path = resourceRoot
	local success = lfs.chdir( temp_path ) -- returns true on success
	return success
end

--]]