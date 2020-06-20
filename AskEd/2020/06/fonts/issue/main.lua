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
local tmp = display.newText( "PTSerif-Bold.ttf  Example", cx, cy - 25, "PTSerif-Bold.ttf", 32 )
local tmp = display.newText( "PTSerif-Italic.ttf  Example", cx, cy + 25, "PTSerif-Italic.ttf", 32 )
local tmp = display.newText( "PTSerif-BoldItalic.ttf  Example", cx, cy + 75, "PTSerif-BoldItalic.ttf", 32 )
