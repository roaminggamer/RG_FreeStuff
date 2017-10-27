-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { useExternal = true } )
-- =============================================================
ssk.meters.create_fps(true)
ssk.meters.create_mem(true)
-- =============================================================

local widget = require "widget"
local chatScroll = widget.newScrollView
{
	width  = display.actualContentWidth,
	height = display.actualContentHeight,
	hideBackground = true,
	horizontalScrollDisabled  = true,
}
chatScroll.x = display.contentCenterX
chatScroll.y = display.contentCenterY

for i = 1, 100 do
	local  myText = display.newText( "yuuu", 100, i * 50 ,"Lato-Black.ttf", 35 )
	myText:setFillColor(1,1,1)
	myText:toFront();
	chatScroll:insert(myText)
end
