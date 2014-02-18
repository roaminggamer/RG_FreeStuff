-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Local Variables
local centerX		= display.contentCenterX
local centerY		= display.contentCenterY

-- Background to make text easier to see (NOT PART OF RECIPE)
local backImage = display.newImageRect( group, "images/interface/backImage2.jpg", 160, 480 )
backImage.rotation = 90
backImage.x = centerX
backImage.y = centerY

-- Text 
local text = display.newText( group, "Basic Text", 0, 0, native.systemFont, 48 )
text.x = centerX
text.y = centerY - 30

-- Embossed Text
local embossed = display.newEmbossedText( group, "Embossed Text", 0, 0, native.systemFont, 48 )
embossed.x = centerX
embossed.y = centerY + 30


return group
