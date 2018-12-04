io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
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
physics.setGravity(0,50)
--physics.setDrawMode("hybrid")
-- =====================================================
-- =====================================================
local hanger = display.newImageRect( "protoBackX.png", 720, 1386 )
hanger.x = display.contentCenterX
hanger.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	hanger.rotation = 90
end

local swinger1 = display.newImageRect( "corona256.png", 256, 256 )
swinger1.x = cx - 100
swinger1.y = cy 
local pivot1 = display.newCircle( swinger1.x - 100, swinger1.y, 12 )
pivot1:setFillColor(0,0,1)

local swinger2 = display.newImageRect( "rg256.png", 256, 256 )
swinger2.x = cx + 250
swinger2.y = cy 
local pivot2 = display.newCircle( swinger2.x - 100, swinger2.y, 12 )
pivot2:setFillColor(0,1,0)

physics.addBody( hanger, "static" )
hanger.isSensor = true

physics.addBody( swinger1, "dynamic", { radius = 120 } )
physics.addBody( swinger2, "dynamic", { radius = 120 } )

local pivotJoint = physics.newJoint( "pivot", swinger1, hanger, pivot1.x, pivot1.y )

local pivotJoint = physics.newJoint( "pivot", swinger2, hanger, pivot2.x, pivot2.y )

-- apply it from beginning...
--swinger2.linearDamping = 1

-- or apply it later and increase it over a short time
transition.to(swinger2, { linearDamping = 2.5, time = 2000, delay = 2000, transition = easing.outCirc } )
