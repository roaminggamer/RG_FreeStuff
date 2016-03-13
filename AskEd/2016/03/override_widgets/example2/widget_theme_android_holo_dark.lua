-----------------------------------------------------------------------------------------
-- theme_android_holo_dark.lua
-----------------------------------------------------------------------------------------
local modname = ...
local theme = {}
package.loaded[modname] = theme
local imageSuffix = display.imageSuffix or ""

local sheetFile = "widget_theme_android_holo_dark.png"
local sheetData = "widget_theme_android_holo_dark_sheet"

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
	font = native.systemFont,
	fontSize = 14,
	labelColor = 
	{ 
		default = { 190/255, 190/255, 190/255 },
		over = { 1 },
	},
	emboss = false,
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
	separatorFrame = "picker_separator",
	separatorFrameWidth = 8,
	separatorFrameHeight = 1,
	font = native.systemFont,
	fontSize = 18,
	columnColor = { 0,0,0,0 },
	fontColor = { 102/255 },
	fontColorSelected = { 1 }
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
	height = 40,
	sheet = sheetFile,
	data = sheetData,
	backgroundFrame = "tabBar_background",
	backgroundFrameWidth = 25,
	backgroundFrameHeight = 40,
	tabSelectedLeftFrame = "tabBar_tabSelectedLeft",
	tabSelectedRightFrame = "tabBar_tabSelectedRight",
	tabSelectedMiddleFrame = "tabBar_tabSelectedMiddle",
	tabSelectedFrameWidth = 10,
	tabSelectedFrameHeight = 40,
	isHolo = true,
	defaultLabelFont = native.systemFont,
	defaultLabelSize = 12,
	defaultLabelColor =
	{
		default = { 51/255, 181/255, 229/255, 1 },
        over = { 51/255, 181/255, 229/255, 1 },
	}
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
	backgroundWidth = 139,
	backgroundHeight = 24,
	overlayFrame = "switch_overlay",
	overlayWidth = 92,
	overlayHeight = 24,
	handleDefaultFrame = "switch_handle",
	handleOverFrame = "switch_handleOver",
	mask = "widget_theme_onOff_mask_android_holo.png",
	offDirection = "left",

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
	width = 88,
	height = 26,
}

-----------------------------------------------------------------------------------------
-- progressView
-----------------------------------------------------------------------------------------

theme.progressView = 
{
	sheet = sheetFile,
	data = sheetData,
	fillOuterWidth = 4,
	fillOuterHeight = 12,
	fillWidth = 4, 
	fillHeight = 12,
	
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
	segmentFrameHeight = 30,
	dividerFrameWidth = 1,
	dividerFrameHeight = 30,
	leftSegmentFrame = "segmentedControl_left",
	leftSegmentSelectedFrame = "segmentedControl_leftOn",
	rightSegmentFrame = "segmentedControl_right",
	rightSegmentSelectedFrame = "segmentedControl_rightOn",
	middleSegmentFrame = "segmentedControl_middle",
	middleSegmentSelectedFrame = "segmentedControl_middleOn",
	dividerFrame = "segmentedControl_divider",
	labelSize = 12,
	labelColor = 
    {
        default = { 51/255, 181/255, 229/255, 1 },
        over = { 51/255, 181/255, 229/255, 1 },
    },
	labelYOffset = -2,
	emboss = false
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
		rowColor = { default = { 48/255 }, over = { 72/255 } },
		lineColor = { 34/255 },
		catColor = { default = { 102/255 }, over = { 102/255 } },
		rowColorDefault = { 48/255 },
		rowColorOver = { 72/255 },
		whiteColor = { 1 },
		pickerRowColor = { 102/255 },
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
