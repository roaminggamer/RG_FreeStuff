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
-- =====================================================

local tmp = display.newImageRect( "rg256.png", 256, 256 )
tmp.x = cx
tmp.y = cy - 20
tmp.xScale = 0.5
tmp.yScale = 0.05

local tmp = display.newImageRect( "corona256.png", 256, 256 )
tmp.x = cx
tmp.y = cy + 20
tmp:scale( 0.5, 0.05 )
