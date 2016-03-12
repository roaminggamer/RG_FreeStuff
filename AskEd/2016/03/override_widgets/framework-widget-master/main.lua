--[[
	Copyright:
		Copyright (C) 2013 Corona Inc. All Rights Reserved.
		
	File: 
		main.lua
--]]

-- Nil out the preloaded theme files so we load the local ones
package.preload.widget_theme_ios = nil
package.preload.widget_theme_ios_sheet = nil
package.preload.widget_theme_ios7 = nil
package.preload.widget_theme_ios7_sheet = nil
package.preload.widget_theme_android = nil
package.preload.widget_theme_android_sheet = nil
package.preload.widget_theme_android_holo_light = nil
package.preload.widget_theme_android_holo_light_sheet = nil
package.preload.widget_theme_android_holo_dark = nil
package.preload.widget_theme_android_holo_dark_sheet = nil

-- Override Corona's core widget libraries with the files contained in this project's subdirectory.
-- Argument "name" will be set to the name of the library being loaded by the require() function.
local function onRequireWidgetLibrary(name)
	return require("widgetLibrary." .. name)
end
package.preload.widget = onRequireWidgetLibrary
package.preload.widget_button = onRequireWidgetLibrary
package.preload.widget_momentumScrolling = onRequireWidgetLibrary
package.preload.widget_pickerWheel = onRequireWidgetLibrary
package.preload.widget_progressView = onRequireWidgetLibrary
package.preload.widget_scrollview = onRequireWidgetLibrary
package.preload.widget_searchField = onRequireWidgetLibrary
package.preload.widget_segmentedControl = onRequireWidgetLibrary
package.preload.widget_spinner = onRequireWidgetLibrary
package.preload.widget_stepper = onRequireWidgetLibrary
package.preload.widget_slider = onRequireWidgetLibrary
package.preload.widget_switch = onRequireWidgetLibrary
package.preload.widget_tabbar = onRequireWidgetLibrary
package.preload.widget_tableview = onRequireWidgetLibrary

-- For xcode console output
io.output():setvbuf( "no" )

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local storyboard = require( "storyboard" )
storyboard.gotoScene( "unitTestListing" )

--storyboard.gotoScene( "tableView" )
