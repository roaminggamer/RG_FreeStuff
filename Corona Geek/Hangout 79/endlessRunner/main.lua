-- =============================================================
-- main.lua
-- =============================================================
require "ssk.RGGlobals"
require "ssk.RGExtensions"
require "ssk.RGCC"

io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar


local physics = require("physics")
physics.start()
--physics.setDrawMode( "hybrid" )

local nicerMode = false

if( nicerMode ) then

	require "scripts.nicer.cc"
	local level	= require "scripts.nicer.level"
	level.create( display.currentStage , 150, -10 )
else

	require "scripts.cc"
	local level	= require "scripts.level"
	
	-- Uncomment one line only to test different settings:
	--level.create( display.currentStage , 0 )
	--level.create( display.currentStage , 10, 80 )
	level.create( display.currentStage , 150, -10 )
	--level.create( display.currentStage , 150, -80 ) -- fails due to bug?

end
