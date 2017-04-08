io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

local mRand = math.random
local getTimer = system.getTimer

local centerX 	= display.contentCenterX
local centerY 	= display.contentCenterY
local fullw 	= display.actualContentWidth
local fullh		= display.actualContentHeight
local left 		= centerX - fullw/2
local right 	= left + fullw
local top 		= centerY - fullh/2
local bottom 	= top + fullh

local physics = require "physics"
physics.start()
physics.getGravity( 0, 10 )
physics.setDrawMode('hybrid')

--
-- Player 1 - Normal Jumper (YELLOW)
--
local ground = display.newRect( centerX, centerY, fullw, 40)
ground.anchorY = 1
ground:setFillColor(0,0.8,0)
physics.addBody( ground, "static" )

local player1 = display.newImageRect( "circle.png", 40, 40 )
player1.x = left + 20
player1.y = centerY - 80
player1:setFillColor(1,1,0)
physics.addBody( player1, "dynamic" )


--
-- Player 2 - Mario-esque Jumper (CYAN)
--
local ground2 = display.newRect( centerX, bottom, fullw, 40)
ground2.anchorY = 1
ground2:setFillColor(0,0.8,0)
physics.addBody( ground2, "static" )

local player2 = display.newImageRect( "circle.png", 40, 40 )
player2.x = left + 20
player2.y = bottom - 80
player2:setFillColor(0,1,1)
physics.addBody( player2, "dynamic")

--
-- Jump Function
--
local jumpMag = 10
local jumpVec = { x = 0.5 * jumpMag, y = -1 * jumpMag }

local function onTouch( event )
	if( event.phase == "began" ) then
		player1:applyLinearImpulse( jumpVec.x * player1.mass, jumpVec.y * player1.mass, player1.x, player1.y )
		
	
		transition.cancel( player2)
		player2.gravityScale = 1
		player2:applyLinearImpulse( jumpVec.x * player2.mass, jumpVec.y * player2.mass, player2.x, player2.y )

	elseif( event.phase == "ended" ) then
		transition.to( player2, { gravityScale = 3, time = 300, transition = easing.outCirc } )
	end
end

Runtime:addEventListener("touch", onTouch)
