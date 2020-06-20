io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = cx
back.y = cy

--
-- Font Tests
--

local tmp = display.newText( "PTSerif-Regular.ttf  Example", cx, cy - 75, "PTSerif-Regular.ttf", 32 )
local tmp = display.newText( "PT Serif Bold.ttf  Example", cx, cy - 25, "PT Serif Bold.ttf", 32 )
local tmp = display.newText( "PT Serif Italic.ttf  Example", cx, cy + 25, "PT Serif Italic.ttf", 32 )
local tmp = display.newText( "PT Serif BoldItalic.ttf  Example", cx, cy + 75, "PT Serif Bold Italic.ttf", 32 )
