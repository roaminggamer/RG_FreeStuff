io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init()
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================
-- Example Below
-- =====================================================

local wallM = require "wallM"
--
-- wallM.new( group, x, y, angle, length, fill )
--

local allowEndGap = false


-- Section 1
local parts,x,y
parts, x, y = wallM.new( nil, 50, 50, 180, 260, _Y_, allowEndGap )

-- Section 2
parts, x, y = wallM.new( nil, x, y, 135, 260, _C_, allowEndGap )

-- Section 3
parts, x, y = wallM.new( nil, x, y, 45, 130, _O_, allowEndGap )

-- Section 3
parts, x, y = wallM.new( nil, x, y, -45, 130, _PURPLE_, allowEndGap )

