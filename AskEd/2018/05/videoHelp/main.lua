io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2

local options = { hasBackground=false, baseUrl=system.ResourceDirectory, urlRequest=listener }
native.showWebPopup( left, top, fullw, fullh, "localpage.html", options )


-- =====================================================
-- =====================================================



