-- =============================================================
-- =============================================================
display.setStatusBar(display.HiddenStatusBar) 
-- =============================================================
require "RGMath2D"
-- =============================================================
local angleToVector	= ssk.math2d.angleToVector
local vectorToAngle	= ssk.math2d.vectorToAngle
local scaleVec	= ssk.math2d.scale
local subVec	= ssk.math2d.sub
local lenVec	= ssk.math2d.length
local normVec	= ssk.math2d.normalize
-- =============================================================
local playerSpeed 		= 200 -- pixels per second
local zombieSpeed 		= 45 -- pixels per second
local zombieLowSpeed 	= playerSpeed * 0.2
local zombieHighSpeed 	= playerSpeed * 0.45
local zombieMoveChance  = 10
-- =============================================================
local player = display.newImageRect( "yellow_round.png", 40, 40 )
player.x = display.contentCenterX 
player.y = display.contentCenterY
-- =============================================================
local function onMoveTouch( event )
	if( event.phase == "began" ) then
		transition.cancel( player )
		local vec 		= subVec( event, player )
		local dist 		= lenVec( vec )
		local time = 1000 * dist / playerSpeed
		transition.to( player, { x = event.x, y = event.y, time = time } )
	end
	return true
end;Runtime:addEventListener( "touch", onMoveTouch )

-- =============================================================
-- THE IMPORTANT CHANGES FOLLOW
-- =============================================================
local zombieMover = function( self )
	local vec = subVec( self, player )
	local angle = vectorToAngle(vec)
	local len  = lenVec( vec )

	-- Close to player?  Run again later using a transition trick.
	--
	-- This is a bit advanced, but hey I'm coding this fast so... knowledge...
	--
	if( len < 10 ) then 
		self._dummy = 0
		transition.to( self, { _dummmy = 1, time = 0 , delay = 1000, onComplete = self } )
		return
	end

	-- Modify the angle
	angle = angle + math.random( -60, 60)

	-- Modify the distance to walk
	len = len * math.random( 15, 35 )/100

	-- Chose a place to walk to
	vec = angleToVector( angle, true )
	vec = scaleVec( vec, len )

	-- Cancel any ongoing transitions for safety.
	transition.cancel( self )

	-- Walk to the target
	transition.to( self, { x = vec.x + self.x, y = vec.y + self.y, time = 1000 * len/zombieSpeed, onComplete = self } )
end

-- =============================================================
for i = 1, 3 do
	local zombie = display.newImageRect( "zombie_head.png", 32, 32 )
	zombie.x = display.contentCenterX - 200
	zombie.y = display.contentCenterY +  math.random( -150, 300 )	

	-- Give each zombie a random speed of its own
	zombie.mySpeed = math.random( zombieLowSpeed, zombieHighSpeed)

	-- Attach zombie mover to zombie on 'enterFrame' hook
	zombie.onComplete = zombieMover
	zombie:onComplete()
end