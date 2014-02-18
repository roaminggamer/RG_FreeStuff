-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Simple to Complex Versions of ssk.display.line
local curX = centerX - 175
local curY = centerY - 50

ssk.display.line( group, curX, curY + 20, curX, curY - 20 )

curX = curX + 100
ssk.display.line( group, curX, curY + 20, curX, curY - 20, { style = "dashed", dashLen = 6, gapLen = 3, color = _YELLOW_ })

curX = curX + 100
ssk.display.line( group, curX, curY + 20, curX, curY - 20, 
				  { style = "dotted", dashLen = 6, gapLen = 3,  radius = 3, 
				    color = _TRANSPARENT_, stroke = _GREEN_, strokeWidth=1,  })
				  
curX = curX + 100
ssk.display.line( group, curX - 50, curY , curX + 50, curY, 
                  { style = "arrows", headWidth = 5, headHeight = 5, dashLen = 8, gapLen = 14, color = _RED_ })


-- Simple to Complex Versions of ssk.display.line2
curX = centerX - 175
curY = centerY + 50

ssk.display.line2( group, curX, curY + 20, 45, 40 * math.sqrt(2))

curX = curX + 100
ssk.display.line2( group, curX, curY + 20, 45, 40 * math.sqrt(2), 
                  { style = "dashed",  dashLen = 4, gapLen = 2, color = _YELLOW_ })


curX = curX + 100
ssk.display.line2( group, curX+15, curY+20, -45, 40 * math.sqrt(2), 
				  { style = "dotted",  dashLen = 2, gapLen = -2, radius = 4, 
				    color = _TRANSPARENT_, stroke = _GREEN_, strokeWidth=1,  })

curX = curX + 100
ssk.display.line2( group, curX + 50, curY, -90, 100, 
                  { style = "arrows", headWidth = 5, headHeight = 5,  dashLen = 8, gapLen = 5, color = _RED_ })

return group
