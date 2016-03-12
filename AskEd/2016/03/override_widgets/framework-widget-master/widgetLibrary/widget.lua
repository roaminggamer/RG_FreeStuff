--[[
	Copyright:
		Copyright (C) 2013 Corona Inc. All Rights Reserved.
		
	File: 
		widget.lua
--]]

local widget = 
{
	version = "2.0",
	themeName = "default"
}

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

---------------------------------------------------------------------------------
-- PRIVATE METHODS
---------------------------------------------------------------------------------

-- Modify factory function to ensure widgets are properly cleaned on group removal
local cached_displayNewGroup = display.newGroup
function display.newGroup()
	local newGroup = cached_displayNewGroup()
	
	-- Function to find/remove widgets within group
	local function removeWidgets( group )
		if group.numChildren then
			for i = group.numChildren, 1, -1 do
				if group[i]._isWidget then
					group[i]:removeSelf()
				
				elseif not group[i]._isWidget and group[i].numChildren then
					-- Nested group (that is not a widget)
					removeWidgets( group[i] )
				end
			end
		end
	end
	
	-- Store a reference to the original removeSelf method
	local cached_removeSelf = newGroup.removeSelf
	
	-- Subclass the removeSelf method
	function newGroup:removeSelf()
		-- Remove widgets first
		removeWidgets( self )
		
		-- Continue removing the group as usual
		if self.parent and self.parent.remove then
			self.parent:remove( self )
		end
	end
	
	return newGroup
end

-- Override removeSelf() method for new widgets
local function _removeSelf( self )
	-- All widget objects can add a finalize method for cleanup
	local finalize = self._finalize
	
	-- If this widget has a finalize function
	if type( finalize ) == "function" then
		finalize( self )
	end

	-- Remove the object
	self:_removeSelf()
	self = nil
end


-- Dummy function to remove focus from a widget, any widget can override this function to remove focus if needed.
function widget._loseFocus()
	return
end

-- Widget constructor. Every widget object is created from this method
function widget._new( options )

	local newWidget

	newWidget = display.newGroup() -- All Widget* objects are display groups, except scrollview and tableview
	newWidget.id = options.id or "widget*"
	newWidget.baseDir = options.baseDir or system.ResourceDirectory
	newWidget._isWidget = true
	newWidget._widgetType = options.widgetType
	newWidget._removeSelf = newWidget.removeSelf
	newWidget.removeSelf = _removeSelf
	newWidget._loseFocus = widget._loseFocus

	if not isGraphicsV1 then
		newWidget.anchorChildren = true
	end
	
	return newWidget
end

-- G2.0 constructor for tableview / scrollview
function widget._newContainer( options )

	local newWidget

	if isGraphicsV1 then
		newWidget = display._newContainer( display.contentWidth, display.contentHeight ) -- All Widget* objects are display groups, except scrollview and tableview
	else
		newWidget = display.newContainer( display.contentWidth, display.contentHeight )
	end
	newWidget.id = options.id or "widget*"
	newWidget.baseDir = options.baseDir or system.ResourceDirectory
	newWidget._isWidget = true
	newWidget._widgetType = options.widgetType
	newWidget._removeSelf = newWidget.removeSelf
	newWidget.removeSelf = _removeSelf
	newWidget._loseFocus = widget._loseFocus

	return newWidget

end

local newWidgetV2 = function( newWidget, ... )

	-- we obtain the old anchorpoints first
	local oldAnchorX = display.getDefault( "anchorX" )
	widget._oldAnchorX = oldAnchorX
	local oldAnchorY = display.getDefault( "anchorY" )
	widget._oldAnchorY = oldAnchorY
	
	-- then we set the anchors to 0.5 for the widget
	display.setDefault( "anchorX", 0.5 )
	display.setDefault( "anchorY", 0.5 )

	-- we localize the newWidget call
	local g = newWidget( ... )

	-- we restore the old defaults
	display.setDefault( "anchorX", oldAnchorX )
	display.setDefault( "anchorY", oldAnchorY )

	-- only the top-level group needs to have the old anchorX/Y
	g.anchorX = oldAnchorX
	g.anchorY = oldAnchorY

	return g
end

-- Function to retrieve a frame index from an imageSheet data file
function widget._getFrameIndex( theme, frame )
	if theme then
		if theme.data then
			if "function" == type( require( theme.data ).getFrameIndex ) then
				return require( theme.data ):getFrameIndex( frame )
			end
		end
	end
end

