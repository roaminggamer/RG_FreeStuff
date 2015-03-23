--------------------------------------------------------------------------------
-- main.lua
--------------------------------------------------------------------------------
require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"

display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time())

--------------------------------------------------------------------------------
-- Create Sample Effect
--------------------------------------------------------------------------------
local CBE = require("CBEffects.Library")

local samplesFile = io.open(system.pathForFile("samples/SAMPLES.txt"), "r")
local samplesString = samplesFile:read("*a")
samplesFile:close()
local samples = {}
for s in samplesString:gmatch("(.-)\n") do samples[#samples + 1] = s end

local buttonGroup = display.newGroup()
local buttonHeight = 60
local function runSample( self, event ) 
	local sampleName = self.sampleName
	require("samples." .. sampleName:gsub("/", "."))

	local frame = display.newRect( display.contentCenterX, 30, display.contentWidth, 60)
	frame:setFillColor(0.2,0.2,0.2)
	local t = display.newText({
		text = "Sample: " .. sampleName,
		font = "CourierNewPSMT",
		fontSize = 30
	})
	t.x = display.contentCenterX
	t.y = t.height * 0.5 + 10

	frame.enterFrame = display.toFront
	t.enterFrame = display.toFront
	Runtime:addEventListener( "enterFrame", frame )
	Runtime:addEventListener( "enterFrame", t )

	display.remove( buttonGroup )
	return true
end

local x = display.contentWidth/4
local y = buttonHeight/2
local row = 0

for i = 1, #samples do	
	local tmp = PushButton( buttonGroup, x, y , samples[i], runSample, 
	                        { labelColor = {0,0,0}, labelSize = 28, 
	                          width = display.contentWidth/2 - 10, height = buttonHeight - 6 } )
	tmp.sampleName = samples[i]

	row = row + 1
	y = y + buttonHeight
	if( (y + buttonHeight/2 + 3) > display.contentHeight ) then
		print("BOB")
		x = 3 * display.contentWidth/4
	    y = buttonHeight/2
	    row = 0
	end

end