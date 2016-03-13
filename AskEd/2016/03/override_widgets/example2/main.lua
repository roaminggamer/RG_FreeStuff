

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
	print("Loading local widget library ", name )
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

io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

-- Include SSK Core (Features I just can't live without.)
require("ssk_core.globals.variables")
require("ssk_core.globals.functions")
require("ssk_core.extensions.display")
require("ssk_core.extensions.io")
require("ssk_core.extensions.math")
require("ssk_core.extensions.string")
require("ssk_core.extensions.table")
require("ssk_core.extensions.transition_color")

local widget = require("widget")

table.dump(widget)
function showImage( event, _fileName )
    if event.phase == "ended" then 
        print(_fileName)
    end
end

		oneImg = widget.newButton
		{
			x = display.contentCenterX,
			y = display.contentCenterY - 150,
			width = 50,
			height = 50,
			font = native.systemFont,
			defaultFile = "imgs/1.png",
			onEvent = showImage
		}

		twoImg = widget.newButton
		{
			x = display.contentCenterX,
			y = display.contentCenterY,
			width = 50,
			height = 50,
			font = native.systemFont,
			defaultFile = "imgs/2.png",
			onEvent = showImage
		}

		threeImg = widget.newButton
		{
			x = display.contentCenterX,
			y = display.contentCenterY + 150,
			width = 50,
			height = 50,
			font = native.systemFont,
			defaultFile = "imgs/3.png",
			onEvent = showImage
		}

--]]