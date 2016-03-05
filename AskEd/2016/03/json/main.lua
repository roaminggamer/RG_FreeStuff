-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  main.lua
-- =============================================================

io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

-- Include SSK Core (Features I just can't live without.)
require("ssk_core.globals.variables")
require("ssk_core.globals.functions")
require("ssk_core.extensions.display")
require("ssk_core.extensions.io")
require("ssk_core.extensions.math")
require("ssk_core.extensions.string")
require("ssk_core.extensions.table")
require("ssk_core.extensions.transition_color")



local mydata = { 1, 2, 3, 4 }

table.save( mydata, "mydata.json" )

local mydata2 = table.load( "mydata.json" )

for i = 1, #mydata do
	if( mydata[i] == mydata2[i] ) then
		print(i, " matched" )
	else
		print(i, " different", mydata[i], mydata2[i] )
	end
end