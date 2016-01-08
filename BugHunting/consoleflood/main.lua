
-- These are included to provide recursive table printer: table.print_r()
--
require("ssk_core.extensions.string")
require("ssk_core.extensions.table")

--
-- Code to demo console flooding issue
--
io.output():setvbuf("no") 
--io.output():setvbuf("line") 
--io.output():setvbuf("full") 

local function onAxis( event )
   table.print_r(event)
end
Runtime:addEventListener( "axis", onAxis )

local function enterFrame()
   print( system.getTimer() )
end
Runtime:addEventListener( "enterFrame", enterFrame )