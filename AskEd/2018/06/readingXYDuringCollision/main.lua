io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
-- == Uncomment following lines if you need  physics
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")

-- =====================================================
-- EXAMPLE
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end

local wall = display.newRect( cx + 138, cy - 150,  310, 40 )
wall.rotation = 45
physics.addBody( wall, "static" )
local wall = display.newRect( cx - 100, cy + 150,  300, 40 )
wall.rotation = 45
physics.addBody( wall, "static" )
local wall = display.newRect( cx + 134, cy + 100,  400, 40 )
wall.rotation = 135
physics.addBody( wall, "static" )
local wall = display.newRect( cx - 102, cy - 100,  400, 40 )
wall.rotation = 135
physics.addBody( wall, "static" )

local ball = display.newCircle( cx, cy - 50, 20)
physics.addBody( ball, { radius = 20, bounce = 1 })
ball:setLinearVelocity( 4000, -2000)

local label = display.newText( "", left + 150, top + 50 )

function ball.collision( self, event )
	label.text = "< " .. tostring( math.floor( self.x ) ) .. ", " .. tostring( math.floor( self.y ) ) .. " >"
end; ball:addEventListener( "collision" )
-- =====================================================
-- YOUR CODE ABOVE
-- =====================================================


 