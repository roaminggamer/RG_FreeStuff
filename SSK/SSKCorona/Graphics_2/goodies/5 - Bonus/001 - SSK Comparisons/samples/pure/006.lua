-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Local Variables
local centerX		= display.contentCenterX
local centerY		= display.contentCenterY
local w				= display.contentWidth

-- Straight Line (RED)
local line1 = display.newLine( group, 0, centerY - 30, w, centerY - 30  )
line1:setColor( 255, 0, 0 )

-- Segmented Line (THICK BLUE)
local line2 = display.newLine( group, 0, centerY + 25, w/4, centerY  )
line2:append( 2 * w/4, centerY + 50, 
              3 * w/4, centerY,
			  w, centerY + 25 )
line2:setColor( 0, 0, 255 )
line2.width = 6



return group
