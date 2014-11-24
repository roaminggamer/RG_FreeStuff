local json = require "json"

local tlib = {}

-- ==
--    Save Table( theTable, fileName [, base ] ) - Saves table to file (Uses JSON library as intermediary)
-- ==
tlib.save = function( theTable, fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	local fh = io.open( path, "w" )

	if(fh) then
		fh:write(json.encode( theTable ))
		io.close( fh )
		return true
	end	
	return false
end


-- ==
--    Load Table( fileName [, base ] ) - Loads table from file (Uses JSON library as intermediary)
-- ==
tlib.load = function( fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	local fh, reason = io.open( path, "r" )
	
	if fh then
		local contents = fh:read( "*a" )
		io.close( fh )
		local newTable = json.decode( contents )
		return newTable
	else
		return nil
	end
end



return tlib