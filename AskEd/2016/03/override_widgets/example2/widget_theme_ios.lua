-----------------------------------------------------------------------------------------
-- theme_ios.lua
-----------------------------------------------------------------------------------------
local modname = ...
local theme = {}
package.loaded[modname] = theme
local imageSuffix = display.imageSuffix or ""

local sheetFile = "widget_theme_ios.png"
local sheetData = "widget_theme_ios_sheet"

-- Check for graphics V1 compatibility mode set
local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )
local isByteColorRange = display.getDefault( "isByteColorRange" )

-- conversion function
local function convertToV1( channels )
    for i=1,#channels do
        channels[i] = 255 * channels[i]
    end
end

-----------------------------------------------------------------------------------------
-- button
-----------------------------------------------------------------------------------------

theme.button = 
{
	sheet = sheetFile,
	data = sheetData,
	
	topLeftFrame = "button_topLeft",
	topLeftOverFrame =  "button_topLeftOver",
	middleLeftFrame = "button_middleLeft",
	middleLeftOverFrame = "button_middleLeftOver",
	bottomLeftFrame = "button_bottomLeft",
	bottomLeftOverFrame = "button_bottomLeftOver",
	
	topMiddleFrame = "button_topMiddle",
	topMiddleOverFrame = "button_topMiddleOver",
	middleFrame = "button_middle",
	middleOverFrame = "button_middleOver",
	bottomMiddleFrame = "button_bottomMiddle",
	bottomMiddleOverFrame = "button_bottomMiddleOver",
	
	topRightFrame = "button_topRight",
	topRightOverFrame = "button_topRightOver",
	middleRightFrame = "button_middleRight",
	middleRightOverFrame = "button_middleRightOver",
	bottomRightFrame = "button_bottomRight",
	bottomRightOverFrame = "button_bottomRightOver",
	
	width = 180, 
	height = 50,
	font = native.systemFontBold,
	fontSize = 20,
	labelColor = 
	{ 
		default = { 0, 0, 0 },
		over = { 0, 0, 0 },
	},
	emboss = true,
	alphaFade = false,
}

-- convert to v1 style values if it's the case
if isByteColorRange then
	convertToV1( theme.button.labelColor.default )
	convertToV1( theme.button.labelColor.over )
end

-----------------------------------------------------------------------------------------
-- slider
-----------------------------------------------------------------------------------------

theme.slider = 
{
	sheet = sheetFile,
    data = sheetData,

	leftFrame = "slider_leftFrame",
	rightFrame = "slider_rightFrame",
	middleFrame = "silder_middleFrame",
	fillFrame = "slider_fill",
	
	topFrame ="slider_topFrameVertical",
	bottomFrame = "slider_bottomFrameVertical",
	middleVerticalFrame = "silder_middleFrameVertical",
	fillVerticalFrame = "slider_fillVertical",
	
	frameWidth = 10,
	frameHeight = 10,
	handleFrame = "slider_handle",
	handleWidth = 32, 
	handleHeight = 32,
}

-----------------------------------------------------------------------------------------
-- pickerWheel
-----------------------------------------------------------------------------------------

theme.pickerWheel = 
{
	sheet = sheetFile,
    data = sheetData,
	backgroundFrame = "picker_bg",
	backgroundFrameWidth = 1,
	backgroundFrameHeight = 222,
	overlayFrame = "picker_overlay",
	overlayFrameWidth = 320,
	overlayFrameHeight = 222,
	seperatorFrame = "picker_separator",
	seperatorFrameWidth = 2,
	seperatorFrameHeight = 8,
	maskFile = "widget_theme_pickerWheel_mask.png",
}

-----------------------------------------------------------------------------------------
-- scrollBar
-----------------------------------------------------------------------------------------

theme.scrollBar = 
{
	sheet = sheetFile,
    data = sheetData,
	topFrame = "scrollBar_top",
	middleFrame = "scrollBar_middle",
	bottomFrame = "scrollBar_bottom",
	width = 5,
	height = 5,
}

-----------------------------------------------------------------------------------------
-- tabBar
-----------------------------------------------------------------------------------------

theme.tabBar = 
{
	sheet = sheetFile,
	data = sheetData,
	backgroundFrame = "tabBar_background",
	backgroundFrameWidth = 100,
	backgroundFrameHeight = 52,
	tabSelectedLeftFrame = "tabBar_tabSelectedLeft",
	tabSelectedRightFrame = "tabBar_tabSelectedRight",
	tabSelectedMiddleFrame = "tabBar_tabSelectedMiddle",
	tabSelectedFrameWidth = 20,
	tabSelectedFrameHeight = 52,
}

-----------------------------------------------------------------------------------------
-- spinner
-----------------------------------------------------------------------------------------

theme.spinner = 
{
	sheet = sheetFile,
	data = sheetData,
	startFrame = "spinner_spinner",
	width = 40,
	height = 40,
	incrementEvery = 50,
	deltaAngle = 30,
}

-----------------------------------------------------------------------------------------
-- switch
-----------------------------------------------------------------------------------------

