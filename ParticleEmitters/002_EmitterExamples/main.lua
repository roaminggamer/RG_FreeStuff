io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

local loader = require("brent.loader")


--local particleData = pex.load("emitters/fire.pex","emitters/fire.png")
--local particleData = pex.load("emitters/jellyfish.pex","emitters/jellyfish.png")
--local particleData = pex.load("em--itters/particle.pex","emitters/particle.png")

local emitter = loader.newEmitter( "emitters/waterfall.rg", "emitters/particle.png")
emitter.x = 100
emitter.y = 10

local emitter = loader.newEmitter( "emitters/campfire.rg", "emitters/particle.png")
emitter.x = 380
emitter.y = 310

local mRand = math.random
timer.performWithDelay( 500, 
	function()
		local emitter = loader.newEmitter( "emitters/explosion.rg", "emitters/particle.png")
		emitter.x = mRand( 50, 430 )
		emitter.y = mRand( 50, 270 )
	end, -1 )
