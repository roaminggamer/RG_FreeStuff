-- Physics Demo: Predicting Trajectory | Version: 1.0
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.
-- SPECIAL THANKS to Matt Webster (a.k.a. "HoraceBury") for the trajectory calculations!

local physics = require("physics") ; physics.start() ; physics.setGravity( 0,9.8 ) ; physics.setDrawMode( "normal" )
display.setStatusBar( display.HiddenStatusBar )

--set up some references and other variables
local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)
local cw, ch = display.contentWidth, display.contentHeight

--set up terrain and background
local back = display.newImageRect( "sky.jpg", 1024, 768 ) ; back.x = cw/2 ; back.y = ch/2 ; back:scale( 1.4,1.4 )
local wallL = display.newRect( -ox, -oy, 40, ch+oy+oy )
physics.addBody(wallL, "static", { bounce=0.4, friction=1.0 } )
local wallR = display.newRect( cw-40+ox, -oy, 40, ch+oy+oy )
physics.addBody(wallR, "static", { bounce=0.4, friction=1.0 } )
local wallB = display.newRect( -ox, ch-40+oy, cw+ox+ox, 40 )
physics.addBody(wallB, "static", { bounce=0.2, friction=1.0 } )
local wallT = display.newRect( -ox, -oy, cw+ox+ox, 40 )
physics.addBody(wallT, "static", { bounce=0.2, friction=1.0} )
local msg = display.newText( "Touch, drag, and release to launch projectiles", 0, 0, "ContenuBook-Display", 40 )
msg:setTextColor(255,255,255,220) ; msg.x, msg.y = cw/2,110

local prediction = display.newGroup() ; prediction.alpha = 0.2
local line



local function getTrajectoryPoint( startingPosition, startingVelocity, n )

	--velocity and gravity are given per second but we want time step values here
	local t = 1/display.fps --seconds per time step at 60fps
	local stepVelocity = { x=t*startingVelocity.x, y=t*startingVelocity.y }  --b2Vec2 stepVelocity = t * startingVelocity
	local stepGravity = { x=t*0, y=t*9.8 }  --b2Vec2 stepGravity = t * t * m_world
	return {
		x = startingPosition.x + n * stepVelocity.x + 0.25 * (n*n+n) * stepGravity.x,
		y = startingPosition.y + n * stepVelocity.y + 0.25 * (n*n+n) * stepGravity.y
		}  --startingPosition + n * stepVelocity + 0.25 * (n*n+n) * stepGravity
end



local function updatePrediction( event )

	display.remove( prediction )  --remove dot group
	prediction = display.newGroup() ; prediction.alpha = 0.2  --now recreate it
	
	local startingVelocity = { x=event.x-event.xStart, y=event.y-event.yStart }
	
	for i = 1,180 do --for (int i = 0; i < 180; i++)
		local s = { x=event.xStart, y=event.yStart }
		local trajectoryPosition = getTrajectoryPoint( s, startingVelocity, i ) -- b2Vec2 trajectoryPosition = getTrajectoryPoint( startingPosition, startingVelocity, i )
		local circ = display.newCircle( prediction, trajectoryPosition.x, trajectoryPosition.y, 5 )
	end
end



local function fireProj( event )

	if ( event.xStart < -ox+44 or event.xStart > display.contentWidth+ox-44
		or event.yStart < -oy+44 or event.yStart > display.contentHeight+oy-44 ) then
		display.remove( prediction )
		return
	end
	
	local proj = display.newImageRect( "object.png", 64, 64 )
	physics.addBody( proj, { bounce=0.2, density=1.0, radius=14 } )
	proj.x, proj.y = event.xStart, event.yStart
	local vx, vy = event.x-event.xStart, event.y-event.yStart
	proj:setLinearVelocity( vx,vy )

end



local function screenTouch( event )

	local eventX, eventY = event.x, event.y
	
	if ( event.phase == "began" ) then
		line = display.newLine( eventX, eventY, eventX, eventY )
		line.width = 4 ; line.alpha = 0.6
	elseif ( event.phase == "moved" ) then
		display.remove( line )
		line = display.newLine( event.xStart, event.yStart, eventX, eventY )
		line.width = 4 ; line.alpha = 0.6
		updatePrediction( event )
	else
		display.remove( line )
		updatePrediction( event )
		fireProj( event )
	end
	return true

end

Runtime:addEventListener( "touch", screenTouch )