-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

local physics = require("physics")
physics.start()
physics.setGravity( 0 , 0)


-- ==
--    Simple versions of Arrowheads and arrows
-- ==
local curX = centerX - 100
local curY = centerY - 50
ssk.display.arrowhead( group, curX, curY )

curX = curX + 100
ssk.display.arrow( group, curX, curY + 20, curX, curY - 10 )

curX = curX + 100
ssk.display.arrow2( group, curX, curY + 20, 45, 30 * math.sqrt(2) )


-- ==
--    More Complicated of Extra Objects
-- ==
curX = centerX - 100
curY = centerY + 50
ssk.display.arrowhead( group, curX, curY, 40, 40, 
                       { width = 2, color = _RED_, rotation = -45, referencePoint =  display.CenterReferencePoint} )

curX = curX + 100
ssk.display.arrow( group, curX, curY + 20, curX, curY - 10, { width = 2, color = _PINK_ }  )

curX = curX + 100
ssk.display.arrow2( group, curX, curY + 20, -45, 20,  { width = 2, color = _PURPLE_  } )


return group

