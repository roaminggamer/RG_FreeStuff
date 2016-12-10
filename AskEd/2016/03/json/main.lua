-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  main.lua
-- =============================================================

io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            debugLevel 				= 0 } )

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