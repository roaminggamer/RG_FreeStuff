
-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2016
-- =============================================================
-- RG Files Module Library - Loader and Initializer
-- =============================================================
--                         License
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
local lfs         = require "lfs"
local json        = require "json"

local strGSub     = string.gsub
local strSub      = string.sub
local strFormat   = string.format
local strFind     = string.find

local pathSep = ( onWin ) and "\\" or "/"

local RGFiles

local util = {}

--
-- isFolder( path ) -- Returns 'true' if path is a folder.
--
function util.isFolder( path )
   if not path then
      return false
   end
   return lfs.attributes( path, "mode" ) == "directory"
end

--
-- isFile( path ) -- Returns 'true' if path is a file.
--
function util.isFile( path )
   if not path then
      return false
   end
   return lfs.attributes( path, "mode" ) == "file"
end

--
-- dumpAttributes( path ) -- Returns 'true' if path is a file.
--
function util.dumpAttributes( path )
   table.print_r( lfs.attributes( path  ) or { result = tostring( path ) .. " : not found?" }  )
end

-- 
-- repairPath( path ) -- Converts path to 'OS' correct style of back- or forward- slashes
-- 
function util.repairPath( path, forceForward )   
   if( onOSX or onAndroid or forceForward == true) then
      path = strGSub( path, "\\", "/" )
      path = path strGSub( path, "//", "/" )
   elseif( onWin ) then
      path = strGSub( path, "//", "/" )
      path = strGSub( path, "/", "\\" )
   end
   path = strGSub( path, "//", "/" )
   return path
end

-- =====================================================
-- File Operations
-- =====================================================
function util.mvFile( src, dst ) -- Move/Rename File
   local result, reason = os.rename(src, dst)
   if( not result ) then
      print("Tried to move/rename " .. tostring( src ) .. " to " ..  dst " and failed: " .. tostring( reason ) )
   end
   return result
end

function util.rmFile( name ) -- Remove File
   local result, reason = os.remove(name)
   if( not result ) then
      print("Tried to remove " .. tostring( name ) .. " and failed: " .. tostring( reason ) )
   end
   return result
end

-- EFM - MAY NOT WORK WELL FOR IMAGES, SOUNDS, etc.
function util.cpFile( src, dst ) -- Copy File
   retVal = RGFiles.util.writeFile( RGFiles.util.readFile( src ) or "", dst ) 
   return true -- EFM need better error checking
end


-- =====================================================
-- Folder Operations
-- =====================================================
function util.mvFolder( src, dst ) -- Move/Rename File
   local result, reason = os.rename(src,dst)
   if( not result ) then
      print("Tried to move/rename " .. tostring( src ) .. " to " .. tostring( dst ) .. " and failed: " .. tostring( reason ) )
   end
   return result
end

function util.mkFolder( name, makeFailOK ) -- Remove File
   if( util.exists( name ) ) then return true end
   makeFailOK = makeFailOK or false
   local result, reason = lfs.mkdir (name)
   if( not result and makeFailOK == false ) then
      print("Tried to make folder " .. tostring( name ) .. " and failed: " .. tostring( reason ) )
   end
   return result
end

-- EFM eventually replace this with pure lfs.* and io.* calls
function util.cpFolder( src, dst, makeFailOK ) -- Remove Folder
   makeFailOK = true
   src = util.repairPath( src, true )
   dst = util.repairPath( dst, true )
   makeFailOK = makeFailOK or false
   local recurse   
   recurse = function( path )
      local toRecurse
      if( path == nil ) then
         path = ""
         toRecurse = src
      else
         toRecurse = src .. "/" .. path 
      end
      for file in lfs.dir( toRecurse ) do
         if( file == "." or file == ".." ) then
            -- SKIP
         else
            local newpath =  util.repairPath( path .. "/" .. file )
            if( util.isFolder( src .. "/" .. newpath ) ) then
               if( not util.mkFolder( dst .. "/" .. newpath, makeFailOK  ) ) then return false end
               recurse( newpath )
            elseif( util.isFile( src .. "/" .. newpath ) ) then
               if( not util.cpFile( util.repairPath(src .. newpath), util.repairPath(dst .. newpath) ) ) then
                  return false
               end
            else 
               print(" ERROR - what is: ", newpath )
            end
         end
      end   
   end
   if( not util.isFolder( src ) ) then return false end
   if( not util.mkFolder( dst, makeFailOK ) ) then return false end
   recurse( )
end   