-- Function to check if the requirements for creating a widget have been met
function widget._checkRequirements( options, theme, widgetName )
	-- If we are using single images, just return
	if options.defaultFile or options.overFile then
		return
	end
	
	-- If there isn't an options table and there isn't a theme set, throw an error
	local noParams = not options and not theme
	
	if noParams then
		error( "WARNING: Either you haven't set a theme using widget.setTheme or the widget theme you are using does not support " .. widgetName, 3 )
	end
	
	-- If the user hasn't provided the necessary image sheet lua file (either via custom sheet or widget theme)
	local noData = not options.data and not theme.data

	if noData then
		if widget.theme then
			error( "ERROR: " .. widgetName .. ": theme data file expected, got nil", 3 )
		else
			error( "ERROR: " .. widgetName .. ": Attempt to create a widget with no custom imageSheet data set and no theme set, if you want to use a theme, you must call widget.setTheme( theme )", 3 )
		end
	end
	
	-- Throw error if the user hasn't defined a sheet and has defined data or vice versa.
	local noSheet = not options.sheet and not theme.sheet
	
	if noSheet then
		if widget.theme then
			error( "ERROR: " .. widgetName .. ": Theme sheet expected, got nil", 3 )
		else
			error( "ERROR: " .. widgetName .. ": Attempt to create a widget with no custom imageSheet set and no theme set, if you want to use a theme, you must call widget.setTheme( theme )", 3 )
		end
	end		
end

-- Set the current theme from a lua theme file
function widget.setTheme( themeModule )
	-- Returns table with theme data
	widget.theme = require( themeModule )
	widget.themeName = themeModule
end

-- Check if the theme is ios7
function widget.isSeven()
	return widget.themeName == "widget_theme_ios7"
end

function widget.isHolo()
	if widget.themeName == "widget_theme_android_holo_dark" or widget.themeName == "widget_theme_android_holo_light" then
		return true
	end
end

-- Function to retrieve a widget's theme settings
local function _getTheme( widgetTheme, options )	
	local theme = nil
		
	-- If a theme has been set
	if widget.theme then
		theme = widget.theme[widgetTheme]
	end
	
	-- If a theme exists
	if theme then
		-- Style parameter optionally set by user
		if options and options.style then
			local style = theme[options.style]
			
			-- For themes that support various "styles" per widget
			if style then
				theme = style
			end
		end
	end
	
	return theme
end

-- Function to check if an object is within bounds
function widget._isWithinBounds( object, event )
	local bounds = object.contentBounds
    local x, y = event.x, event.y
	local isWithinBounds = true
		
	if "table" == type( bounds ) then
		if "number" == type( x ) and "number" == type( y ) then
			isWithinBounds = bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
		end
	end
	
	return isWithinBounds
end

------------------------------------------------------------------------------------------
-- PUBLIC METHODS
------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- newScrollView widget
-----------------------------------------------------------------------------------------

function widget.newScrollView( options )
	local _scrollView = require( "widget_scrollview" )
	return _scrollView.new( options )
end

-----------------------------------------------------------------------------------------
-- newTableView widget
-----------------------------------------------------------------------------------------

function widget.newTableView( options )
	local theme = _getTheme( "tableView", options )
	local _tableView = require( "widget_tableview" )
	return _tableView.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newPickerWheel widget
-----------------------------------------------------------------------------------------

function widget.newPickerWheel( options )
	local theme = _getTheme( "pickerWheel", options )
	local _pickerWheel = require( "widget_pickerWheel" )
	return _pickerWheel.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newSlider widget
-----------------------------------------------------------------------------------------

function widget.newSlider( options )	
	local theme = _getTheme( "slider", options )
	local _slider = require( "widget_slider" )
	return _slider.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newTabBar widget
-----------------------------------------------------------------------------------------

function widget.newTabBar( options )
	local theme = _getTheme( "tabBar", options )
	local _tabBar = require( "widget_tabbar" )
	return _tabBar.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newButton widget
-----------------------------------------------------------------------------------------

function widget.newButton( options )
	local theme = _getTheme( "button", options )
	local _button = require( "widget_button" )
	return _button.new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newSpinner widget
-----------------------------------------------------------------------------------------

function widget.newSpinner( options )
	local theme = _getTheme( "spinner", options )
	local _spinner = require( "widget_spinner" )
	return _spinner.new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newSwitch widget
-----------------------------------------------------------------------------------------

function widget.newSwitch( options )
	local theme = _getTheme( "switch", options )
	local _switch = require( "widget_switch" )
	return _switch.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newStepper widget
-----------------------------------------------------------------------------------------

function widget.newStepper( options )
	local theme = _getTheme( "stepper", options )
	local _stepper = require( "widget_stepper" )
	return _stepper.new( options, theme )
