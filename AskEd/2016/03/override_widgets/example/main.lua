
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

--- beyond this point, widget.* will use your local (modified) code

