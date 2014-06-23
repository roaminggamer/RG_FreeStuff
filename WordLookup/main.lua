
local getTimer = system.getTimer

local sqlDB 		= require "sqlDB"
local tableDB 		= require "tableDB"

collectgarbage( "collect" )
local count1 = collectgarbage("count")
sqlDB.initDB( "words_81k.db" )
local count2 = collectgarbage("count")
tableDB.initDB( "words_81k.tbl" )
local count3 = collectgarbage("count")

print( " words_81k.db memory size => " .. count2 - count1 .. " KB")
print( "words_81k.tbl memory size => " .. count3 - count2 .. " KB")

local function runTest1()
	sqlDB.test(1000)
end

local function runTest2()
	tableDB.test(1000)
end

local function runTest3()
	tableDB.test(100000)
end

runTest1()
runTest2()
runTest3()

-- Uncomment following line to create table from "sourceList.txt" (saved in documents directory)
-- require "createTable.lua"

