-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Local Variables
local centerX		= display.contentCenterX
local centerY		= display.contentCenterY

local width			= 40
local height		= 40
local radius		= 20
local cornerRadius	= 12

--  Rectangle
local rect = display.newRect ( group, 0, 0, width, height )
rect.x = centerX - 75
rect.y = centerY

-- Rounded Rectangle
local rounded = display.newRoundedRect ( group, 0, 0, width, height, cornerRadius )
rounded.x = centerX - 25
rounded.y = centerY

-- Circle
local circle = display.newCircle( group, centerX + 25, centerY, radius )

-- Image 
local image1 = display.newImage( group, "images/LostGarden/gem.png")
image1.x = centerX + 75
image1.y = centerY

-- Image Rectangle (Image File)
local image2 = display.newImageRect( group, "images/LostGarden/gem.png", width, height)
image2.x = centerX + 125
image2.y = centerY

-- Sprite Rectangle - SEE EFM



return group
