
local getTimer = system.getTimer

local sqlDB 		= require "sqlDB"
local tableDB 		= require "tableDB"

sqlDB.initDB( "words.db" )
tableDB.initDB( "words.tbl" )

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
