-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Local Variables
local width			= 40
local height		= 40
local radius		= 20
local cornerRadius	= 12

--  Rectangle (RED FILL + GREEN STROKE)
local rect =  ssk.display.rect( group, centerX - 75, centerY, 
                                { width = width, height = height, 
								  fill = _RED_, stroke = _GREEN_, strokeWidth = 1 } ) 

-- Rounded Rectangle (BLUE FILL + MEDIUM YELLOW STROKE)
local rounded =  ssk.display.rect( group, centerX - 25, centerY, 
                                   { width = width, height = height, cornerRadius = cornerRadius, 
								     fill = _BLUE_, stroke = _YELLOW_, strokeWidth = 2 } ) 

-- Circle (BLUE FILL + THICK WHITE STROKE)
ssk.display.circle( group, centerX + 25, centerY, 
                    { radius = 20, fill = _BLUE_, stroke = _WHITE_, strokeWidth = 4 } ) 

-- Image (ORANGE FILL)
ssk.display.image( group, centerX + 75, centerY, "images/LostGarden/gem.png", { fill = _ORANGE_ }) 

-- Image Rectangle (Image File) (Image File) (PINK FILL + WHITE STROKE)
ssk.display.imageRect( group, centerX + 125, centerY, "images/LostGarden/gem.png",
					   { width = width, height = height, 
					     fill = _PINK_, stroke = _WHITE_, strokeWidth = 1 } ) 


-- Sprite Rectangle - SEE EFM


return group