-- EFM https://forums.coronalabs.com/topic/29387-deleting-all-files-in-documents-directory/
--
-- EFM - Added 'safety check' to this to prevent recursions from roots of
-- drives, myfolder, or desktop ex: (c:/) would be illegal
--
function util.rmFolder( path ) -- Remove Folder

   if( not path or 
       string.len( path ) <= 3 or
       path == ssk.RGFiles.desktop.getDesktopRoot() or 
       path == ssk.RGFiles.desktop.getMyDocumentsRoot() ) then
      print("Woah!  Looks like you're trying to wipe out a whole drive, my documents, or desktop! " )
      return false
   end

   local recurse
   recurse = function( child )
      local fullPath
      for file in lfs.dir( child ) do
         if( file == "." or file == ".." ) then
            -- SKIP
         else
            fullPath = util.repairPath( child .. "/" .. file, true )
            if( util.isFolder( fullPath ) ) then
               recurse( fullPath )
               local result, reason = lfs.rmdir( fullPath )
               if( not result ) then
                  print("Tried to remove folder " .. tostring( fullPath ) .. " and failed: " .. tostring( reason ) )
               end   
            elseif( util.isFile( fullPath ) ) then
               util.rmFile( fullPath )
            end
         end
      end   
   end
   recurse( path )

   local result, reason = lfs.rmdir(path)
   if( not result ) then
      print("Tried to remove folder " .. tostring( path ) .. " and failed: " .. tostring( reason ) )
   end   
end   


-- =====================================================
-- Table Save & Load
-- =====================================================
--
-- saveTable( tbl, path ) -- Save a table to a fixed path.
--
function util.saveTable( tbl, path, secure )
   local security = ssk.security
   if(secure and security.getKeyString() == nil) then return false end

   local fh = io.open( path, "w" )
   if( fh ) then
      local toWrite = json.encode( tbl )
      if( secure) then
         toWrite = security.encode( toWrite )
      end
      fh:write(toWrite)
      io.close( fh )
      return true    
   end
   return false
end

--
-- loadTable( path, base ) -- Load a table from a fixed path.
--
function util.loadTable( path, secure )
   local security = ssk.security
   local fh = io.open( path, "r" )
   if( fh ) then
      local contents = fh:read( "*a" )
      io.close( fh )
      if( secure ) then
         contents = security.decode( contents )
      end
      local newTable = json.decode( contents )
      return newTable
   else
      return nil
   end
end



-- =====================================================
-- File Exists, Read, Write, Append, ReadFileTable
-- =====================================================

--
-- exists( path ) - Verify file at path exists.
--
function util.exists( path )
   if not path then return false end
   path = RGFiles.util.repairPath( path )
   local attr = lfs.attributes( path )
   return (attr and (attr.mode == "file" or attr.mode == "directory") )
end

--
-- readFile( path ) - Read from file at path.
--
function util.readFile( path ) 
   local file = io.open( path, "rb" )  
   if file then
      local data = file:read( "*all" )
      io.close( file )
      return data
   end
   return nil
end

function util.readFile2( path ) 
   local file = io.open( path, "r+" )  
   if file then
      local data = file:read( "*all" )
      io.close( file )
      return data
   end
   return nil
end

--
-- writeFile( dataToWrite, path ) - Write 'dataToWrite' to file at path.
--
function util.writeFile( content, path )
   local file = io.open( path, "wb" )
   if file then
      file:write( content )
      io.close( file )
      file = nil
   end
end

--
-- writeFile( dataToWrite, path ) - Write 'dataToWrite' to file at path.
--
function util.writeFile2( content, path )
   local file = io.open( path, "w+" )
   if file then
      file:write( content )
      io.close( file )
      file = nil
   end
end

--
-- appendFile( dataToWrite, path ) - Append 'dataToWrite' to file at path.
--
function util.appendFile( dataToWrite, path )
   --path = RGFiles.getPath( path, base )
   --print(path)

   local f=io.open(path,"a")
   if (f == nil) then 
      return nil
   end

   f:write( dataToWrite )

   io.close(f)
end

--
-- readFileToTable( path ) - Read file at path into numerically indexed table, where each newline starts a new table entry.
--
function util.readFileToTable( path )
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


