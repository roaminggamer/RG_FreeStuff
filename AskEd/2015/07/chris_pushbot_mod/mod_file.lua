-------------------------------------------------------------
-- File Module - simple storage
-- (c)2014 C. Byerley - dvelephant.net
-------------------------------------------------------------
local this = {}

this.write = function( file_name, data, baseDirectory )
	local baseDirectory = baseDirectory or system.DocumentsDirectory
	local path = system.pathForFile( file_name, baseDirectory )

	local file = io.open( path, "w" )

	file:write( data )

	io.close( file )

	return true
end

this.read = function( file_name, baseDirectory )
	local baseDirectory = baseDirectory or system.DocumentsDirectory
	local path = system.pathForFile( file_name, baseDirectory )
	
	local file

	if path then
		file = io.open( path, "r" )
	end

	if ( file ~= nil ) then
	    local data = file:read( "*a" )
	    io.close( file )
	    return data
	else
	    return nil
	end
end


return this
