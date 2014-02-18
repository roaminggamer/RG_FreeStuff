-- =============================================================
-- main.lua
-- =============================================================
-- Empty Project Using SSKCorona Library
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
-- Load SSK Globals & Libraries
--
require "ssk.globals"
require "ssk.loadSSK"

require "data.rg_bluegelButtons.presets"


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

local physics = require("physics")
physics.start()
physics.setGravity(0,10)
--physics.setDrawMode( "hybrid" )


----------------------------------------------------------------------
-- 3. Declarations
----------------------------------------------------------------------
-- Additional Globls, Locals, and Function Forward Declartions


----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------
-- Local and Global Function Implementations

----------------------------------------------------------------------
-- 5. Execution
----------------------------------------------------------------------
local samples_pure = {}
samples_pure[1] = { "samples.pure.001", "Basic Display Objects", 13 }
samples_pure[2] = { "samples.pure.002", "Fill and Stroke", 26 }
samples_pure[3] = { "samples.pure.003", "Basic Text", 6 }
samples_pure[4] = { "samples.pure.004", "Colorized Text", 12 }
samples_pure[5] = { "samples.pure.005", "Lines", 3 }
samples_pure[6] = { "samples.pure.006", "Lines: Color and Width", 6 }
--
samples_pure[11] = { "samples.pure.011", "Push Buttons", '63 (69)' }
--
samples_pure[15] = { "samples.pure.015", "Layers (Display Groups)", 7 }
samples_pure[16] = { "samples.pure.016", "Physics: Simple Dynamic Bodies", 2 }
samples_pure[17] = { "samples.pure.017", "Physics: Collision Filters", 'Hand Calculated' }

--samples_pure[000] = { "samples.pure.000", "TEMPLATE", 0 }

local samples_ssk = {}
samples_ssk[1] = { "samples.ssk.001", "Basic Display Objects", 5 }
samples_ssk[2] = { "samples.ssk.002", "Fill and Stroke", 5 }
samples_ssk[3] = { "samples.ssk.003", "Basic Text", 2 }
samples_ssk[4] = { "samples.ssk.004", "Colorized Text", 2 }
samples_ssk[5] = { "samples.ssk.005", "Lines", 3 }
samples_ssk[6] = { "samples.ssk.006", "Lines: Color and Width", 3 }
samples_ssk[7] = { "samples.ssk.007", "Fancy Lines", '5 (21)' }
samples_ssk[8] = { "samples.ssk.008", "Arrows and Arrowheads", '6' }
samples_ssk[9] = { "samples.ssk.009", "More Fancy Lines", '8' }
samples_ssk[10] ={ "samples.ssk.010", "Text Varitions", '9' }
samples_ssk[11] = { "samples.ssk.011", "Push Buttons", ' 3 (9)' }
samples_ssk[12] = { "samples.ssk.012", "Toggle Buttons", '3 (13)' }
samples_ssk[13] = { "samples.ssk.013", "Radio Buttons", '3 (13)' }
samples_ssk[14] = { "samples.ssk.014", "Push Buttons (Arcade Pack)", 7 }
samples_ssk[15] = { "samples.ssk.015", "Layers (Display Groups)", 1 }
samples_ssk[16] = { "samples.ssk.016", "Physics: Simple Dynamic Bodies", 1 }
samples_ssk[17] = { "samples.ssk.017", "Physics: Collision Filters", '3 lines of code' }
samples_ssk[18] = { "samples.ssk.018", "Joystick: Basic", 28 }
samples_ssk[19] = { "samples.ssk.019", "Joystick: Nicer", 28 }

--samples_ssk[000] = { "samples.ssk.000", "TEMPLATE", 0 }

local function showSamples( num )

	if(samples_pure[num]) then
		local pureSample = require( samples_pure[num][1] )
		local sskSample = require( samples_ssk[num][1] )

		local pureName = samples_pure[num][2]
		local sskName = samples_ssk[num][2]

		local pureLines = samples_pure[num][3]
		local sskLines = samples_ssk[num][3]

		pureSample.y = pureSample.y - h/4
		sskSample.y = sskSample.y + h/4

		 local tmp = display.newText("#" .. num .. " Pure - " .. pureName .. "; " .. pureLines, 10, 5, native.systemFont, 18)
		 local tmp = display.newText("#" .. num .. " SSK - " .. sskName .. "; " .. sskLines, 10, h/2 + 5, native.systemFont, 18)
		 
		 local tmp = display.newLine(0,h/2, w, h/2)
		 tmp.width = 6
		 
		 local tmp = display.newLine(0,h/2, w, h/2)
		 tmp:setColor(0,0,0)
		 tmp.width = 2
	else
		local sskSample = require( samples_ssk[num][1] )
		local sskName = samples_ssk[num][2]
		local sskLines = samples_ssk[num][3]

		local tmp = display.newText("#" .. num .. " SSK (only) - " .. sskName .. "; " .. sskLines, 10, 5, native.systemFont, 18)
	end 
end


local layers = ssk.display.quickLayers( nil, "back", "buttons", "buttons2" )

local back = ssk.display.imageRect( layers.back, centerX, centerY, "images/interface/backImage.jpg", { w = 380, h = 570, rotation = 90 } )

local curExampleLabel = display.newText(layers.back, "Current Example", 0, 0, native.systemFont, 24)
curExampleLabel:setTextColor( 0 )
curExampleLabel.x = centerX
curExampleLabel.y = 40


local curX = 0
local curY = 0

local curExample = 1

local function onPush( event )
	curExample = event.target.myNum
	curExampleLabel.text = samples_ssk[curExample][2]
	return true	
end

for i = 1, #samples_ssk do
	local tmp = ssk.buttons:presetRadio( layers.buttons, "bluegelcheck", curX, curY, 40, 40, i, onPush )
	tmp.myNum = i
	curX = curX + 45

	if( i % 5 == 0 ) then
		curX = 0
		curY = curY + 45		
	end

	if(i == 1) then tmp:toggle() end

end

layers.buttons:setReferencePoint( display.CenterReferencePoint )
layers.buttons.x = centerX
layers.buttons.y = centerY

local function onGo( event )
	layers.isVisible = false
	showSamples( curExample )
end

local tmp = ssk.buttons:presetPush( layers.buttons2, "bluegelcheck", w - 40, h - 40, 60, 60, "Go!", onGo )

