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
if( system.getInfo( "environment" ) == "simulator" ) then
	local function myUnhandledErrorListener( event )
		return true
	end
	Runtime:addEventListener("unhandledError", myUnhandledErrorListener)
end

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
-- Load SSK Globals & Libraries
--
require "ssk.globals"
require "ssk.loadSSK"

-- Load Button, Label, and Sound Presets
--
--require "data.rg_blueGelOverrideButtons.presets"  -- UNCOMMENT THIS LINE TO OVERRIDE DEFAULTS

-- Read in the 'build.settings' copy
require("build_settings")
--table.print_r(build_settings)

_G.ifc_Splash   = require "modules.ifc_Splash"
_G.ifc_MainMenu = require "modules.ifc_MainMenu"
_G.ifc_Options  = require "modules.ifc_Options"
_G.ifc_Credits  = require "modules.ifc_Credits"
_G.ifc_PlayGUI  = require "modules.ifc_PlayGUI"

require( "sounds.sounds" )


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------

io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

ssk.gem:post(  "EFFECTS_VOLUME_CHANGE" ) -- Fake volume change to update the effects volume
ssk.gem:post(  "MUSIC_VOLUME_CHANGE" )   -- Fake volume change to update the sound volume and start the soundtrack if neccesary

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
ifc_Splash.create()

--ifc_MainMenu.create()
--ifc_Options.create()
--ifc_Credits.create()
--ifc_PlayGUI.create()


