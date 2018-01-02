-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================

local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode("hybrid")

-- =============================================================
-- Circular Bodies
-- =============================================================

-- texture
local tmp = display.newImageRect( "circle.png", 100, 100)
tmp.x = 100
tmp.y = 100

-- naive body
local tmp = display.newImageRect( "circle.png", 100, 100)
tmp.x = 250
tmp.y = 100
physics.addBody( tmp,"static", { radius = 50 } )

-- fixed body
local tmp = display.newImageRect( "circle.png", 100, 100)
tmp.x = 400
tmp.y = 100
physics.addBody( tmp,"static", { radius = 40 } )

-- =============================================================
-- Rectangular Bodies
-- =============================================================

-- texture
local tmp = display.newImageRect( "square.png", 100, 100)
tmp.x = 100
tmp.y = 250

-- naive body
local tmp = display.newImageRect( "square.png", 100, 100)
tmp.x = 250
tmp.y = 250
physics.addBody( tmp,"static", {} )

-- fixed body
local tmp = display.newImageRect( "square.png", 100, 100)
tmp.x = 400
tmp.y = 250
local bodyShape = { -45, -45, 
                    45, -45, 
                    45, 45, 
                    -45, 45 }
physics.addBody( tmp,"static", { shape = bodyShape} )


-- =============================================================
-- Overlap Example and fix
-- =============================================================


local tmp = display.newImageRect( "square.png", 100, 100)
tmp.x = 100
tmp.y = 500
timer.performWithDelay( 1000, function() physics.addBody( tmp,"dynamic", {} ) end )

local tmp = display.newImageRect( "square.png", 100, 100)
tmp.x = 100
tmp.y = 590
physics.addBody( tmp,"static", {} )

local tmp = display.newImageRect( "square.png", 100, 100)
tmp.x = 250
tmp.y = 500
timer.performWithDelay( 1000, function() physics.addBody( tmp,"dynamic", { shape = bodyShape} ) end )

local tmp = display.newImageRect( "square.png", 100, 100)
tmp.x = 250
tmp.y = 590
physics.addBody( tmp,"static", { shape = bodyShape} )
