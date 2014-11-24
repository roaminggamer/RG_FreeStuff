-- =============================================================
-- Gotcha #2 - Mixed index tables (key-value pair + numberic index)
-- =============================================================
local tlib = require "tlib"
local tlib2 = require "tlib2"


local myTable

local function init()
	myTable = {}

	myTable[1] 		= "This"
	myTable[2] 		= "table"
	myTable[3] 		= "mixes"
	myTable[4] 		= "index"
	myTable[5] 		= "types."
	
	myTable.value  	= "This is a key-value pair entry."
	
end

local function test()
	for i = 1, #myTable do
		print(myTable[i])
	end
end

local function test2()
	tlib2.dump( myTable )
end

local function test3()
	tlib2.repairIndicies( myTable )

	for i = 1, #myTable do
		print(myTable[i])
	end
	print(myTable.value)	

	tlib2.dump( myTable )
end


local function save( filename )
	print("Saving table to file: ", filename)
	tlib.save( myTable, filename )
	print("\n")
end

local function load( filename )
	print("Loading table from file: ", filename)
	myTable = tlib.load( filename )
	print("\n")
end



local public = {}
public.init 	= init 
public.test 	= test
public.test2 	= test2
public.test3 	= test3
public.save		= save
public.load		= load
return public
