
local centerX 			= display.contentCenterX
local centerY 			= display.contentCenterY

local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode("hybrid")

-- OLD
local imageName = "mossyrockf.png"
local imageOutline = graphics.newOutline( 15, imageName )
local image = display.newImage( "mossyrockf.png" )
physics.addBody( image, { outline = imageOutline } )
image.x = centerX - 150
image.y = centerY

-- FIXED
local imageName = "mossyrockf_mod7.png"
local imageOutline = graphics.newOutline( 2, imageName )
local image = display.newImage( imageName )
physics.addBody( image, { outline = imageOutline } )
image.x = centerX + 150
image.y = centerY