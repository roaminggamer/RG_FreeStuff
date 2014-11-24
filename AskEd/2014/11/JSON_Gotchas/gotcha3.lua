-- =============================================================
-- Gotcha #3 - Saving and Restoring table 'objects' (not display objects)
-- =============================================================
local tlib = require "tlib"
local tlib2 = require "tlib2"

local function dump( self )
	print( self.name )
	print( self.description)
end

local myTable

local function init()
	myTable = {}

	myTable["name"]		= "Gotcha 3"
	myTable.description = "This table has fields and functions attached to it."

	myTable.dump 		= dump
end

local function test()
	myTable:dump()
end

local function test2()
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

local function save2( filename )
	print("Saving table to file: ", filename)
	tlib2.save( myTable, filename )
	print("\n")
end

local function load2( filename )
	print("Loading table from file: ", filename)
	myTable = tlib2.load( filename )

	-- Re-attach dump function
	myTable.dump = dump
	print("\n")
end


local public = {}
public.init 	= init 
public.test 	= test
public.test2 	= test2

public.save		= save
public.load		= load

public.save2	= save2
public.load2	= load2

return public
