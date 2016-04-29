-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- io Add-ons
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
local lfs = require "lfs"

local strGSub     = string.gsub
local strSub      = string.sub
local strFormat   = string.format
local strFind     = string.find


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


--[[ ONLY WORKS FOR FILES
function io.exists( fileName, base )
   local base = base or system.DocumentsDirectory	
   local fileName = fileName

   if( base ) then
      fileName = system.pathForFile( fileName, base )
   end
   if not fileName then return false end
   local f=io.open(fileName,"r")
   if (f == nil) then 
      return false
   end
   io.close(f)
   return true 
end
--]]

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
      local f=io.open(fileName,"r")
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
      local f=io.open(fileName,"w")
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
      local f=io.open(fileName,"a")
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
      local f=io.open(fileName,"r")
      if (f == nil) then 
         return fileContents
      end

      for line in f:lines() do
         fileContents[ #fileContents + 1 ] = line
      end

      io.close( f )

      return fileContents
   end
end

if( io.mkdir ) then
   print("ERROR! io.mkdir() exists already")
else
   function io.mkdir( dirName )
      local cur_dir = lfs.currentdir()
      local temp_path = system.pathForFile( "", system.DocumentsDirectory )
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



