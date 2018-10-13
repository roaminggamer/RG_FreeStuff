io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
ssk.meters.create_fps(true)
ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
-- =====================================================
local mAbs  			= math.abs
local mRand 			= math.random
local getTimer 		= system.getTimer
local actorSize		= 40
local fightDist 		= 32
local lanePoints 		= {}
local leftGuys 		= {}
local rightGuys 		= {}
local leftScore 		= 0
local rightScore 		= 0
local lanes 			= 4
local laneWidth 		= actorSize * 2
local speedUp			= 1 -- for debugging and speeding up whole 'game' to test faster
local fightTime 		= 500/speedUp
local spawnPeriod 	= 1000/speedUp

-- =====================================================
-- HUDS to count left and right guys how are currently alive
-- =====================================================
local layers = ssk.display.quickLayers( nil, "background", "content", "foreground" )
local back = ssk.display.newImageRect( layers.background, centerX, centerY, "protoBackX.png", 
	                                    { w = 720, h = 1386, rotation = 90 } )

local leftGuysHUD = ssk.display.newRect( layers.foreground, left+150, bottom-50, 
													{ w = 280, h = 80, fill = _DARKERGREY_ } )
leftGuysHUD.countLabel = display.newText( layers.foreground, 0, leftGuysHUD.x - 280/4, leftGuysHUD.y, nil, 20 )
leftGuysHUD.scoreLabel = display.newText( layers.foreground, 0, leftGuysHUD.x + 280/4, leftGuysHUD.y, nil, 20 )
leftGuysHUD.scoreLabel:setFillColor(1,1,0,0.5)


local rightGuysHUD = ssk.display.newRect( layers.foreground, right-150, bottom-50, 
													{ w = 280, h = 80, fill = _DARKERGREY_ } )
rightGuysHUD.countLabel = display.newText( layers.foreground, 0, rightGuysHUD.x - 280/4, rightGuysHUD.y, nil, 20 )
rightGuysHUD.scoreLabel = display.newText( layers.foreground, 0, rightGuysHUD.x + 280/4, rightGuysHUD.y, nil, 20 )
rightGuysHUD.scoreLabel:setFillColor(0,1,0,0.5)

-- =====================================================
-- Draw the lanes
-- =====================================================
local curY = centerY - (lanes/2 ) * laneWidth
local tmp = display.newLine( layers.background, left, curY, right, curY )
tmp:setStrokeColor(1,0,0)
tmp.strokeWispawnDTh = 3
for i = 1, lanes do
	curY = curY + laneWidth
	tmp = display.newLine( layers.background, left, curY, right, curY )
	tmp:setStrokeColor(unpack(_ORANGE_))
	tmp.strokeWispawnDTh = 2
end
tmp.strokeWispawnDTh = 3
tmp:setStrokeColor(1,0,0)

-- =====================================================
-- Draw boxes to mark the starting positions of lanes
-- =====================================================
local curY = centerY - (lanes/2 ) * laneWidth + laneWidth/2
for i = 1, lanes do
	lanePoints[#lanePoints+1] = { 
		ssk.display.newRect( layers.background, left + laneWidth/2, curY, 
			                       { size = laneWidth/2, fill = _T_, stroke = _Y_, strokeWispawnDTh = 2 } ),
		ssk.display.newRect( layers.background, right - laneWidth/2, curY, 
			                       { size = laneWidth/2, fill = _T_, stroke = _G_, strokeWispawnDTh = 2 } )		
	}
	curY = curY + laneWidth
end

-- =====================================================
-- Left/Right Guy spawner
-- =====================================================
local function spawnGuy( side )
	side = side or 1 -- 1, 2 == left, right
	
	-- Select random lane to start in
	local lane = mRand( 1, lanes )

	-- Determine x,y starting position
	local x = lanePoints[lane][side].x
	local y = lanePoints[lane][side].y

	-- Make an actor display object
	local actor = ssk.display.newImageRect( layers.content, x, y, (side == 1 ) and "leftGuy.png" or "rightGuy.png",
	                                        { size = actorSize } )
	
	-- Give actor some attributes
	actor.speed = mRand( speedUp * 50, speedUp * 75 )
	actor.side = side
	actor.fighting = false
	actor.lane = lane	

	-- Store reference to actor indexed by its display object handle
	if( side == 1 ) then 
		leftGuys[actor] = actor
	else
		rightGuys[actor] = actor
	end

	return actors
end

-- =====================================================
-- Enter Frame Listener To Do All Work
-- =====================================================
local lastSpawnTime = getTimer() - spawnPeriod
local lastMoveTime = getTimer()
local function enterFrame()	
	local curT = getTimer()

	-- Time to spawn new guys?
	local spawnDT = curT - lastSpawnTime
	if( spawnDT >= spawnPeriod ) then
		lastSpawnTime = curT
		spawnGuy(1)
		spawnGuy(2)		
	end

	-- Update counts of guys on their HUDs
	leftGuysHUD.countLabel.text = table.count( leftGuys )
	rightGuysHUD.countLabel.text = table.count( rightGuys )

	-- Move Everyone is isn't fighting
	-- Also check to see if they reached their goal and if so, 
	-- remove the player 	
	local moveDT = curT - lastMoveTime
	lastMoveTime = curT
	local dx
	for _,guy in pairs( leftGuys ) do
		if( not guy.fighting ) then
			dx = guy.speed * moveDT/1000
			guy.x = guy.x + dx
			--
			if( guy.x > right ) then 
				leftGuys[guy] = nil
				display.remove( guy )
				rightScore = rightScore + 1
				rightGuysHUD.scoreLabel.text = rightScore
			end
		end
	end

	for _,guy in pairs( rightGuys ) do
		if( not guy.fighting ) then
			dx = -guy.speed * moveDT/1000
			guy.x = guy.x + dx
			--
			if( guy.x < left ) then 
				rightGuys[guy] = nil
				display.remove( guy )
				leftScore = leftScore + 1
				leftGuysHUD.scoreLabel.text = leftScore
			end
		end
	end

	-- Check to see if anyone is near enought to fight
	local adx
	for _, leftGuy in pairs( leftGuys ) do
		if( not leftGuy.fighting ) then
			
			for _, rightGuy in pairs( rightGuys ) do
				if( not rightGuy.fighting ) then
			
					if( ( leftGuy.lane == rightGuy.lane ) and  
						 mAbs( leftGuy.x - rightGuy.x ) <= fightDist ) then
						leftGuy.fighting = true
						rightGuy.fighting = true
						leftGuy:setFillColor(1,0,0)
						rightGuy:setFillColor(1,0,0)

						--
						-- Wait fightTime and randomly choose one guy to win fight
						--
						timer.performWithDelay( fightTime,
							function()
								if(mRand(1,2) == 2 ) then
									leftGuys[leftGuy] = nil
									display.remove(leftGuy)
									rightGuy.fighting = false
									rightGuy:setFillColor(1,1,1)
								else
									rightGuys[rightGuy] = nil
									display.remove(rightGuy)
									leftGuy.fighting = false
									leftGuy:setFillColor(1,1,1)
								end
							end )

					end
				end
			end
		end
	end

end
Runtime:addEventListener("enterFrame", enterFrame)


