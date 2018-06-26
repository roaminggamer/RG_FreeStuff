io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
-- =====================================================
-- EXAMPLE
-- =====================================================
system.activate( "multitouch" )

local pzd = require "pzd"

local charlie = display.newImageRect( "charlie.png", 696/2, 1024/2 )
charlie.x = display.contentCenterX
charlie.y = display.contentCenterY
charlie.touch = pzd
charlie:addEventListener("touch")

