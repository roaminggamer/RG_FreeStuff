io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
-- == Uncomment following lines if you need  physics
local physics = require "physics"
physics.start()
physics.setGravity(0,10)
--physics.setDrawMode("hybrid")
--
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================
-- =====================================================
local cx = display.contentCenterX
local cy = display.contentCenterY
local fullw = display.actualContentWidth
local fullh = display.actualContentHeight
local mRand = math.random
--

local ground = display.newRect( cx, cy + 200, fullw, 40)
physics.addBody( ground, "static" )


local function onCollision( self, event )
   if( event.phase == "began" ) then
   	timer.performWithDelay( 1, function() physics.removeBody( self ) end )
   	transition.to( self, { alpha = 0, delay = 500, time = 0, onComplete = display.remove } )
   end
   return true
end

local function ballDrop()
   local ball = display.newImageRect( "ball.png", 50, 50 )
   ball:setFillColor( mRand(50,100)/100, mRand(50,100)/100, mRand(50,100)/100 )

   ball.x = cx + mRand( -fullw/2, fullw/2 )
   ball.y = cy - fullh/2 + 40

   physics.addBody( ball, { bounce = 0, radius = 23 } )
   ball.angularVelocity = (mRand(1,2)==1) and -180 or 180
   ball.linearDamping = 2

   ball.collision = onCollision
   ball:addEventListener( "collision" )
end

timer.performWithDelay( 1000, ballDrop, -1 )

-- =====================================================
-- =====================================================


