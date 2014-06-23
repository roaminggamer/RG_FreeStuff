-- 
-- Code below used to create the table of words from "sourceList.txt" which was exported from "words_81k.db" via sqlitebrowser.exe
--

local json = require( "json" )

function io.readFileTable( fileName, base )
	local base = base or system.DocumentsDirectory
	local fileContents = {}

	local fileName = fileName
	if( base ) then
		fileName = system.pathForFile( fileName, base )
	end

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

function table.save( theTable, fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	fh = io.open( path, "w" )

	if(fh) then
		fh:write(json.encode( theTable ))
		io.close( fh )
		return true
	end	
	return false
end


local tmp = io.readFileTable( "sourceList.txt", system.ResourceDirectory )

local tmp2  = {}

for i = 1, #tmp do
	tmp2[tmp[i]] = 1
end

table.save( tmp2, "words_81K.tbl")
