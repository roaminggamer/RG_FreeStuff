-- =============================================================
-- main.lua
-- =============================================================
local round = require "round"
local build = system.getInfo("build")

print(build, tonumber(build)> 2014.2519)

local supportsAutoScaling = tonumber(build) > 2014.2519

if( supportsAutoScaling ) then 
	print("Supports AUTO-SCALING - Demo auto-scaling and old-style solution side-by-side.")
else
	print("Does not support AUTO-SCALING - Demo old-style solution only.")
end

local textFieldWidth = display.contentWidth - 10

-- =============================================================
--  SCALING MODULE (extension) from this blog post: 
--  http://coronalabs.com/blog/2014/12/02/tutorial-sizing-text-input-fields/
-- =============================================================
require "nativeExt"
	
-- Turn off auto-scaling for purposes of this demo
if( supportsAutoScaling ) then 
	display.setDefault( "isNativeTextFieldFontSizeScaled", false )
end

-- Scale text to fit box
local myInputField = native.newTextField( display.contentCenterX, 70, textFieldWidth, 30 ) -- box is 60 pixels high
myInputField.size = native.getScaledFontSize( myInputField )
myInputField.text = "Scaled text"

-- Scale box to fit text
local myInputField = native.newScaledTextField( display.contentCenterX, 115, textFieldWidth, 30, 10 ) -- Use font size 30 w/ margin of 10 pixels
myInputField.text = "Scaled box"
-- Re-position text field (to look nicer in demo)

-- Some text for comparison to the last
local tmp = display.newText("This is font size 30.", display.contentCenterX, 157, native.systemFont, 30 )
tmp.anchorX = 0
tmp.x = 10


-- =============================================================
--  AUTO-SCALING METHODS (2014.2520 or later)
--  http://coronalabs.com/blog/2014/12/16/tutorial-new-native-text-input-features/
-- =============================================================
if( supportsAutoScaling ) then 
	-- Turn on auto-scaling for purposes of this demo
	display.setDefault( "isNativeTextFieldFontSizeScaled", true )

	-- Scale text to fit box	
	local myInputField = native.newTextField( display.contentCenterX, 200, textFieldWidth, 30 )
	myInputField:resizeFontToFitHeight()
	myInputField.text = "Auto-scaled text"
	-- Re-position text field (to look nicer in demo)

	-- Scale box to fit text	
	local myInputField = native.newTextField( display.contentCenterX, 240, textFieldWidth, 30 )
	myInputField.size = 30
	myInputField:resizeHeightToFitFont()
	myInputField.text = "Auto-scaled box"
	-- Re-position text field (to look nicer in demo)

	-- Some text for comparison to the last
	local tmp = display.newText("This is font size 30.", display.contentCenterX, 280, native.systemFont, 30 )
	tmp.anchorX = 0
	tmp.x = 10
end
