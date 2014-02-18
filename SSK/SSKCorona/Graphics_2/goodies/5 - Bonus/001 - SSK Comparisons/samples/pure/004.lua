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

-- Text (BLUE)
local text = display.newText( group, "Colorized Text", 0, 0, native.systemFont, 48 )
text.x = centerX
text.y = centerY - 30
text:setTextColor( 255, 0 , 0 )

-- Embossed Text ( RED, WHITE, BLUE )
local embossed = display.newEmbossedText( group, "Colorized Embossed Text", 0, 0, native.systemFont, 32 )
embossed.x = centerX
embossed.y = centerY + 30

local color = 
{
    highlight = 
    {
        r = 255, g = 0, b = 0, a = 255
    },
    shadow =
    {
        r = 0, g = 0, b = 255, a = 255
    }
}
embossed:setTextColor( 255, 255, 255 )
embossed:setEmbossColor( color )


return group
