-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Local Variables
local width			= 40
local height		= 40
local radius		= 20
local cornerRadius	= 12

--  Rectangle
local rect =  ssk.display.rect( group, centerX - 75, centerY, { width = width, height = height } ) 

-- Rounded Rectangle
local rounded =  ssk.display.rect( group, centerX - 25, centerY, { width = width, height = height, cornerRadius = cornerRadius } )

-- Circle
ssk.display.circle( group, centerX + 25, centerY, { radius = 20 } )

-- Image (Image File)
ssk.display.image( group, centerX + 75, centerY, "images/LostGarden/gem.png") 


-- Image Rectangle (Image File)
ssk.display.imageRect( group, centerX + 125, centerY, "images/LostGarden/gem.png", { width = width, height = height } ) 


-- Sprite Rectangle - SEE EFM


return group
