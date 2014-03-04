require "ssk.RGCC"

local myCC = ssk.ccmgr:newCalculator()

myCC:addNames( "building", "player", "foot", "spawnTrigger", "destroyTrigger", "gapTrigger" )

myCC:collidesWith( "building", "player", "foot", "spawnTrigger", "destroyTrigger"  )

myCC:collidesWith( "gapTrigger", "destroyTrigger", "player"  )

myCC:dump()

return myCC