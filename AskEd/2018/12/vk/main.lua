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
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================


local loadingText = display.newText( "Loading...", display.contentCenterX, display.contentCenterY, nil, 20)
 
local vk = require("plugin_vk_direct")
 
local function vkListener( event )
    if event.method == "init" then
        if event.status == "success" then
            composer.gotoScene( "menu" )
            loadingText:removeSelf( )
        else
            loadingText.text = "VK Initialization error"
        end
    end
end
 
vk.init(vkListener)