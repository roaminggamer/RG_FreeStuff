io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

local widget = require( "widget" )
 
local scrollView
local icons = {}
 
local function iconListener( event )
    local id = event.target.id
 
    if ( event.phase == "moved" ) then
        local dx = math.abs( event.x - event.xStart )
        if ( dx > 5 ) then
            scrollView:takeFocus( event )
        end
    elseif ( event.phase == "ended" ) then
        --take action if an object was touched
        print( "object", id, "was touched" )
        timer.performWithDelay( 10, function() scrollView:removeSelf(); scrollView = nil; end )
    end
    return true
end
 
local function showSlidingMenu( event )
    if ( "ended" == event.phase ) then
 
        scrollView = widget.newScrollView
        {
            width = display.actualContentWidth,
            height = 100,
            scrollWidth = 1200,
            scrollHeight = 100,
            verticalScrollDisabled = true
        }
        scrollView.x = display.contentCenterX
        scrollView.y = display.contentCenterY
        local scrollViewBackground = display.newRect( 600, 50, 1200, 100 )
        scrollViewBackground:setFillColor( 0, 0, 0.2 )
        scrollView:insert( scrollViewBackground )
        --generate icons
        for i = 1, 20 do
            icons[i] = display.newCircle( i * 56, 50, 22 )
            icons[i]:setFillColor( math.random(), math.random(), math.random() )
            scrollView:insert( icons[i] )
            icons[i].id = i
            icons[i]:addEventListener( "touch", iconListener )
        end
    end
    return true
end


Runtime:addEventListener("touch", showSlidingMenu )