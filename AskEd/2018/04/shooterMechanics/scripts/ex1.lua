-- =============================================================
-- =============================================================
local physics 		= require "physics"
-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua Functions
local getTimer          = system.getTimer
local mRand					= math.random
local mAbs					= math.abs
local mFloor				= math.floor
local mCeil					= math.ceil
local strGSub				= string.gsub
local strSub				= string.sub
local strMatch				= string.match
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale

-- =============================================================
-- Locals
-- =============================================================
local enemy
local player
local enemySpeed  = 100 -- pixels per second
local bulletSpeed = 200 -- pixels per second

-- You must set up basic rules for what collides with what, otherwise
-- player bullet will hit the player too and we don't want that.
--
-- This involves bit math which I know who to do, but am WAY too lazy to do, so
-- I use SSK's collision calculator:
-- https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/cc/
--
local myCC = ssk.cc:newCalculator()
myCC:addNames( "player", "enemy", "pbullet" )
myCC:collidesWith( "enemy", { "player", "pbullet" } )

-- =============================================================
-- Forward Declarations
-- =============================================================
local onBackTouch
local createPlayer
local spawnEnemy

-- =============================================================
-- Module Begins
-- =============================================================
local public = {}

function public.run()

	-- Create background we can use as our 'input' catcher
	local back = display.newImageRect( "images/protoBackX.png", 720, 1386 )
	back.x = centerX
	back.y = centerY
	back.rotation = 90
	back.touch = onBackTouch
	back:addEventListener( "touch" )


	-- Create a player that just sits in center of screen and faces enemy if found.
	-- It also fires in the direction it is facing when you click the screen.
	createPlayer() 

	-- Spawn enemies forever.
	-- Only one allowed at a time
	-- When destroyed, we will make a new one.
	timer.performWithDelay( 100, spawnEnemy, -1)

end


-- ==
--
-- ==
onBackTouch = function( self, event )
	--table.dump(event)

	-- No player yet? Ignore touch.
   if( not player ) then return end

   -- Only do work in 'began' phase.
   if( event.phase ~= "began" ) then return false end
   
   -- Make a bullet at player location, rotate it in same direction as player, 
   -- add a body, add an 'isA' flag for our collision logic, calculate a 
   -- movement vector, and move it.
   -- Then, use a hack to destroy the bullet in 3 seconds if it 'misses'.
   --
   local bullet = display.newImageRect( "images/bullet.png", 20, 20 )
   bullet.x = player.x
   bullet.y = player.y
   bullet.rotation = player.rotation
   physics.addBody( bullet, "dynamic", { radius = 10, filter = myCC:getCollisionFilter( "pbullet" ) } )
   bullet.isA = "bullet"

   -- Movement vector calculation.
   local vec = angle2Vector( player.rotation, true )
   vec = scaleVec( vec, bulletSpeed )
   
   -- Ssart moving
   bullet:setLinearVelocity( vec.x, vec.y )
   
   -- 
   -- Hack to delete bullet in 3 seconds
   transition.to( bullet, { alpha = 0, delay = 3000, time = 0, onComplete = display.remove } )

   return true
end

-- ==
--    Player builder function.
-- ==
createPlayer = function()
	-- Put player in center of screen, add 'isA' marker for our game logic,
	-- add a body, provide an enterFrame listener, and start it.
	--
   player = display.newImageRect( "images/dude.png", 50, 50 )
   player.x = centerX   
   player.y = centerY
   player.isA = "player"
   --
   physics.addBody( player, "kinematic", { radius = 25, filter = myCC:getCollisionFilter( "player" ) } )   

   -- Listener runs every frame and faces enemy if one is found.
   --
   player.enterFrame = function( self )
   	if( enemy == nil  ) then  return  end
      --
      -- Get vector from player to enemy
      local vec = diffVec( self, enemy )

      -- Get angle of vector and assign as player's rotation to always face enemy
      self.rotation = vector2Angle( vec )
   end
   Runtime:addEventListener( "enterFrame", player )
end

-- ==
--    Enemy builder function.
-- ==
spawnEnemy = function()
   -- Already got an enemy?  Exit early
	if( enemy ~= nil ) then return end

	-- Create enemy at random position on left side of  screen,
	-- mark it with 'isA' flag for collision logic, 
	-- give it 10 hitpoints, add a body, ensure body can't rotate (try without to see what happens),
	-- add a collision event listener, add a move target selection and mover helper function.
	-- 
	-- 
	enemy = display.newImageRect( "images/enemy.png", 50, 50 )
   enemy.x = left + 50
   enemy.y = mRand( top + 50, bottom - 50 )
   enemy.isA = "enemy"
   enemy.hitpoints = 10
   --
   physics.addBody( enemy, "dynamic", { radius = 25, filter = myCC:getCollisionFilter( "enemy" ) } )   
   enemy.isFixedRotation = true

   -- This listener only does work in 'began' phase, 
   --
   -- If 'other' is player, we destroy the enemy immediately and mark the player with a 
   -- temporary color 'flash'.
   --
   -- If 'other' is a bullet, we chooe a new move target and start moving again after a short delay.
   -- We also reduce hitpoints.  If enemy hitpoints are <= 0 we destroy it, otherwise lower the alpha
   -- as poor mans damage indicator.
   --
   function enemy.collision( self, event )
   	--table.dump(event)
   	local other = event.other
   	local phase = event.phase
   	--
   	if( phase ~= "began" ) then return false end
   	
   	-- Hit player.  Destroy enemy immediatly and 'flash' player
   	-- Also shake screen.
   	if( other.isA == "player" ) then
   		ssk.misc.easyShake( display.currentStage, 20, 1000 )
   		--
   		player:setFillColor( 1, 0, 0 )
   		timer.performWithDelay( 500, function() player:setFillColor( 1, 1, 1 ) end )
   		--
   		self.destroyed = true
	   	display.remove( self )
	   	enemy = nil 
   	
   	-- Hit by bullet?
   	-- shake a little
   	-- subtract hit points
   	-- destroy at zero hit points or lower alpha by percent of total HP
   	elseif( other.isA == "bullet" ) then
   		ssk.misc.easyShake( display.currentStage, 5, 500 )
   		--
   		self.hitpoints = self.hitpoints - 1
   		if( self.hitpoints <= 0 ) then
   			self.destroyed = true
		   	display.remove( self )
		   	enemy = nil 
		   else
		   	-- Update alpha to reflect damage.
		   	self.alpha = self.hitpoints/10

		   	-- If we are already waiting to restart movement, cancel old
		   	-- timer, then start new one.
		   	if( self.lastTimer ) then 
		   		timer.cancel( self.lastTimer )
		   	end
				self.lastTimer = timer.performWithDelay( 750,
				function()
					self.lastTimer = nil
					self:selectMoveTargetAndMove()
				end )
			end   		
	   	-- Always destroy bullet
	   	display.remove(other)
   	end
   end
   enemy:addEventListener("collision")
   
   -- Calculate vector to player and move toward player at fixed rate.
   function enemy.selectMoveTargetAndMove( self )
   	-- Catch case where this function is called (as the result
   	-- of a timer) after the object was destroyed:
   	if( type(self.removeSelf) ~= "function" ) then return end
   	--
		local moveVec = diffVec( self, player )
		local moveVec = normVec( moveVec )
		moveVec = scaleVec( moveVec, enemySpeed )
		--
   	self:setLinearVelocity( moveVec.x, moveVec.y )
   end

   -- Start enemy moving.
   enemy:selectMoveTargetAndMove()
   
   return false
 end

return public



