-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Behaviors Manager
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

--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

local intTable = {}
local floatTable = {}

local prep_numberTables
local cleanup_numberTables
local generate_intTable
local generate_floatTable

prep_numberTables = function()
	if( io.exists( "intTable.txt", system.DocumentsDirectory ) )then
		dprint(2,"intTable.txt Does exist")
		intTable = table.load( "intTable.txt", system.DocumentsDirectory )
	else
		dprint(2,"intTable.txt Does not exist")
		generate_intTable(5000, -1024, 1024)
	end

	if( io.exists( "floatTable.txt", system.DocumentsDirectory ) )then
		dprint(2,"floatTable.txt Does exist")
		floatTable = table.load( "floatTable.txt", system.DocumentsDirectory )
	else
		dprint(2,"floatTable.txt Does not exist")
		generate_floatTable(5000, -1024, 1024)
	end

--[[
	for k,v in ipairs(intTable) do
		print(v)
	end
	for k,v in ipairs(floatTable) do
		print(v)
	end
--]]
end

cleanup_numberTables = function()
	table.save( intTable, "intTable.txt", system.DocumentsDirectory )
	intTable={}
	table.save( floatTable, "floatTable.txt", system.DocumentsDirectory )
	floatTable={}
end

generate_intTable = function( size, min, max )
	intTable = {}
	for i = 1, size do
		intTable[i] = math.random( min, max )
	end
end

generate_floatTable = function( size, min, max )
	floatTable = {}
	for i = 1, size do
		floatTable[i] = math.random( min * 100, max * 100 ) / 100
	end
end


benchmarkManager = {}

benchmarkManager.prep_numberTables		= prep_numberTables
benchmarkManager.cleanup_numberTables	= cleanup_numberTables
benchmarkManager.generate_intTable		= generate_intTable
benchmarkManager.generate_floatTable	= generate_floatTable

return benchmarkManager