--
-- readFileToTable( path ) - Read file at path into numerically indexed table, where each newline starts a new table entry.
--
function util.readFileToTable2( path )
   local fileContents = {}
   local f=io.open(path,"r+")
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
function util.getFilesInFolder( path )
   if path then      
      local files = {}     
      for file in lfs.dir( path ) do 
         if file ~= "." and file ~= ".." and file ~= ".DS_Store" then
            files[ #files + 1 ] = file
         end         
      end
      return files      
   end   
   return nil
end

--
-- findAllFiles( path ) -- Returns table of all files in folder.
--
function util.findAllFiles( path )
   local tmp = util.getFilesInFolder( path )
   local files = {}
   for k,v in pairs( tmp ) do
      files[v] = v
   end
   for k,v in pairs( files ) do
      local newPath =  path and (path .. "/" .. v) or v
      local isDir = util.isFolder( newPath )
      if( isDir ) then
         files[v] = util.findAllFiles( newPath )
      else
      end
   end
   return files
end

--
-- flattenNames -- EFM
--
function util.flattenNames( t, sep, prefix ) 
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
function util.getLuaFiles( files )
   local luaFiles = util.flattenNames( files, "." )
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
function util.getResourceFiles( files )
   local resourceFiles = util.flattenNames( files, "/" )
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
function util.keepFileTypes( files, extensions )
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



function util.findFileInPath( fileToFind, folderToSearch )
   print( "Looking for file: " .. tostring( folderToSearch ) .. " in folder: " .. tostring( fileToFind ) )
   local recurse   
   recurse = function( path )
      local toRecurse
      if( path == nil ) then
         path = ""
         toRecurse = fileToFind
      else
         toRecurse = fileToFind .. "/" .. path 
      end
      toRecurse = util.repairPath( toRecurse )
      for file in lfs.dir( toRecurse ) do
         if( file == "." or file == ".." ) then
         else
            local newpath =  util.repairPath( path .. "/" .. file )
            if( util.isFolder( fileToFind .. "/" .. newpath ) ) then
              local found, atPath = recurse( newpath )
               if( found ) then 
                print("early abort")
                return found, util.repairPath( atPath , true )
              end
            elseif( util.isFile( fileToFind .. "/" .. newpath ) ) then
               if( file == folderToSearch ) then
                  print("Found Corona executable at ", fileToFind .. "/" .. newpath )
                  return true, fileToFind .. "/" .. newpath
               end
            else 
               print(" ERROR - what is: ", newpath )
            end
         end
      end   
   end
   return recurse()
end   

-- =============================================================
-- =============================================================
function util.attach( module )
   RGFiles = module
   module.util = util
end
return util


-- =============================================================
-- TRASH   TRASH   TRASH   TRASH   TRASH   TRASH   TRASH   TRASH   
-- =============================================================
--[[
function util.rmFolder( path ) -- Remove Folder
   print("remove folder", path)
   local retVal = false
   if( onWin ) then
      local command = "rmdir /q /s " .. '"' .. path .. '" 1>NUL'
      retVal =  (os.execute( command ) == 0)
   
   elseif( onOSX ) then
      local command = "rm -rf " .. '"' .. path .. '"'
      retVal =  (os.execute( command ) == 0)
   
   else -- Must be on Mobile device
      error("Sorry mobile folder to folder copies not supported yet!")      
      retVal = lfs.rmdir( path ) -- EFM only works for empty folders
   end      
   return retVal
end 
--]]  

--[[
function util.cpFolder( src, dst ) -- Copy Folder
   local retVal = false
   if(onWin) then
      local command = "xcopy /Y /S " .. '"' .. src  .. '" "' .. dst .. '\\"'
      retVal =  (os.execute( command ) == 0)
   
   elseif( onOSX ) then
      local command = "cp -r" .. '"' .. src  .. '" "' .. dst .. '"'
      retVal =  (os.execute( command ) == 0)
   
   else -- Must be on Mobile device
      error("Mobile folder to folder copies not supported yet!")
      -- EFM NO SOLUTION YET
      retVal = false
   end      
   return retVal
end
]]

--[[
function util.cpFile( src, dst ) -- Copy File
   local retVal
   if(onWin) then
      local command = "copy /Y " .. '"' .. src  .. '" "' .. dst .. '"'      
      retVal =  (os.execute( command ) == 0)
         
   elseif( onOSX ) then
      local command = "cp " .. '"' .. src  .. '" "' .. dst .. '"'
      retVal =  (os.execute( command ) == 0)
   
   else -- Must be on Mobile device...
      retVal = RGFiles.util.writeFile( RGFiles.util.readFile( src ) or "", dst ) 
   end      
   return retVal
end
--]]

