-- EFM clipboard? - http://www.extrabit.com/copyfilenames/
-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2016
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

local private  = {}

local RGFiles = {}

-- =====================================================
-- HELPERS
-- =====================================================

--
-- isFolder( path ) -- Returns 'true' if path is a folder.
--
function RGFiles.isFolder( path )
	if not path then
		return false
	end
	return lfs.attributes( path, "mode" ) == "directory"
end

--
-- isFile( path ) -- Returns 'true' if path is a file.
--
function RGFiles.isFile( path )
	if not path then
		return false
	end
	return lfs.attributes( path, "mode" ) == "file"
end


--
-- dumpAttributes( path ) -- Returns 'true' if path is a file.
--
function RGFiles.dumpAttributes( path )
   table.print_r( lfs.attributes( path  ) or { result = tostring( path ) .. " : not found?" }  )
end

-- 
-- repairPath( path ) -- Converts path to 'OS' correct style of back- or forward- slashes
-- 
function RGFiles.repairPath( path )
   if( onOSX or onAndroid ) then
      path = strGSub( path, "\\", "/" )
      path = path strGSub( path, "//", "/" )
   elseif( onWin ) then
      path = strGSub( path, "/", "\\" )
   end
   return path
end

--
--	getPath( path [, base ] ) -- Generate and OS correct path for the specified path and base.
--
function RGFiles.getPath( path, base )
   base = base or RGFiles.DocumentsDirectory
   local root
   if( base == RGFiles.DocumentsDirectory ) then      
      root = private.documentRoot
   elseif( base == system.ResourceDirectory ) then
      root = private.resourceRoot
   elseif( base == RGFiles.TemporaryDirectory ) then
      root = private.temporaryRoot
   elseif( base == RGFiles.DesktopDirectory ) then
      root = private.desktopPath
   elseif( base == RGFiles.MyDocumentsDirectory ) then      
      root = private.myDocumentsPath
   else 
      root = base
   end
      
   local fullPath = root .. path
   fullPath = RGFiles.repairPath( fullPath )
   return fullPath
end

