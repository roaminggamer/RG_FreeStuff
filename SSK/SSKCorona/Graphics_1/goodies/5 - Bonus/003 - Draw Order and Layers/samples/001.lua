-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

group.title = "Draw Order (The Painter's Model)"

-- Local Variables
local h				= display.contentHeight
local w				= display.contentWidth
local centerX		= display.contentCenterX
local centerY		= display.contentCenterY

local redCircle = display.newCircle( group, centerX, centerY - 30, 35 )
redCircle:setFillColor( 255, 0 , 0 )

local greenCircle = display.newCircle( group, centerX + 21, centerY + 21, 35 )
greenCircle:setFillColor( 0, 255 , 0 )

local blueCircle = display.newCircle( group, centerX - 21, centerY + 21, 35 )
blueCircle:setFillColor( 0, 0, 255 )

return group
