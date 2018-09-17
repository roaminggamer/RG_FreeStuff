io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
-- =====================================================
local widget = require( "widget" )
 
-- Function to handle button events
local function handleTabBarEvent( event )
    print( event.target.id )  -- Reference to button's 'id' parameter
end

local baseDir = system.DocumentsDirectory
 
-- Configure the tab buttons to appear within the bar
local tabButtons = {
    {
        width = 72, 
        height = 120,
        defaultFile = "tabBarIconDef.png",
        overFile = "tabBarIconOver.png",
        baseDir = baseDir,
        label = "Tab1",
        id = "tab1",
        selected = true,
        size = 16,
        labelYOffset = -8,
        onPress = handleTabBarEvent
    },
    {
        width = 72, 
        height = 120,
        defaultFile = "tabBarIconDef.png",
        overFile = "tabBarIconOver.png",
        baseDir = baseDir,
        label = "Tab2",
        id = "tab2",
        size = 16,
        labelYOffset = -8,
        onPress = handleTabBarEvent
    },
    {
        width = 72, 
        height = 120,
        defaultFile = "tabBarIconDef.png",
        overFile = "tabBarIconOver.png",
        baseDir = baseDir,
        label = "Tab3",
        id = "tab3",
        size = 16,
        labelYOffset = -8,
        onPress = handleTabBarEvent
    }
}
 
-- Create the widget
local tabBar = widget.newTabBar(
    {
        left = 0,
        top = display.contentHeight-120,
        width = 580,
        height = 120,
        backgroundFile = "tabBarBack.png",
        tabSelectedLeftFile = "tabBarSelL.png",
        tabSelectedRightFile = "tabBarSelR.png",
        tabSelectedMiddleFile = "tabBarSelM.png",
        baseDir = baseDir,
        tabSelectedFrameWidth = 40,
        tabSelectedFrameHeight = 120,
        buttons = tabButtons
    }
)
