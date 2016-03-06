-- =============================================================
-- Don't Write It Yourself If You Can Avoid It!
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

-- SSK Core Globals and Extensions
require("ssk_core.globals.variables")
require("ssk_core.globals.functions")
require("ssk_core.extensions.display")
require("ssk_core.extensions.io")
require("ssk_core.extensions.math")
require("ssk_core.extensions.string")
require("ssk_core.extensions.table")
require("ssk_core.extensions.transition_color")


io.writeFile( 10, "myNumber.txt" )

local tmp = tonumber( io.readFile( "myNumber.txt") )
print( tmp )
tmp = tmp + 10
io.writeFile( tmp, "myNumber.txt" )

local tmp = tonumber( io.readFile( "myNumber.txt") )
print( tmp )
tmp = tmp + 10
io.writeFile( tmp, "myNumber.txt" )


local tmp = tonumber( io.readFile( "myNumber.txt") )
print( tmp )
tmp = tmp + 10
io.writeFile( tmp, "myNumber.txt" )

local tmp = tonumber( io.readFile( "myNumber.txt") )
print( tmp )
