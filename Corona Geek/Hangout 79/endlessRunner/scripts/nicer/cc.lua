require "ssk.RGCC"

local myCC = ssk.ccmgr:newCalculator()

myCC:addNames( "building", 
	           "player", 
	           "foot", 
	           "spawnTrigger", 
	           "destroyTrigger", 
	           "gapTrigger", 
	           "parallax" )

myCC:collidesWith( "building", 
	               "player", "foot", "spawnTrigger", "destroyTrigger"  )

myCC:collidesWith( "gapTrigger", 
	               "destroyTrigger", "player"  )

myCC:collidesWith( "parallax", 
	               "spawnTrigger", "destroyTrigger"  )

myCC:dump()

return myCC