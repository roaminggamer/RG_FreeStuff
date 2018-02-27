io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- 
local physics = require "physics"
physics.start()

-- No adjustment to Gravity Scale
local obj = display.newImageRect( "balloon1.png", 295/4, 482/4 )
obj.x = 100
obj.y = 80
physics.addBody( obj )

-- Gravity Scale Starts And Stays At 0.5
local obj = display.newImageRect( "balloon3.png", 295/4, 482/4 )
obj.x = 250
obj.y = 80
physics.addBody( obj )
obj.gravityScale = 0.5

-- Gravity Scale Increases Gradually from 1 to 3 over 2 seconds
local obj = display.newImageRect( "balloon3.png", 295/4, 482/4 )
obj.x = 400
obj.y = 80
physics.addBody( obj )
transition.to( obj, { gravityScale = 3, time = 2000 })

-- Gravity Scale Decreases Gradually from 1 to 0.1 over 1 seconds
local obj = display.newImageRect( "balloon5.png", 295/4, 482/4 )
obj.x = 550
obj.y = 80
physics.addBody( obj )
transition.to( obj, { gravityScale = 0.1, time = 1000 })

	

