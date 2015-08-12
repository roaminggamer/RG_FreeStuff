-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- (Rudimentary) Database Manager Factory
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================

local sqlite3 = require "sqlite3"

local dbmgr

if( not _G.ssk.dbmgr ) then
	_G.ssk.dbmgr = {}
end

dbmgr = _G.ssk.dbmgr

-- ==
--    func() - what it does
-- ==
function dbmgr:newDB( dbpath )
	print("\n**** dbmgr: initDB() -> " .. dbpath .. "\n")
	print( "version " .. sqlite3.version() )
	self.path = system.pathForFile(dbpath)
	self.db = sqlite3.open( path ) 

	-- ==
	--    func() - what it does
	-- ==
	function db:isWordInDB( word )
		local foundCount = 0
		word = string.lower(word)
	
		--local cmd = "SELECT * FROM theWords where field1='" .. word .. "'"
		local cmd = "SELECT * FROM theWords WHERE field1 LIKE '" .. word .. "'"

		print("CMD ==" .. cmd)
		--print( self:nrows("SELECT * FROM words where field1='" .. word .. "'")  )

		for row in self:nrows(cmd) do
			foundCount = foundCount + 1
		end
		print( foundCount )

		if( foundCount > 0 ) then
			return true
		end
		return false
	end

	-- ==
	--    func() - what it does
	-- ==
	function db:findWordInDB( word )
		word = string.lower(word)
		local foundCount = 0
		--local cmd = "SELECT * FROM theWords where field1='" .. word .. "'"
		local cmd = "SELECT * FROM theWords WHERE field1 LIKE '" .. word .. "'"

		for row in self:nrows(cmd) do
			foundCount = foundCount + 1
		end
		print( word .. " " .. foundCount )
		return foundCount
	end

	-- ==
	--    func() - what it does
	-- ==
	function db:testSearchSpeed( iterations )
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
		print( startTime )
		for i=0, iterations do
			self:findWordInDB( testwords[math.random (0, 9)] )
		end
		local endTime = system.getTimer()
		print( endTime )

		local result = "Did " .. iterations .. " searches in " .. endTime - startTime .. " ms"
		print(result)

		local t = display.newText(result, 20, 30, null, 32)
		t:setTextColor(255,0,0)

	end
end
