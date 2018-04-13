io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
--local ssk = require "ssk2.loadSSK"
--ssk.init()
-- =====================================================
local function readFile( fileName )
	local path = system.pathForFile( fileName, system.ResourceDirectory )
	local f = io.open( path,"rb")

	if (f == nil) then 
		print( "Failed to open", fileName )
	   return nil
	end
	fileContents = f:read( "*a" )
	io.close(f)
	return fileContents
end

local files = { "test1.txt", "test1.rad", 
                "data/test1.txt", "data/test1.rad" }

for i = 1, #files do
	print("Trying to read: ", files[i] )
	local data = readFile( files[i]  )
	print( "Got:\n", data, "\n-----------------\n" )
end

