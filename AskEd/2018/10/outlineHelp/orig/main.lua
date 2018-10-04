-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local physics = require ("physics")
physics.start();
physics.setDrawMode( "hybrid" )
physics.setGravity( 0, 9.8 )

local ground = display.newRect( 0, 0, 1000, 30 )
ground.x = 160; ground.y = 445
physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )





--local imageFile = "codingNinja.png" -- This works
local imageFile = "problemImage.png" -- This doesnt work :()

local imageOutline = graphics.newOutline( 20, imageFile )
local image = display.newImageRect( imageFile, 256,256 )
image.x,image.y = 170, 100
physics.addBody( image, "dynamic", { outline=imageOutline, bounce=0.5, friction=0.1 } )
