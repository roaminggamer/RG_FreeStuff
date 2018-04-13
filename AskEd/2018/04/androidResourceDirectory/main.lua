io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local ssk = require "ssk2.loadSSK"
ssk.init()
-- =====================================================

--[[
local function readFile( fileName )
	local f = io.open( fileName,"rb")
	
	if (f == nil) then 
		print( "failed to open", fileName )
	   return nil
	end

	fileContents = f:read( "*a" )

	io.close(f)
end

local data = io.readFile( "test1.rad", system.ReourceDirectory )
print( "test1.rad\n", data )


local data = readFile( "data/test1.txt" )
print( "data/test1.txt\n", data )
--]]

local path = ssk.files.resource.getPath( "test1.txt" )
print(path)
local data = ssk.files.util.readFile( path )
print(data)