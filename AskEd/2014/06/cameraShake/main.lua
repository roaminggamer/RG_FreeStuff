io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

local physics = require("physics")
physics.start()
physics.setGravity(0,9.8)
--physics.setDrawMode( "hybrid" )


--
-- The shake code
--
local shakeCount = 0
local xShake = 8
local yShake = 4
local shakePeriod = 2

local function shake()
	if(shakeCount % shakePeriod == 0 ) then
		display.currentStage.x = display.currentStage.x0 + math.random( -xShake, xShake )
		display.currentStage.y = display.currentStage.y0 + math.random( -yShake, yShake )
	end
	shakeCount = shakeCount + 1
end

local function startShake()
	display.currentStage.x0 = display.currentStage.x
	display.currentStage.y0 = display.currentStage.y
	shakeCount = 0
	Runtime:addEventListener( "enterFrame", shake )
end
local function stopShake()
	Runtime:removeEventListener( "enterFrame", shake )
	timer.performWithDelay( 50, 
		function()			
			display.currentStage.x = display.currentStage.x0 
			display.currentStage.y = display.currentStage.y0
		end )
	timer.performWithDelay( 250, 
		function()			
			print("STOPPED SHAKE: ", display.currentStage.x, display.currentStage.x0, display.currentStage.y, display.currentStage.y0 )
		end )		
end	


--
-- Images and scene items to help visualize the effect
--
local back = display.newImageRect("hawaii_2014.jpg", 480, 320 )
back.x = display.contentCenterX
back.y = display.contentCenterY

local ground = display.newRect(0,0,480,20)
ground:setFillColor(0,1,0)
ground.x = display.contentCenterX
ground.y = 330
physics.addBody( ground, "static", { bounce = 0 } )


local ball = display.newCircle(display.contentCenterX,20,20)
ball:setFillColor(1,0,0)
physics.addBody( ball, "dynamic", { radius = 20, bounce = 1 } )

ball.collision = function( self, event )
	if( event.phase == "began" ) then
		startShake()
		timer.performWithDelay( 500, stopShake  )
	end
	return true
end
ball:addEventListener( "collision" )


