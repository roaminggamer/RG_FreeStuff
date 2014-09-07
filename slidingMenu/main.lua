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
            width = 460,
            height = 200,
            scrollWidth = 1200,
            scrollHeight = 200,
            verticalScrollDisabled = false
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

        local scrollViewBackground = display.newRect( 600, 100, 1200, 100 )
        scrollViewBackground:setFillColor( 0, 0.3, 0.2 )
        scrollView:insert( scrollViewBackground )
        --generate icons
        for i = 1, 20 do
            icons[i] = display.newCircle( i * 56, 100, 22 )
            icons[i]:setFillColor( math.random(), math.random(), math.random() )
            scrollView:insert( icons[i] )
            icons[i].id = i
            icons[i]:addEventListener( "touch", iconListener )
        end

    end
    return true
end

Runtime:addEventListener("touch", showSlidingMenu)
