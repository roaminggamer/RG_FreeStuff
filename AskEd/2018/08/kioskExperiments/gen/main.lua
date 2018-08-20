display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages

require "ssk.loadSSK"  -- Load a minimized version of the SSK library (just the bits we'll use)
-- wmic DISKDRIVE get SerialNumber
-- wmic csproduct get UUID

local files = ssk.RGFiles

local function getUID()
	local files = ssk.RGFiles
	local path = files.desktop.getMyDocumentsRoot()
	path = files.util.repairPath( path, true )
	local out = path .. "/info.rg"
	local cmd = 'ipconfig /all > ' .. out
	print( os.execute( cmd ) )
	local info = files.util.readFileToTable( out )
	--table.dump(info)
	local found = false
	for k,v in pairs( info ) do
		local lower = string.lower(v)
		if( not found and string.match( lower, "physical address" ) ) then
			lower = string.split(lower, ":")
			local uid = string.upper(lower[2])
			uid = string.trim( uid )
			return uid
		end
	end
end
local uid  = getUID() or "NONE FOUND"
print(uid)

display.newText( "GEN UID: " .. uid, centerX, centerY, native.systemFont, 64 )

local path = files.desktop.getMyDocumentsRoot()
path = files.util.repairPath( path, true )
local out = path .. "/info.rg"
files.util.writeFile( uid, out )

--files.desktop.explore( path )

