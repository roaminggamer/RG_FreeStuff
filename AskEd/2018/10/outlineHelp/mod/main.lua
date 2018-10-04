-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local cx = display.contentCenterX
local cy = display.contentCenterY

local physics = require ("physics")
physics.start();
physics.setDrawMode( "hybrid" )
--physics.setGravity( 0, 9.8 )
physics.setGravity( 0, 0)

local ground = display.newRect( 0, 0, 1000, 30 )
ground.x = 160; ground.y = 445
physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )

-- RG Icon
local outline = graphics.newOutline( 20, "codingNinja.png" )
local image = display.newImageRect( "codingNinja.png", 80,80 )
image.x, image.y = cx - 100, cy
physics.addBody( image, "dynamic", { outline = outline, bounce = 0.5, friction = 0.1 } )

-- Complex Convex Shape
local outline = graphics.newOutline( 20, "problemImage.png" )
local image = display.newImageRect( "problemImage.png", 80,80 )
image.x, image.y = cx, cy
physics.addBody( image, "dynamic", { outline = outline, bounce = 0.5, friction = 0.1 } )

-- Less Complex Convex Shape 
local outline = graphics.newOutline( 20, "notConcave.png" )
local image = display.newImageRect( "problemImage.png", 80,80 )
image.x, image.y = cx + 100, cy
physics.addBody( image, "dynamic", { outline = outline, bounce = 0.5, friction = 0.1 } )
