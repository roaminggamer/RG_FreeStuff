-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Local Variables
local centerX		= display.contentCenterX
local centerY		= display.contentCenterY
local w				= display.contentWidth

-- Straight Line
local line1 = display.newLine( group, 0, centerY - 30, w, centerY - 30  )

-- Segmented Line
local line2 = display.newLine( group, 0, centerY + 25, w/4, centerY  )
line2:append( 2 * w/4, centerY + 50, 
              3 * w/4, centerY ,
			  w, centerY + 25 )

			  

return group
