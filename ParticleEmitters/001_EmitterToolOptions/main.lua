-- Notice: This sample uses the free loader found here: https://github.com/ponywolf/pex4corona
--

io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

local pex = require("ponywolf.pex")


--local particleData = pex.load("emitters/fire.pex","emitters/fire.png")
--local particleData = pex.load("emitters/jellyfish.pex","emitters/jellyfish.png")
local particleData = pex.load("emitters/particle.pex","emitters/texture.png")

emitter = display.newEmitter(particleData)
emitter.x = display.contentCenterX
emitter.y = display.contentCenterY + 100
