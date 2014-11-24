-- =============================================================
-- Gotcha #1 - Numerically Indexed Tables w/ Gaps
--
--  No longer a problem.  Was it ever?
--
-- =============================================================
local tlib = require "tlib"
local tlib2 = require "tlib2"


local myTable

local function init()
	myTable = {}

	myTable[1] = "The next"
	myTable[2] = "entry is"
	myTable[3] = "followed by"
	myTable[4] = "a gap."
	--myTable[5] 
	myTable[6] = "Can reach this entry in indexed loop?"
end

local function test()
	for i = 1, #myTable do
		print(myTable[i])
	end
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
public.save		= save
public.load		= load
return public
