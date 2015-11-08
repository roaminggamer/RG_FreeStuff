-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"1. Tap anywhere on screen and 'player' yellow smiley will move there.", 
	"2. Zombies will start following as soon as player moves first time.",
	"3. Zombies will continue to adjust course following player.",
	"4. Notice that the zombies lurch?  See the logic to see how this was done."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Load SSK or just RGMath2D.lua (all we are using in the example)
--require "ssk.loadSSK"
--require "RGMath2D"

--
-- 2. Localize some useful math2d functions
local scaleVec	= ssk.math2d.scale
local subVec	= ssk.math2d.sub
local lenVec	= ssk.math2d.length
local normVec	= ssk.math2d.normalize

--
-- 3. Handy variables to control example
local playerSpeed 		= 250 -- pixels per second
local zombieLowSpeed 	= playerSpeed * 0.2
local zombieHighSpeed 	= playerSpeed * 0.45
local zombieMoveChance  = 10

-- 
-- 4. Create player
local player = display.newImageRect( "yellow_round.png", 40, 40 )
player.x = display.contentCenterX 
player.y = display.contentCenterY
player.isMoving = false -- Flag for our 'zombie' start to follow logic

-- 
-- 5. A Runtime touch listener to move the player
local function onMoveTouch( event )
	if( event.phase == "began" ) then
		-- 
		-- Flag player as moving 
		player.isMoving = true
		
		-- 
		-- Cancel any outstanding transitions on player
		transition.cancel( player )

		--
		-- Get distance between player and touch event		
		local vec 		= subVec( event, player )
		local dist 		= lenVec( vec )

		--
		-- Calculate move time 
		local time = 1000 * dist / playerSpeed

		-- 
		-- Move player
		transition.to( player, { x = event.x, y = event.y, time = time } )
	end
	return true
end

Runtime:addEventListener( "touch", onMoveTouch )


-- 
-- 5. 'enterfFrame' follower for zombies
--
-- Tip: This is a bit inefficient, but it is a starting point for
-- movement logic w/o using physics.
--
-- These zombies will move in the 'current' direction of the 
-- player, an occasially correct course.  This way they seem
-- be slow witted and bad direction changes
--
local zombieMover = function( self )
	--
	-- Player hasn't started moving for first time yet
	if( player.isMoving == false ) then
		return 
	end

	-- Only 'sometimes' walk/step/move
	--
	local percent = math.random(0,100)
	if( percent < zombieMoveChance ) then
		return 
	end

	-- 
	-- Cancel any outstanding transitions on player
	transition.cancel( self )

	--
	-- Get distance between player and touch event		
	local vec 		= subVec( player, self )
	local dist 		= lenVec( vec )

	--
	-- Calculate move time 
	local time = 1000 * dist / self.mySpeed

	-- 
	-- Move zombie towards player's current position
	transition.to( self, { x = player.x, y = player.y, time = time } )
end


-- 
-- 4. Create 10 Zombies and attach mover to each

for i = 1, 10 do
	local zombie = display.newImageRect( "zombie_head.png", 32, 32 )
	zombie.x = display.contentCenterX - math.random( 300, 400 )
	zombie.y = display.contentCenterY +  math.random( -150, 300 )	

	-- Give each zombie a random speed of its own
	zombie.mySpeed = math.random( zombieLowSpeed, zombieHighSpeed)

	-- Attach zombie mover to zombie on 'enterFrame' hook
	zombie.enterFrame = zombieMover
	Runtime:addEventListener( "enterFrame", zombie )
end