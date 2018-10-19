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

-- Locals
local objects = {}

local function show()
	for k,v in pairs( objects ) do
		v.alpha = 1
	end
end

local function hide()
	for k,v in pairs( objects ) do
		v.alpha = 0
	end
end


widget.newButton(
{
	label 		= "Show",
	x 				= cx - 100, 
	y 				= cy + 100,
   font 			= native.systemFontBold,
   fontSize 	= 20,
	labelColor 	= { default = { 1,1,1}, over = { 1, 0, 0 } },
	onPress 		= show
} )

widget.newButton(
{
	label 		= "Hide",
	x 				= cx + 100, 
	y 				= cy + 100,
   font 			= native.systemFontBold,
   fontSize 	= 20,
	labelColor 	= { default = { 1,1,1}, over = { 1, 0, 0 } },
	onPress 		= hide
} )


for i = 1, 5 do
	local tmp = display.newImageRect( "rg256.png", 72, 72 )
	tmp.x = cx - (5 * 80)/2 - 40 + i * 80
	tmp.y = cy
	objects[tmp] = tmp
end





