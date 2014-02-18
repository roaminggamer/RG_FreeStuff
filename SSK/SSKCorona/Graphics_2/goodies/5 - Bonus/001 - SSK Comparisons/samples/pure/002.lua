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

-- Rectangle (RED FILL + GREEN STROKE)
local rect = display.newRect ( group, 0, 0, width, height )
rect.x = centerX - 75
rect.y = centerY
rect:setFillColor( 255, 0, 0 )
rect:setStrokeColor( 0, 255, 0)
rect.strokeWidth = 1

-- Rounded Rectangle (BLUE FILL + MEDIUM YELLOW STROKE)
local rounded = display.newRoundedRect ( group, 0, 0, width, height, cornerRadius )
rounded.x = centerX - 25
rounded.y = centerY
rounded:setFillColor( 0, 0, 255 )
rounded:setStrokeColor( 255, 255, 0)
rounded.strokeWidth = 2

-- Circle (BLUE FILL + THICK WHITE STROKE)
local circle = display.newCircle( group, centerX + 25, centerY, radius )
circle:setFillColor( 0, 0, 255 )
circle:setStrokeColor( 255, 255, 255 )
circle.strokeWidth = 4

-- Image (ORANGE FILL)
local image1 = display.newImage( group, "images/LostGarden/gem.png" )
image1.x = centerX + 75
image1.y = centerY
image1:setFillColor(  0xff, 0x66, 0 )

-- Image Rectangle (Image File) (PINK FILL + WHITE STROKE)
local image2 = display.newImageRect( group, "images/LostGarden/gem.png", width, height )
image2.x = centerX + 125
image2.y = centerY
image2:setFillColor( 0xff, 0x6e, 0xc7 )
image2:setStrokeColor( 255, 255, 255)
image2.strokeWidth = 1

-- Sprite Rectangle - SEE EFM



return group
