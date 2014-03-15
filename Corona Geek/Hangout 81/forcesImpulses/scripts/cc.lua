require "ssk.RGCC"

local myCC = ssk.ccmgr:newCalculator()

myCC:addNames( "pad", "shipyang", "marker" )

myCC:collidesWith( "shipyang", "pad" )


myCC:dump()

return myCC