end

-----------------------------------------------------------------------------------------
-- newSearchField widget
-----------------------------------------------------------------------------------------

function widget.newSearchField( options )
	local theme = _getTheme( "searchField", options )
	local _searchField = require( "widget_searchField" )
	return _searchField.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newProgressView widget
-----------------------------------------------------------------------------------------

function widget.newProgressView( options )
	local theme = _getTheme( "progressView", options )
	local _progressView = require( "widget_progressView" )
	return _progressView.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- newSegmentedControl widget
-----------------------------------------------------------------------------------------

function widget.newSegmentedControl( options )
	local theme = _getTheme( "segmentedControl", options )
	local _segmentedControl = require( "widget_segmentedControl" )
	return _segmentedControl.new( options, theme )	
end

-----------------------------------------------------------------------------------------
-- graphics v2.0 constructor calls
-----------------------------------------------------------------------------------------
if not isGraphicsV1 then

	local newScrollView = widget.newScrollView
	widget.newScrollView = function( ... )
		return newWidgetV2( newScrollView, ... )
	end

	local newTableView = widget.newTableView
	widget.newTableView = function( ... )
		return newWidgetV2( newTableView, ... )
	end

	local newPickerWheel = widget.newPickerWheel
	widget.newPickerWheel = function( ... )
		return newWidgetV2( newPickerWheel, ... )
	end

	local newSlider = widget.newSlider
	widget.newSlider = function( ... )
		return newWidgetV2( newSlider, ... )
	end

	local newTabBar = widget.newTabBar
	widget.newTabBar = function( ... )
		return newWidgetV2( newTabBar, ... )
	end

	local newButton = widget.newButton
	widget.newButton = function( ... )
		return newWidgetV2( newButton, ... )
	end

	local newSpinner = widget.newSpinner
	widget.newSpinner = function( ... )
		return newWidgetV2( newSpinner, ... )
	end

	local newSwitch = widget.newSwitch
	widget.newSwitch = function( ... )
		return newWidgetV2( newSwitch, ... )
	end

	local newStepper = widget.newStepper
	widget.newStepper = function( ... )
		return newWidgetV2( newStepper, ... )
	end

	local newSearchField = widget.newSearchField
	widget.newSearchField = function( ... )
		return newWidgetV2( newSearchField, ... )
	end

	local newProgressView = widget.newProgressView
	widget.newProgressView = function( ... )
		return newWidgetV2( newProgressView, ... )
	end
	
	local newSegmentedControl = widget.newSegmentedControl
	widget.newSegmentedControl = function( ... )
		return newWidgetV2( newSegmentedControl, ... )
	end

end

-----------------------------------------------------------------------------------------
-- utility methods
-----------------------------------------------------------------------------------------

-- color conversion function
function widget._convertColorToV1( channels )
    for i=1,#channels do
        channels[i] = 255 * channels[i]
    end
end

-- widget position calculation based on defined anchor point
function widget._calculatePosition( object, opt )
	local x, y = opt.x, opt.y
	if not opt.x or not opt.y then
		local leftPos = opt.left
		local topPos = opt.top

		x = leftPos + object.contentWidth * 0.5
		y = topPos + object.contentHeight * 0.5
		-- left and top values have to be adjusted in non-compatibility mode
		if not isGraphicsV1 then
			leftPos = leftPos + ( widget._oldAnchorX * object.contentWidth )
			x = math.floor( leftPos )
			topPos = topPos + ( widget._oldAnchorY * object.contentHeight )
			y = math.floor( topPos )
		end
	end
	return x, y
end

-- determine if a file exists. Used for determining if custom assets passed to constructors actually exist in the project.
function widget._fileExists( fileName, baseDir )
    local baseDir = baseDir or system.ResourceDirectory
    local filePath = system.pathForFile( fileName, baseDir, true )
    return( filePath )
end

-- Get platform
local platformName = system.getInfo( "platformName" )
local isSimulator = "Mac OS X" == platformName or "Win" == platformName
local isAndroid = "Android" == platformName
local defaultTheme = "widget_theme_ios7"

if isAndroid then
	defaultTheme = "widget_theme_android"
elseif not isSimulator then
	-- Only show the iOS 6 theme if its on below iOS 7
	-- Gets the major platform version eg 10 in 10.1.3
	local platformVersion = string.match(system.getInfo("platformVersion"), "%d+")
	platformVersion = tonumber(platformVersion)
	
	if type(platformVersion) == "number" and platformVersion < 7 then
		defaultTheme = "widget_theme_ios"
	end
end

-- Set the default theme
widget.setTheme( defaultTheme )

return widget
