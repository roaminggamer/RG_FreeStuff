
local swapWH = false -- set to true to fix bug

-- Placement Frame (shows where textfield should be and how big it should be)
local placement = display.newRect( display.contentCenterX, display.contentCenterY - 50, 200, 40 )
placement:setStrokeColor(1,0,0)
placement:setFillColor(0,0,0,0)
placement.strokeWidth = 2

local textfield1 = native.newTextField( placement.x, placement.y, placement.contentWidth, placement.contentHeight )



-- Placement Frame (shows where textfield should be and how big it should be)
local placement2 = display.newRect( display.contentCenterX, display.contentCenterY + 50, 200, 40 )
placement2:setStrokeColor(0,1,0)
placement2:setFillColor(0,0,0,0)
placement2.strokeWidth = 2

local textfield2 = native.newTextField( placement2.x, placement2.y, placement2.contentWidth, placement2.contentHeight )

local resize
resize = function( self )
	local newField = native.newTextField( placement2.x, placement2.y, placement2.contentWidth, placement2.contentHeight )
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
