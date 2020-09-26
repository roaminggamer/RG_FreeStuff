-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local lfs         = require "lfs"
local json        = require "json"

local strGSub     = string.gsub
local strSub      = string.sub
local strFormat   = string.format
local strFind     = string.find

local pathSep = ( _G.onWin ) and "\\" or "/"

local RGFiles

local desktop = {}

--
-- Get path to DESKTOP root.
--
function desktop.getDesktopRoot()
   return RGFiles.desktopRoot
end
--
-- Create full DESKTOP path.
--
function desktop.getDesktopPath( path )
   local fullPath = RGFiles.desktopRoot .. path
   fullPath = RGFiles.util.repairPath( fullPath )
   return fullPath
end

-- Get path to My Documents root.
--
function desktop.getMyDocumentsRoot()
   return RGFiles.myDocumentsRoot
end
--
-- Create full My Documents path.
--
function desktop.getMyDocumentsPath( path )
   local fullPath = RGFiles.myDocumentsRoot .. path
   fullPath = RGFiles.util.repairPath( fullPath )
   return fullPath
end


--
-- explore( path ) -- Open file browser to explore a specific path.
--
-- http://www.howtogeek.com/howto/15781/open-a-file-browser-from-your-current-command-promptterminal-directory/
function desktop.explore( path )
   path = RGFiles.util.repairPath( path )
   local retVal = false
   if(_G.onWin) then
      local command = "explorer " .. '"' .. path  .. '"'
      print(command)
      retVal =  (os.execute( command ) == 0)
   
   elseif( onOSX ) then
      local command = "open " .. '"' .. path  .. '"'
      print(command)
      retVal =  (os.execute( command ) == 0)
   end   
   return retVal
end

--
-- discoverWindowsDrives( path ) -- Return table containing list of valid drives.

function desktop.discoverWindowsDrives( )
   local validDrives = {}

   local drives = "cdefghijklmnopqrstuvwxyz"
   for i = 1, string.len( drives ) do
      local path = string.sub( drives, i, i ) .. ":/"
      if( RGFiles.util.exists( path ) ) then
         validDrives[#validDrives+1] = path
      end
   end
   return validDrives, #validDrives
end


-- =============================================================
-- =============================================================
function desktop.attach( module )
	RGFiles = module
	module.desktop = desktop

   --
   -- Fix up 'drive' path.
   --
   desktop.getDrivePath = module.util.repairPath

end
return desktop


