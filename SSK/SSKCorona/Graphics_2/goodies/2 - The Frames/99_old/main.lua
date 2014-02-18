-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- main.lua
-- =============================================================
_G.releaseDate = "12 SEP 2013"
print("\n\n\n****************************************************************")
print("*********************** \\/\\/ main.cs \\/\\/ **********************")
print("****************************************************************\n\n")
io.output():setvbuf("no") -- Don't use buffer for console messages

----------------------------------------------------------------------
-- 1. LOAD MODULES													--
----------------------------------------------------------------------
local storyboard = require "storyboard"

-- SSKCorona Libraries
require("ssk.globals")
require("ssk.loadSSK")

--require "data.player"

-- PHYSICS (Configure in ssk.globals)
local physics = require("physics")
physics.start()
physics.setGravity( 9.8, 0 )
physics.setDrawMode( "hybrid" )

----------------------------------------------------------------------
-- 3. ONE-TIME INITIALIZATION										--
----------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)
system.activate("multitouch")

-- Configure Font(s)
if(onSimulator) then
	gameFont = native.systemFont -- "Abscissa"
	helpFont = native.systemFontBold -- "Courier New"
else
	gameFont = native.systemFont -- "Abscissa"
	helpFont = native.systemFontBold -- "Courier New"
end

----------------------------------------------------------------------
-- 8. DEBUG STUFF													--
----------------------------------------------------------------------
--ssk.debug.printLuaVersion()
--ssk.debug.dumpScreenMetrics()
--ssk.debug.dumpFonts()


print("\n****************************************************************")
print("*********************** /\\/\\ main.cs /\\/\\ **********************")
print("****************************************************************")
----------------------------------------------------------------------
--								LOAD FIRST SCENE					--
----------------------------------------------------------------------
storyboard.gotoScene( "s_SplashLoading" )
--storyboard.gotoScene( "s_MainMenu" )
--storyboard.gotoScene( "s_Credits" )
--storyboard.gotoScene( "s_PlayGUI" )