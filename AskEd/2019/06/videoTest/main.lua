-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages
math.randomseed( os.time() )
require "ssk.loadSSK"  -- Load a minimized version of the SSK library (just the bits we'll use)
-- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE 
-- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE 
-- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE -- IGNORE ABOVE 
--_G.gameFont = "Bitblox Embiggened"

local options = { hasBackground=false, baseUrl=system.ResourceDirectory, urlRequest=listener }
native.showWebPopup( left, top, fullw, fullh, "localpage.html", options )
