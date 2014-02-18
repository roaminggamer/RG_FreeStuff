-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- main.lua
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
--
-- =============================================================

print("\n\n\n****************************************************************")
print("*********************** \\/\\/ main.cs \\/\\/ **********************")
print("****************************************************************\n\n")

----------------------------------------------------------------------
--	1.							GLOBALS								--
----------------------------------------------------------------------
local globals = require( "ssk.globals" ) -- Load Standard Globals
local globals = require( "data.globals" ) -- Load Standard Globals

----------------------------------------------------------------------
-- 2. LOAD MODULES													--
----------------------------------------------------------------------
local storyboard = require "storyboard"
local physics = require("physics")

require("ssk.loadSSK")

sampleManager = require("sampleMgr")

----------------------------------------------------------------------
-- 3. REGISTER SAMPLES												 -
----------------------------------------------------------------------
require( "registerSamples" ) 

----------------------------------------------------------------------
-- 4. ONE-TIME INITIALIZATION										--
----------------------------------------------------------------------
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)
system.activate("multitouch")

physics.start()
--physics.setGravity(0,9.8)
--physics.setDrawMode( "hybrid" )

system.setTapDelay(0.5)

gameFont = native.systemFont -- "Abscissa"
helpFont = native.systemFont -- "Courier New"

-- Load Presets (after setting gameFont and helpFont)
require("data.rg_basicButtons.presets")
require("data.rg_basicLabels.presets")
require("data.rg_bluegelButtons.presets")
require("data.rg_basicSounds.presets")

----------------------------------------------------------------------
-- 5. PRINT USEFUL DEBUG INFORMATION (BEFORE STARTING APP)			--
----------------------------------------------------------------------
ssk.debug.dumpScreenMetrics()
--ssk.debug.dumpFonts()
--ssk.debug.printLuaVersion()
--ssk.debug.monitorMem()

print("\n****************************************************************")
print("*********************** /\\/\\ main.cs /\\/\\ **********************")
print("****************************************************************")
----------------------------------------------------------------------
--								LOAD FIRST SCENE					--
----------------------------------------------------------------------
storyboard.gotoScene( "s_MainMenu" )
--]]