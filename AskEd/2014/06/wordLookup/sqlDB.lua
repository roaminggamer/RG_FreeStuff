-- =============================================================
-- dbmgr.lua 
-- Database Manager
-- =============================================================
-- Last Modified: 27 APR 2014
-- =============================================================

require "sqlite3"

local path
local db

local function initDB( dbpath )
	print("\n**** DBMGR: initDB() -> " .. dbpath .. "\n")
	print( "version " .. sqlite3.version() )
	path = system.pathForFile(dbpath)
	db = sqlite3.open( path ) 
	print("\n**** DBMGR: initDB() - Completed")
end

local function isWordInDB( word )
	local foundCount = 0
	word = string.lower(word)
	
	--local cmd = "SELECT * FROM theWords where field1='" .. word .. "'"
	local cmd = "SELECT * FROM theWords WHERE field1 LIKE '" .. word .. "'"

	--print("CMD ==" .. cmd)
	--print( db:nrows("SELECT * FROM words where field1='" .. word .. "'")  )

	for row in db:nrows(cmd) do
		foundCount = foundCount + 1
	end
	--print( foundCount )

	if( foundCount > 0 ) then
		return true
	end
	return false

end

local function findWordInDB( word )
	word = string.lower(word)
	local foundCount = 0
	--local cmd = "SELECT * FROM theWords where field1='" .. word .. "'"
	local cmd = "SELECT * FROM theWords WHERE field1 LIKE '" .. word .. "'"

	for row in db:nrows(cmd) do
		foundCount = foundCount + 1
	end
	--print( word .. " " .. foundCount )
	return foundCount
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
	--print( startTime )
	for i=0, iterations do
		findWordInDB( testwords[mRandom(0, 9)] )
		--isWordInDB( testwords[mRandom(0, 9)] )
		--findWordInDB( testwords[iterations%10] )
	end
	local endTime = system.getTimer()
	--print( endTime )

	local result = "Did " .. iterations .. " searches in " .. endTime - startTime .. " ms"
	print(result)

	--local t = display.newText(result, 10, 140, null, 24)
	--t.anchorX = 0
	--t:setFillColor(1,0,0)
end

local public = {}

public.initDB			= initDB
public.isWordInDB 		= isWordInDB
public.findWordInDB 	= findWordInDB
public.test 		 	= testSearchSpeed

return public