--------------------------------------------------------------------------------
-- main.lua
--------------------------------------------------------------------------------

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

local sampleName = samples[math.random(#samples)]

require("samples." .. sampleName:gsub("/", "."))

local t = display.newText({
	text = "Sample: " .. sampleName,
	font = "CourierNewPSMT",
	fontSize = 30
})
t.x, t.y = display.contentCenterX, t.height * 0.5 + 10