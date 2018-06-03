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
-- == Uncomment following lines if you need  physics
--local physics = require "physics"
--physics.start()
--physics.setGravity(0,10)
--physics.setDrawMode("hybrid")

-- == Uncomment following line if you need widget library
--local widget = require "widget"

-- =====================================================
-- YOUR CODE BELOW
-- =====================================================

--
-- Tip: Try changing simulated device and/or portrait/landscape selection 
--      in build.settings to see who how this image is displayed.
--
--      It represents the safe/unsafe spaces for the settings in
--      config.lua.
--      Checkbox area - visible on all screens.
--      Black outer fringe - visible on some screens.
--
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end


-- 
-- REMEMBER: IN YOUR POST, TELL US:
-- > Corona Version You Are Using. Ex: 2018.2338
-- > OS You are building on: OS X 10.?? or Windows (7/8/10)
-- > Target Device(s) You Are Testing On 
-- > Target OS Version

-- PUT YOUR SHORT SAMPLE DEMONSTRATING THE PROBLEM HERE

-- =====================================================
-- YOUR CODE ABOVE
-- =====================================================


