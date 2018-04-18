io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
display.setDefault( "background", 1, 0, 1 )
--
local g = display.newGroup()
--
local r0 = display.newRect( g, 0, 0, 640, 960 )
r0:setFillColor(0.125,0.125,0.125)
r0.anchorX = 0
r0.anchorY = 0
--
local r1 = display.newRect( g, 0, 0, 200, 10 )
r1:setFillColor(1,0,0)
r1.anchorX = 0
r1.anchorY = 0
--
local r2 = display.newRect( g, 0, 0, 10, 200 )
r2:setFillColor(0,1,0)
r2.anchorX = 0
r2.anchorY = 0
