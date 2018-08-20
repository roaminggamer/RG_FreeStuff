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
	local out = path .. "/dummy.rg"
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

local function testUID()
	local uid  = getUID() or "NONE FOUND"
	--display.newText( "UID: " .. uid, centerX, centerY - 100, native.systemFont, 64 )

	local path = files.desktop.getMyDocumentsRoot()
	path = files.util.repairPath( path, true )
	local infile = path .. "/info.rg"
	local data = files.util.readFile( infile ) or "ERROR"

	local tmp = display.newText( "", centerX, centerY, native.systemFont, 64 )

	if( data ~= uid ) then
		tmp.text = "FAILURE!"
		tmp:setFillColor(1,0,0)
	else
		tmp.text = "SUCCESS: " .. data
		tmp:setFillColor(0,1,0)
	end


	print(data)
end

testUID()
--files.desktop.explore( path )

