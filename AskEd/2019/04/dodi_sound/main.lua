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
physics.setGravity(0,10)
physics.setDrawMode("hybrid")

-- =====================================================
-- YOUR CODE BELOW
-- =====================================================
-- sound test to the forums
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local obt
local boing = audio.loadSound("boing.mp3")
local physics = require( "physics" )
physics.start()

local baseVolume = 0.25

local function onTimer( self )
	local channel = audio.findFreeChannel( 1 )
	self.boing = (self.boing or 1)
	print( "BOING ", baseVolume * self.boing )
	audio.setVolume( baseVolume * self.boing, { channel = channel } ) -- set the volume on channel 1
	audio.play( boing, { channel = channel } )
	self.boingTimer = nil
	self.boing = 1
end

--collision
local function onLocalCollision( self, event )
  if ( event.phase == "began" ) then
    if (self.id == "ball" and event.other.id == "bars") then
      --audio.play( boing )
      self.boing = (self.boing) and (self.boing + 1) or 1
      if( self.boingTimer ) then 
      	timer.cancel(self.boingTimer)      	
      end
      self.boingTimer = timer.performWithDelay( 1,self )
      display.remove( obj[1])
    end
  end
end
--ball
local ballColor = { 0, 128, 0 }
local ball = display.newCircle( centerX, centerY-400, 30 )  --300
ball.fill = ballColor
ball.id = "ball"
physics.addBody( ball, { density=0.8, friction=1.0, bounce=0.5, radius=30 } )
ball.collision = onLocalCollision
ball:addEventListener( "collision", ball )

ball.timer = onTimer

--objects
obj = {}
local numOfObj = 3
for i = 1, numOfObj do
  obj[i] = display.newRect( 0, 0, 30, 50 )
  obj[i]:setFillColor( 255, 0, 0 )
  obj[i].id = "bars"
  physics.addBody( obj[i], "static", { friction=0, bounce=0 } )
end
  obj[1].x = centerX
  obj[1].y = centerY-65
  obj[2].x = centerX-25
  obj[2].y = centerY+75
  obj[3].x = centerX+25
  obj[3].y = centerY+75