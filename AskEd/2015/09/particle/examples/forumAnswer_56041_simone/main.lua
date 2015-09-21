-- ==
--		Particle Designer 2 Examples - Simone's Code
-- ==
local pex = require "pex"


local function firstRun()
	local emitter1 = pex.loadPD2( nil, display.contentCenterX, display.contentCenterY, 
							     "emitters/simone.json",
							      { texturePath = "emitters/" } )
end


local function secondRun()

	display.setDefault("background",1,1,1)

	local emitter1 = pex.loadPD2( nil, display.contentCenterX, display.contentCenterY, 
							     "emitters/simone.json",
							      { texturePath = "emitters/" } )
end

local function thirdRun()

	display.setDefault("background",1,1,1)
	
	local emitter1 = pex.loadPD2( nil, display.contentCenterX, display.contentCenterY, 
							     "emitters/simone2.json",
							      { texturePath = "emitters/" } )
end



local function fourthRun()

	display.setDefault("background",0,0,0)

	local emitter1 = pex.loadPD2( nil, display.contentCenterX, display.contentCenterY, 
							     "emitters/simone.json",
							      { texturePath = "emitters/" } )

	display.setDefault("background",1,1,1)
end

--firstRun()
--timer.performWithDelay( 2000, secondRun )
--timer.performWithDelay( 4000, thirdRun )

fourthRun()


