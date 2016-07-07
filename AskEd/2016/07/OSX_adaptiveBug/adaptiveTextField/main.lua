local windowsText = require "windowsText"
windowsText.enable()


local swapWH = false -- set to true to fix bug

-- Placement Frame (shows where textfield should be and how big it should be)
local placement = display.newRect( display.contentCenterX, display.contentCenterY - 50, 200, 40 )
placement:setStrokeColor(1,0,0)
placement:setFillColor(0,0,0,0)
placement.strokeWidth = 2

local textfield1 = native.newTextField( placement.x, placement.y, placement.contentWidth, placement.contentHeight )

--[[

-- Placement Frame (shows where textfield should be and how big it should be)
--local placement2 = display.newRect( display.contentCenterX, display.contentCenterY + 50, 200, 40 )
local placement2 = display.newRect( 100, 20 , 200, 40 )
placement2:setStrokeColor(0,1,0)
placement2:setFillColor(0,0,0,0)
placement2.strokeWidth = 2

local textfield2 = native.newTextField( placement2.x, placement2.y, placement2.contentWidth, placement2.contentHeight )

local rw = 1
local rh = 1
local resize
resize = function( self )
	local newField = native.newTextField( placement2.x, placement2.y, placement2.contentWidth * rw, placement2.contentHeight * rh )
	newField.text = textfield2.text	
	Runtime:removeEventListener( self )
	display.remove( textfield2 )
	textfield2 = newField
	newField.resize = resize
	--timer.performWithDelay( 1, function() 
	Runtime:addEventListener( 'resize', newField ) 
	--end
end
Runtime:addEventListener( 'resize', textfield2 ) 
--]]
--[[

local acw0 = display.actualContentWidth
local ach0 = display.actualContentHeight
local acw1
local ach1

local function resize()
	acw1 = display.actualContentHeight
	ach1 = display.actualContentWidth
	rh = acw1/acw0
	rw = ach1/ach0
	--print("\nA", acw1,ach1,rw,rh)
	--print("\nB", display.contentScaleX, display.contentScaleY)
	--print("\nC", display.pixelWidth, display.pixelHeight)
	--print("\n----------------------------------")
	print(display.actualContentWidth,display.actualContentHeight)
end; Runtime:addEventListener("resize",resize)
print(display.actualContentWidth,display.actualContentHeight)
--]]

--[[
local didFirstResize = false
local doFlip = false
local function resize()
	didFirstResize = true
	--doFlip = ( onOSX and didFirstResize and onSimulator == false )
	print(display.contentScaleX, display.contentScaleY )
end; Runtime:addEventListener("resize",resize)

print(display.contentScaleX, display.contentScaleY )
--]]