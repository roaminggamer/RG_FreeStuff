-- =============================================================
-- main.lua
-- =============================================================
-- Register a dummy handler to ignore unhandled errors (if this is not here, the game will pop up a dialog).
local function myUnhandledErrorListener( event )
	return true
end
Runtime:addEventListener("unhandledError", myUnhandledErrorListener)

require "globals"

local storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true -- Always purge on scene change





--storyboard.gotoScene( "test2" )
storyboard.gotoScene( "mainMenu" )