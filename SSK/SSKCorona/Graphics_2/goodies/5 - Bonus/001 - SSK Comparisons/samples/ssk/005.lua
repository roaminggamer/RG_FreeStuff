-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Straight Line
local line1 = ssk.display.line( group, 0, centerY - 30, w, centerY - 30  )

-- Segmented Line
local points = ssk.points:new( 0, centerY + 25, 
                               w/4, centerY,
							   2 * w/4, centerY + 50,
							   3 * w/4, centerY,
							   w, centerY + 25 )
local line2 = ssk.display.segmentedLine( group, points )



return group
