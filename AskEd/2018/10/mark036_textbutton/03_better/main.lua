io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
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
-- Example
-- =====================================================
local widget = require "widget"


widget.newButton(
{
	label 		= "Just A Button",
	x 				= cx, 
	y 				= cy,
   font 			= native.systemFontBold,
   fontSize 	= 20,
   shape       = "rect",
   width 		= 200,
   height 		= 40,
   fillColor   = { default = { 0.25, 0.25, 0.25, 1  }, over = { 0.5, 0.5, 0.5, 1 } },
	labelColor 	= { default = { 1,1,1}, over = { 1, 0, 0 } },
   strokeColor = { default = { 0, 0, 0, 1 }, over = { 1, 0, 0, 1 } },
	strokeWidth = 2
} )





