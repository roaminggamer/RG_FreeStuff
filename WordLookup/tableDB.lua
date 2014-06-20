-- =============================================================
-- dbmgr.lua 
-- Database Manager
-- =============================================================
-- Last Modified: 27 APR 2014
-- =============================================================
local json = require( "json" )
local path
local db

local function initDB( dbfile )
	print("\n**** DBMGR: initDB() -> " .. dbfile .. "\n")
	db = table.load( dbfile, system.ResourceDirectory )
	print("\n**** DBMGR: initDB() - Completed")		
	local len = 0
	for k,v in pairs(db) do len = len + 1 end
	print("DB entries: " .. len)	
end

local function isWordInDB( word )
	local word = string.lower( word )
	if(db[word]) then 
		return true
	else
		return false
	end
end

local function findWordInDB( word )
	return isWordInDB( word )
end

local mRandom = math.random
local function testSearchSpeed( iterations )
	local iterations = iterations or 100
	local testwords = {}
	testwords[0] = "actor"
	testwords[1] = "plenty"
	testwords[2] = "dog"
	testwords[3] = "cat"
	testwords[4] = "penny"
	testwords[5] = "quarter"
	testwords[6] = "lane"
	testwords[7] = "man"
	testwords[8] = "woman"
	testwords[9] = "exact"

	local startTime = system.getTimer()
	for i=0, iterations do
		isWordInDB( testwords[mRandom(0,9)] )
	end
	local endTime = system.getTimer()

	local result = "Did " .. iterations .. " searches in " .. endTime - startTime .. " ms"
	print(result)

end


if( table.load == nil ) then
	-- ==
	--    table.load( fileName [, base ] ) - Loads table from file (Uses JSON library as intermediary)
	-- ==
	function table.load( fileName, base )
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
end

local public = {}

public.initDB			= initDB
public.isWordInDB 		= isWordInDB
public.findWordInDB 	= findWordInDB
public.test				= testSearchSpeed

return public