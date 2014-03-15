print( "main.lua ***************** ENTER ")
-- ============================================================
local storyboard = require "storyboard"

-- A small set of my SSK stuff, you can ignore this 
-- other than to understand that the following requires
-- provide functionality I am using in this sample, such as:
--
-- table.print_r
--
require "ssk.variables"
require "ssk.functions"
require "ssk.string"
require "ssk.table"
-- ============================================================

-- Storyboard data-passing  begins below...

-- ============================================================

local myTable = { 
					{ "Bob", "is", "your", "uncle" },
                 	{ "Corona", "Rocks!"},
                 	{ "Roaming Gamer", "ain't to bad", "either"}
                }

print( "\n\nDump of myTable in main.lua - Notice 'addresses' of sub-tables:")
table.dump( myTable )

print( "\n\nRecursiuve print of myTable in main.lua:")
table.print_r( myTable )

local options =
{
	effect = "fade",
	time = 200,
	params =
	{
		dataSource = myTable
	}
}

print( "main.lua ***************** EXIT ")
storyboard.gotoScene( "aScene", options  )	
