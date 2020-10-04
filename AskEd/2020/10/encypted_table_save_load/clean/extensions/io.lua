-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- =============================================================
-- io.* - Extension(s)
-- =============================================================
local lfs      = require "lfs"
local strGSub  = string.gsub
local onWin       = ( system.getInfo("platform") == "Win" )
local onOSX       = ( system.getInfo("platform") == "Mac OS X" )
local onAndroid   = ( system.getInfo("platform") == "Android" ) 

-- 
-- repairPath( path ) -- Converts path to 'OS' correct style of back- or forward- slashes
-- 
function io.repairPath( path )
   if( onOSX or onAndroid ) then
      path = strGSub( path, "\\", "/" )
      path = path strGSub( path, "//", "/" )
   elseif( onWin ) then
      path = strGSub( path, "/", "\\" )
   end
   return path
end


-- WORKS FOR FILES AND FOLDERS
function io.exists( fileName, base )
   local base = base or system.DocumentsDirectory	
   if( base ) then
      fileName = system.pathForFile( fileName, base )
   end   
   if not fileName then return false end
   fileName = io.repairPath( fileName )
   local attr = lfs.attributes( fileName )
   return (attr and (attr.mode == "file" or attr.mode == "directory") )
end


if( io.readFile ) then
   print("ERROR! io.readFile() exists already")
else
   function io.readFile( fileName, base )
      local base = base or system.DocumentsDirectory
      local fileContents

      if( io.exists( fileName, base ) == false ) then
         return nil
      end

      local fileName = fileName
      if( base ) then
         fileName = system.pathForFile( fileName, base )
      end
      fileName = io.repairPath( fileName )
      local f=io.open(fileName,"rb")
      if (f == nil) then 
         return nil
      end

      fileContents = f:read( "*a" )

      io.close(f)

      return fileContents
   end
end

if( io.writeFile ) then
   print("ERROR! io.writeFile() exists already")
else
   function io.writeFile( dataToWrite, fileName, base )
      local base = base or system.DocumentsDirectory

      local fileName = fileName
      if( base ) then
         fileName = system.pathForFile( fileName, base )
      end
      fileName = io.repairPath( fileName )
      local f=io.open(fileName,"wb")
      if (f == nil) then 
         return nil
      end

      f:write( dataToWrite )

      io.close(f)

   end
end

if( io.appendFile ) then
   print("ERROR! io.appendFile() exists already")
else
   function io.appendFile( dataToWrite, fileName, base )
      local base = base or system.DocumentsDirectory

      local fileName = fileName
      if( base ) then
         fileName = system.pathForFile( fileName, base )
      end
      if not fileName then return false end
      local f=io.open(fileName,"ab")
      if (f == nil) then 
         return nil
      end

      f:write( dataToWrite )

      io.close(f)
   end
end


if( io.readFileTable ) then
   print("ERROR! io.readFileTable() exists already")
else
   function io.readFileTable( fileName, base )
      local base = base or system.DocumentsDirectory
      local fileContents = {}

      if( io.exists( fileName, base ) == false ) then
         return fileContents
      end

      local fileName = fileName
      if( base ) then
         fileName = system.pathForFile( fileName, base )
      end
      fileName = io.repairPath( fileName )
      local f=io.open(fileName,"rb")
      if (f == nil) then 
         return fileContents
      end

      for line in f:lines() do
         fileContents[ #fileContents + 1 ] = string.trim(line)
      end

      io.close( f )

      return fileContents
   end
end

if( io.mkdir ) then
   print("ERROR! io.mkdir() exists already")
else
   function io.mkdir( dirName, base )
      local base = base or system.DocumentsDirectory
      local cur_dir = lfs.currentdir()
      local temp_path = system.pathForFile( "", base )
      temp_path = io.repairPath( temp_path )
      local success = lfs.chdir( temp_path ) 
      if success then
         success = lfs.mkdir( dirName )         
         if( cur_dir ) then
            lfs.chdir( cur_dir ) 
         end
      end
      return success
   end
end


-- 
-- cleanFileName( filename ) -- Make sure filename is save for saving.
-- 
function io.cleanFileName( filename )
   local clean = filename
   clean = clean:gsub(" ", '')
   clean = clean:gsub("`", '')
   clean = clean:gsub("'", '')
   clean = clean:gsub("%[", '')
   clean = clean:gsub("%]", '')
   clean = clean:gsub("%{", '')
   clean = clean:gsub("%}", '')
   clean = clean:gsub("%(", '')
   clean = clean:gsub("%)", '')
   clean = clean:gsub("%!", '')
   clean = clean:gsub("%^", '')
   clean = clean:gsub("%%", '')
   clean = clean:gsub("%&", '')
   clean = clean:gsub("%$", '')
   clean = clean:gsub("%#", '')
   clean = clean:gsub("%@", '')
   clean = clean:gsub("%*", '')
   clean = clean:gsub("%=", '')
   clean = clean:gsub("%*", '')
   return clean
end


