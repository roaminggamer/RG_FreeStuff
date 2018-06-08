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

-- =====================================================
-- START
-- =====================================================

ProFi = require 'ProFi'
ProFi:start()

----[[

local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end

--]]

ProFi:stop()
local filename = system.pathForFile( 'profilerReport.txt', system.DocumentsDirectory ) -- EFM
ProFi:writeReport( filename )

-- =====================================================
-- END
-- =====================================================


