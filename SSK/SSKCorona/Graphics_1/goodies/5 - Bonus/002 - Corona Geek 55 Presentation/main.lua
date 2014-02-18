-- =============================================================
-- main.lua
-- =============================================================
-- Sans Interfaces - i.e. Without a framework.
-- =============================================================
--
-- Register a dummy handler 'FIRST' if we are using the simulator
--
-- Tip: If you don't do this early, you'll get pop-ups in the simulator (and on devices)
--      This is great for device debugging, but I personally prefer the console output
--      when using the console
--
--[[
if( system.getInfo( "environment" ) == "simulator" ) then
	local function myUnhandledErrorListener( event )
		return true
	end
	Runtime:addEventListener("unhandledError", myUnhandledErrorListener)
end
--]]

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
local storyboard = require "storyboard"

-- Load SSK Globals & Libraries
--
require "ssk.globals"
require "ssk.loadSSK"

_G.gameFont = "Consolas" -- "Courier New" -- "Impact"

-- Load Button, Label, and Sound Presets
--
require "data.rg_blueGelOverrideButtons.presets"  -- UNCOMMENT THIS LINE TO OVERRIDE DEFAULTS

-- Read in the 'build.settings' copy
require("build_settings")
--table.print_r(build_settings)

--require( "sounds.sounds" )


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------

io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

-- Load the saved 'options' table if it exists, otherwise create one.
if( io.exists( "options.txt", system.DocumentsDirectory ) ) then
	print("Loading OPTIONS file" )
	_G.options  = table.load( "options.txt" )
end

if( not options ) then
	print("Creating OPTIONS file" )
	_G.options = 
		{ 
		   effectsVolume = 0.25, 
		   musicVolume = 0.25, 
		   difficulty = "Normal",
		   debugEn = true,
   	   }
	table.save( options, "options.txt" )		
end

--ssk.gem:post(  "EFFECTS_VOLUME_CHANGE" ) -- Fake volume change to update the effects volume
--ssk.gem:post(  "MUSIC_VOLUME_CHANGE" )   -- Fake volume change to update the sound volume and start the soundtrack if neccesary

----------------------------------------------------------------------
-- 3. Declarations
----------------------------------------------------------------------
-- Additional Globls
_G.sceneCrossFadeTime = 300


----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------


----------------------------------------------------------------------
-- 5. Execution
----------------------------------------------------------------------

--storyboard.gotoScene( "s_Globals" )
--storyboard.gotoScene( "s_Extensions" )
--storyboard.gotoScene( "s_Goodies" )
--storyboard.gotoScene( "s_Classes3" )


--storyboard.gotoScene( "s_SplashLoading" )
storyboard.gotoScene( "s_MainMenu" )
--storyboard.gotoScene( "s_Credits" )
--storyboard.gotoScene( "s_PlayGUI" )
