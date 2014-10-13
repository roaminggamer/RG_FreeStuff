-- =============================================================
-- main.lua
-- =============================================================
_G.oniOS = ( system.getInfo("platformName") == "iPhone OS") 
_G.onAndroid = ( system.getInfo("platformName") == "Android") 
_G.onOSX = ( system.getInfo("platformName") == "Mac OS X")
_G.onWin = ( system.getInfo("platformName") == "Win")
----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
require "ssk.loadSSK"

----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
system.activate("multitouch")

-- If you have RG METER, add it to the project and uncomment the following section
--[[
local rgmeter = require "rgmeter.rgmeter"
rgmeter.setMaxMainMem( 2 * 1024 ) -- 16K KB == 16 MB 
rgmeter.setMaxVidMem( 32 * 1024 ) -- 16K KB == 16 MB 
rgmeter.create( centerX, centerY, 320, nil, true ) -- Last arg tell it to start 'minimized'
rgmeter.enableCollection( true )
--]]

----------------------------------------------------------------------
-- 3. Declarations
----------------------------------------------------------------------

----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------
_G.numTextures = 1000 -- Warning!!: Setting to 1000 generates ~= 100 MB of textures

----------------------------------------------------------------------
-- 5. Execution
----------------------------------------------------------------------

-- 1. Load init.lua and let it create textures if they were not already created.
--
require "init"


-- 2. Run example1.lua to see bad texture management 
--
--    -- OR -- 
-- Run example2.lua (or) example3.lua to see good texture management.
--
-- ONLY REQUIRE example1 -OR- example2 -OR- example3

--require "example1"
--require "example2"
--require "example3"



