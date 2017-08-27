-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
-- =============================================================
local group = display.newGroup()

local widget = require( "widget" )
  
-- ScrollView listener
local function scrollListener( event )
 
    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end
 
    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "down" ) then print( "Reached top limit" )
        elseif ( event.direction == "left" ) then print( "Reached right limit" )
        elseif ( event.direction == "right" ) then print( "Reached left limit" )
        end
    end
 
    return false
end
 
-- Create the widget
local scrollView = widget.newScrollView(
    {
        top = top,
        left = left,
        width = fullw,
        height = fullh,
        listener = scrollListener,
        horizontalScrollDisabled = true,
        hideBackground = true,
    }
)
 
-- Create a image and insert it into the scroll view
local background = display.newRect(  0, 0, fullw, fullh * 1.5 )
background.anchorX = 0
background.anchorY = 0
background:setFillColor(0.25, 0.25, 0.25)
scrollView:insert( background )



-- Create the widget
local scrollView2 = widget.newScrollView(
    {
        width = fullw,
        height = 200,
        listener = scrollListener,
        verticalScrollDisabled  = true,
        hideBackground = true,
    }
)
scrollView2.y = 200
local tmp = display.newText( "Story Set 1", 40, scrollView2.y - 140)
tmp.anchorX = 0
scrollView:insert(tmp)

 
-- Create a image and insert it into the scroll view
local curX = 100
for i = 2, 7 do
	local card = display.newImageRect( "images/cardClubs" .. i .. ".png", 140, 190 )
	card.x = curX
	card.y = 190/2
	scrollView2:insert( card )
	curX = curX + 160
end

scrollView:insert(scrollView2)


-- Create the widget
local scrollView2 = widget.newScrollView(
    {
        width = fullw,
        height = 200,
        listener = scrollListener,
        verticalScrollDisabled  = true,
        hideBackground = true,
    }
)
scrollView2.y = 550
local tmp = display.newText( "Story Set 2", 40, scrollView2.y - 140)
tmp.anchorX = 0
scrollView:insert(tmp)

-- Create a image and insert it into the scroll view
local curX = 100
for i = 2, 7 do
	local card = display.newImageRect( "images/cardClubs" .. i .. ".png", 140, 190 )
	card.x = curX
	card.y = 190/2
	scrollView2:insert( card )
	curX = curX + 160
end

scrollView:insert(scrollView2)


-- Create the widget
local scrollView2 = widget.newScrollView(
    {
        width = fullw,
        height = 200,
        listener = scrollListener,
        verticalScrollDisabled  = true,
        hideBackground = true,
    }
)
scrollView2.y = 900
local tmp = display.newText( "Story Set 3", 40, scrollView2.y - 140)
tmp.anchorX = 0
scrollView:insert(tmp)

-- Create a image and insert it into the scroll view
local curX = 100
for i = 2, 7 do
	local card = display.newImageRect( "images/cardClubs" .. i .. ".png", 140, 190 )
	card.x = curX
	card.y = 190/2
	scrollView2:insert( card )
	curX = curX + 160
end

scrollView:insert(scrollView2)


-- Create the widget
local scrollView2 = widget.newScrollView(
    {
        width = fullw,
        height = 200,
        listener = scrollListener,
        verticalScrollDisabled  = true,
        hideBackground = true,
    }
)
scrollView2.y = 1250
local tmp = display.newText( "Story Set 4", 40, scrollView2.y - 140)
tmp.anchorX = 0
scrollView:insert(tmp)

-- Create a image and insert it into the scroll view
local curX = 100
for i = 2, 7 do
	local card = display.newImageRect( "images/cardClubs" .. i .. ".png", 140, 190 )
	card.x = curX
	card.y = 190/2
	scrollView2:insert( card )
	curX = curX + 160
end

scrollView:insert(scrollView2)