io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local tmp = display.newImageRect( "back.png", 720, 1386 )
tmp:setFillColor(0,1,1)
tmp.x = display.contentCenterX
tmp.y = display.contentCenterY