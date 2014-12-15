-- =============================================================
-- main.lua
-- =============================================================

require "nativeExt"


local myInputField = native.newTextField( display.contentCenterX, 100, 200, 40 )
myInputField.size = native.getScaledFontSize( myInputField )

local myInputField = native.newScaledTextField( display.contentCenterX, 200, 200, 40 )