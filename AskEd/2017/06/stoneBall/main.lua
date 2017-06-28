local physics = require "physics"
physics.start()
---physics.setDrawMode( "hybrid" )

local stone = display.newImageRect( "images/kenney_stone.png", 100, 100 )
stone.x = 400
stone.y = 800
physics.addBody( stone, "static" )

local ball = display.newImageRect( "images/kenney1.png", 100, 100 )
ball.x = 400
ball.y = 600
physics.addBody( ball, "dynamic", { radius = 50, bounce = 0.9 } )