--
-- explore( path ) -- Open file browser to explore a specific path.
--
-- http://www.howtogeek.com/howto/15781/open-a-file-browser-from-your-current-command-promptterminal-directory/
function RGFiles.explore( path )
   local retVal
   if(onWin) then
      local command = "explorer " .. '"' .. path  .. '"'
      --print(command)
      retVal =  (os.execute( command ) == 0)
   
   elseif( onOSX ) then
      local command = "open " .. '"' .. path  .. '"'
      --print(command)
      retVal =  (os.execute( command ) == 0)
   
   else -- Must be on Mobile device      
      -- print("No file explorer for Mobile devices (yet).""
      return false
   end   
   
   return retVal

end


-- =====================================================
-- System Standard Folders
-- =====================================================
private.resourceRoot = system.pathForFile('main.lua', system.ResourceDirectory)
private.documentRoot = system.pathForFile('', system.DocumentsDirectory) .. pathSep
if( not private.resourceRoot ) then
	private.resourceRoot = ""
else
	private.resourceRoot = private.resourceRoot:sub(1, -9)
end
private.temporaryRoot = system.pathForFile('', system.TemporaryDirectory)  .. pathSep

function RGFiles.getResourceRoot() return private.resourceRoot end
function RGFiles.getDocumentsRoot() return private.documentRoot  end
function RGFiles.getTemporaryRoot() return private.temporaryRoot end

RGFiles.DocumentsDirectory = system.DocumentsDirectory
RGFiles.ResourceDirectory  = system.ResourceDirectory
RGFiles.TemporaryDirectory = system.TemporaryDirectory

-- =====================================================
-- Desktop ( OSX and Windows) Standard Folders
-- =====================================================
RGFiles.DesktopDirectory = {}
RGFiles.MyDocumentsDirectory = {}

--
-- getDesktop() - Returns the desktop path as a string.
--
private.desktopPath = ""
if( onWin ) then
	private.desktopPath = os.getenv("appdata")
	local appDataStart = string.find( private.desktopPath, "AppData" )
	if( appDataStart ) then
		private.desktopPath = string.sub( private.desktopPath, 1, appDataStart-1 )
		private.desktopPath = private.desktopPath .. "Desktop"
	end
elseif( onOSX ) then
   private.desktopPath = "TBD"
end
private.desktopPath = private.desktopPath .. pathSep 
function RGFiles.getDesktop( ) return private.desktopPath end

--
-- getMyDocuments() - Returns the users' documents path as a string.
--
private.myDocumentsPath = ""
if( onWin ) then
	private.myDocumentsPath = os.getenv("appdata")
	local appDataStart = string.find( private.myDocumentsPath, "AppData" )
	if( appDataStart ) then
		private.myDocumentsPath = string.sub( private.myDocumentsPath, 1, appDataStart-1 )
      if( RGFiles.isFolder(private.myDocumentsPath .. "Documents") ) then         
         private.myDocumentsPath = private.myDocumentsPath .. "Documents"
      else
         private.myDocumentsPath = private.myDocumentsPath .. "My Documents" -- EFM - is this right?  Win 7 and before?
      end
	end
elseif( onOSX ) then
   private.myDocumentsPath = "TBD"
end
private.myDocumentsPath = private.myDocumentsPath .. pathSep 
function RGFiles.getMyDocuments( ) return private.myDocumentsPath end

-- =====================================================
-- File Operations (excluding read, write, append which are further down in this module)
-- =====================================================
function RGFiles.copyFile( src, dst )
	local retVal
   if(onWin) then
		local command = "copy /Y " .. '"' .. src  .. '" "' .. dst .. '"'
      --print(command)
      retVal =  (os.execute( command ) == 0)
	
   elseif( onOSX ) then
		local command = "cp " .. '"' .. src  .. '" "' .. dst .. '"'
      --print(command)
      retVal =  (os.execute( command ) == 0)
   
   else -- Must be on Mobile device
      local data = RGFiles.readFileDirect( src ) or ""
      --print("Mobile Copy via read() ... write()")
      retVal = RGFiles.writeFileDirect( data, dst ) 
	end   
   
	return retVal
end

RGFiles.removeFile   = os.remove
RGFiles.moveFile     = os.rename
RGFiles.renameFile   = os.rename

-- =====================================================
-- Folder Operations
-- =====================================================
function RGFiles.copyFolder( src, dst )
   local retVal
   if(onWin) then
      local command = "xcopy /Y /S " .. '"' .. src  .. '" "' .. dst .. '\\"'
      --print(command)
      retVal =  (os.execute( command ) == 0)
	
   elseif( onOSX ) then
		local command = "cp -r" .. '"' .. src  .. '" "' .. dst .. '"'
      --print(command)
      retVal =  (os.execute( command ) == 0)
   
   else -- Must be on Mobile device
      error("Sorry mobile folder to folder copies not supported yet!")
      -- EFM NO SOLUTION YET
      retVal = false
	end   
   
	return retVal
end

function RGFiles.removeFolder( path )
   local retVal
   if(onWin) then
      local command = "rmdir /q /s " .. '"' .. path .. '"'
      --print(command)
      retVal =  (os.execute( command ) == 0)
	
   elseif( onOSX ) then
		local command = "rm -rf " .. '"' .. path .. '"'
      --print(command)
      retVal =  (os.execute( command ) == 0)
   
   else -- Must be on Mobile device
      error("Sorry mobile folder to folder copies not supported yet!")      
      retVal = lfs.rmdir( path ) -- EFM only works for empty folders
	end   
   
	return retVal
end	

function RGFiles.makeFolder( path )
   return lfs.mkdir( path )
end   

RGFiles.moveFolder   = os.rename
RGFiles.renameFolder = os.rename

-- =====================================================
-- Smart Operations (figures out if it is dealing with file or folder
-- =====================================================
function RGFiles.cp( src, dst ) 
   if( RGFiles.isFolder( src ) ) then
      RGFiles.copyFolder( src, dst )
   else
      RGFiles.copyFile( src, dst )
   end   
end

function RGFiles.rm( path ) 
   if( RGFiles.isFolder( path ) ) then
      RGFiles.removeFolder( path )
   else
      RGFiles.removeFile( path )
   end   
end

RGFiles.mv = os.rename


-- =====================================================
-- Table Save & Load
-- =====================================================
--function RGFiles.saveTable() end
--function RGFiles.loadTable() end

--
-- saveTable( tbl, path, base ) -- Save a table. (base defaults to rgFile.DesktopDirectory)
--
function RGFiles.saveTable( tbl, path, base )
   path = RGFiles.getPath( path, base )
   --print(path)   
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
function RGFiles.loadTable( path, base )
   path = RGFiles.getPath( path, base )
   --print(path)   
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


-- =====================================================
-- File Exists, Read, Write, Append, ReadFileTable
-- =====================================================
function RGFiles.exists( path, base )
   path = RGFiles.getPath( path, base )
   --print(path)

   if not path then return false end
   local f=io.open(path,"r")
   if (f == nil) then 
      return false
   end
   io.close(f)
   return true 
end


function RGFiles.readFile( path, base )
   path = RGFiles.getPath( path, base )
   --print(path)
   local fileContents
   local f=io.open(path,"rb")
   if (f == nil) then 
      return nil
   end

   fileContents = f:read( "*a" )

   io.close(f)

   return fileContents
end

function RGFiles.writeFile( dataToWrite, path, base )
   --print( dataToWrite, path, base )
   path = RGFiles.getPath( path, base )
   --print(path)

   local f=io.open(path,"wb")
   if (f == nil) then 
      return nil
   end

   f:write( dataToWrite )

   io.close(f)

end

function RGFiles.appendFile( dataToWrite, path, base )
   path = RGFiles.getPath( path, base )
   --print(path)

   local f=io.open(path,"a")
   if (f == nil) then 
      return nil
   end

   f:write( dataToWrite )

   io.close(f)
end


function RGFiles.readFileTable( path, base )
   path = RGFiles.getPath( path, base )
   --print(path)

   local fileContents = {}

   local f=io.open(path,"r")
   if (f == nil) then 
      return fileContents
   end

   for line in f:lines() do
      fileContents[ #fileContents + 1 ] = line
   end

   io.close( f )

   return fileContents
end

function RGFiles.readFileDirect( path ) 
	local file = io.open( path, "rb" )	
	if file then
		local data = file:read( "*all" )
		io.close( file )
		return data
	end
   return nil
end

function RGFiles.writeFileDirect( content, path )
	local file = io.open( path, "wb" )
	if file then
		file:write( content )
		io.close( file )
		file = nil
	end
end

function RGFiles.readFileTableDirect( path )
   local fileContents = {}
   local f=io.open(path,"r")
   if (f == nil) then 
      return fileContents
   end

   for line in f:lines() do
      fileContents[ #fileContents + 1 ] = line
   end

   io.close( f )

   return fileContents
end




-- =====================================================
-- Folder Scanners
-- =====================================================
--
-- getFilesInFolder( path ) -- Returns table of file names in folder
--
function RGFiles.getFilesInFolder( path )
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
function RGFiles.findAllFiles( path )
	local tmp = RGFiles.getFilesInFolder( path )
	local files = {}
	for k,v in pairs( tmp ) do
		files[v] = v
	end
	for k,v in pairs( files ) do
		local newPath =  path and (path .. "/" .. v) or v
		local isDir = RGFiles.isFolder( newPath )
		if( isDir ) then
			files[v] = RGFiles.findAllFiles( newPath )
		else
		end
	end
	return files
end

--
-- flattenNames -- EFM
--
function RGFiles.flattenNames( t, sep, prefix ) 
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
function RGFiles.getLuaFiles( files )
	local luaFiles = RGFiles.flattenNames( files, "." )
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
-- getResourceFiles - EFM could be better...
--
function RGFiles.getResourceFiles( files )
	local resourceFiles = RGFiles.flattenNames( files, "/" )
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
-- keepFileTypes - EFM ??
--
function RGFiles.keepFileTypes( files, extensions )
   for i = 1, #extensions do
      extensions[i] = strGSub( extensions[i], "%.", "" ) 
   end	
   local filesToKeep = {}
	for k,v in pairs(files) do
      local isMatch = false
      for i = 1, #extensions do
         if( string.match( v, "%." .. extensions[i] ) ) then
            isMatch = true    
            --print(v)
         end
      end
      if( isMatch ) then
         filesToKeep[k] = v         
      end
	end
	return filesToKeep
end



----------------------------------------------------------------------
--	Attach To SSK and return
----------------------------------------------------------------------
if( _G.ssk ) then
	ssk.RGFiles = RGFiles
else 
	_G.ssk = { RGFiles = RGFiles }
end

return RGFiles