theme.switch = 
{
	-- Default (on/off switch)
	sheet = sheetFile,
	data = sheetData,
	backgroundFrame = "switch_background",
	backgroundWidth = 165,
	backgroundHeight = 31,
	overlayFrame = "switch_overlay",
	overlayWidth = 83,
	overlayHeight = 31,
	handleDefaultFrame = "switch_handle",
	handleOverFrame = "switch_handleOver",
	mask = "widget_theme_onOff_mask.png",
	
	radio =
	{
		sheet = sheetFile,
		data = sheetData,
		width = 33,
		height = 34,
		frameOff = "switch_radioButtonDefault",
		frameOn = "switch_radioButtonSelected",
	},
	checkbox = 
	{
		sheet = sheetFile,
		data = sheetData,
		width = 33,
		height = 33,
		frameOff = "switch_checkboxDefault",
		frameOn = "switch_checkboxSelected",
	},
}

-----------------------------------------------------------------------------------------
-- stepper
-----------------------------------------------------------------------------------------

theme.stepper = 
{
	sheet = sheetFile,
	data = sheetData,
	defaultFrame = "stepper_nonActive",
	noMinusFrame = "stepper_noMinus",
	noPlusFrame = "stepper_noPlus",
	minusActiveFrame = "stepper_minusActive",
	plusActiveFrame = "stepper_plusActive",
	width = 102,
	height = 38,
}

-----------------------------------------------------------------------------------------
-- progressView
-----------------------------------------------------------------------------------------

theme.progressView = 
{
	sheet = sheetFile,
	data = sheetData,
	fillXOffset = 4, -- 4.5,
	fillYOffset = 4,
	fillOuterWidth = 16,
	fillOuterHeight = 18,
	fillWidth = 12, 
	fillHeight = 10,
	
	fillOuterLeftFrame = "progressView_leftFillBorder",
	fillOuterMiddleFrame = "progressView_middleFillBorder",
	fillOuterRightFrame = "progressView_rightFillBorder",
	
	fillInnerLeftFrame = "progressView_leftFill",
	fillInnerMiddleFrame = "progressView_middleFill",
	fillInnerRightFrame = "progressView_rightFill",
}

-----------------------------------------------------------------------------------------
-- segmentedControl
-----------------------------------------------------------------------------------------

theme.segmentedControl = 
{
	sheet = sheetFile,
	data = sheetData,
	segmentFrameWidth = 11,
	segmentFrameHeight = 29,
	dividerFrameWidth = 1,
	dividerFrameHeight = 29,
	leftSegmentFrame = "segmentedControl_left",
	leftSegmentSelectedFrame = "segmentedControl_leftOn",
	rightSegmentFrame = "segmentedControl_right",
	rightSegmentSelectedFrame = "segmentedControl_rightOn",
	middleSegmentFrame = "segmentedControl_middle",
	middleSegmentSelectedFrame = "segmentedControl_middleOn",
	dividerFrame = "segmentedControl_divider",
	labelColor = 
    { 
        default = { 1 },
        over = { 1 },
    },
	emboss = true
}

-----------------------------------------------------------------------------------------
-- searchField
-----------------------------------------------------------------------------------------

theme.searchField = 
{
    sheet = sheetFile,
    data = sheetData,
    leftFrame = "searchField_leftEdge",
	rightFrame = "searchField_rightEdge",
	middleFrame = "searchField_middle",
	magnifyingGlassFrame = "searchField_magnifyingGlass",
    cancelFrame = "searchField_remove",
    edgeWidth = 17.5,
    edgeHeight = 30,
	magnifyingGlassFrameWidth = 16,
	magnifyingGlassFrameHeight = 17,
    cancelFrameWidth = 19,
    cancelFrameHeight = 19,
	textFieldWidth = 145,
	textFieldHeight = 20,
}

-----------------------------------------------------------------------------------------
-- tableView
-----------------------------------------------------------------------------------------

theme.tableView = 
{
    separatorLeftPadding = 0,
    separatorRightPadding = 0,
    colours = {
		rowColor = { default = { 1, 1, 1, 1 }, over = { 0.11, 0.56, 1, 1 } },
		lineColor = { 0.86, 0.86, 0.86, 1 },
		catColor = { default = { 0.58, 0.62, 0.70, 0.78 }, over = { 0.58, 0.62, 0.70, 0.78 } },
		rowColorDefault = { 1, 1, 1, 1 },
		rowColorOver = { 0.11, 0.56, 1, 1 },
		whiteColor = { 1, 1, 1, 1 },
		pickerRowColor = { 0.60 },
	},
}

-- convert to v1 style values if it's the case
if isByteColorRange then
	convertToV1( theme.tableView.colours.rowColor.default )
	convertToV1( theme.tableView.colours.rowColor.over )
	convertToV1( theme.tableView.colours.catColor.default )
	convertToV1( theme.tableView.colours.catColor.over )
	convertToV1( theme.tableView.colours.lineColor )
	convertToV1( theme.tableView.colours.rowColorDefault )
	convertToV1( theme.tableView.colours.rowColorOver )
	convertToV1( theme.tableView.colours.whiteColor )
	convertToV1( theme.tableView.colours.pickerRowColor )
end

return theme
