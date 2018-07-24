io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
ssk.meters.create_fps(true)
ssk.meters.create_mem(true)



local physics = require "physics"
physics.start()

local rect = ssk.display.newRect(nil, centerX, centerY+100, { w = 200, h = 40}, {bodyType="static"} )
local ball = ssk.display.newCircle( nil, centerX, centerY-100, { radius = 10 }, { radius = 10, bounce = 1 } )