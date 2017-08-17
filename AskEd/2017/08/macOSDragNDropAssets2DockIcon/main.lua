-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
--require "ssk2.loadSSK"
--_G.ssk.init()
-- =============================================================
local function onSystemEvent( event )
	--table.dump(event)
	for k,v in pairs(event) do
		print(k,v)
	end
	if ( event.type == "applicationOpen" and event.url ) then
		local filename = event.url
		print( "Event: applicationOpen - filename: ", filename )
	end
end 
Runtime:addEventListener( "system", onSystemEvent )