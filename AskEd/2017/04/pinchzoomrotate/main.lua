require "ssk2.loadSSK"
_G.ssk.init()

system.activate("multitouch")

local obj = ssk.display.newImageRect( nil, centerX, centerY, "ssk2.jpg", { w = 730, h = 300 })

obj.touch = ssk.easyIFC.pinchZoomDragTouch 

obj:addEventListener("touch")
