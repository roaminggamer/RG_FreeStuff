-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- seeking_projectile.lua (comments/code)
-- =============================================================
local turrets = {}
-- =============================================================
-- =============================================================
-- =============================================================
-- Useful Localizations
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local mRand				= math.random
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale

-- =============================================================
-- =============================================================
-- =============================================================

-- Forward declarations
--
local fireBullet
local createTurret
local createWalls

-- Locals
--
local myCC
local layers
local theTurret
local enemy
local turnRate


-- =============================================================
-- Create a simple turret that rotates side-to-side continuously
-- =============================================================
function turrets.createTurret( x, y, aimRate )
	local turret = newImageRect( layers.content, x, y, "images/arrow.png", { size = 100 } )

	return turret
end

-- =============================================================
-- Create a simple turret that rotates side-to-side continuously
-- =============================================================
function turrets.createEnemy( )
	enemy = newImageRect( layers.content, left + 100, top + 200, "images/rg256.png", { size = 80 } )
	function enemy.onComplete( self )
		transition.to( self, { x = centerX + mRand( -600, 600), y = centerY + mRand( -600, 300), time = mRand( 500, 1500 ), onComplete = self} )
	end
	enemy:onComplete()
end



-- =============================================================
-- Fire a bullet from the tip of the turret in the direction it is facing
-- =============================================================
function turrets.fireBullet( event )
	if( event.phase == "began" ) then
		local pVec = angle2Vector( theTurret.rotation, true )
		local fVec = table.shallowCopy(pVec)

		pVec = scaleVec( pVec, theTurret.height/2 )
		pVec = addVec( pVec, theTurret )

		local bullet = newImageRect( layers.content, pVec.x, pVec.y, "images/arrow.png",
								  { radius = 10, fill = _G_, rotation = theTurret.rotation },
								  { radius = 10, calculator = myCC, colliderName = "pbullet", bounce = 0.5,
								     linearDamping = 1 } )
		fVec = scaleVec( fVec, 1000 )
		bullet:setLinearVelocity( fVec.x, fVec.y )
	
		function bullet.enterFrame( self )
			-- No enemy?  Pause the facing algorithm
			--
			if( not enemy ) then 
				ssk.actions.face( self, { doPause = true } )
			end

			-- Aim at current position of enemy at aimRate 
			--
			ssk.actions.face( self, { target = enemy, rate = turnRate } )

			-- Draw aim-line for visual feedback
			--
			display.remove(self.aimLine)
			local vec = angle2Vector( self.rotation, true )
			vec = scaleVec( vec, 200 )
			vec = addVec( vec, self )
			self.aimLine = display.newLine( layers.content, self.x, self.y, vec.x, vec.y )
			self.aimLine.strokeWidth = 2
			self.aimLine:toBack()

			-- Thrust forward, trying to hit the enemy
			ssk.actions.movep.thrustForward( bullet, { rate = 500 })
			ssk.actions.movep.limitV( bullet, { rate = 200 })

			-- Leave a trail behind to make this example easier to see
			if( not self.trail ) then
				self.trail = display.newGroup()
				layers.content:insert( self.trail )
				self.trail:toBack()
			end
			local tmp = newCircle( self.trail, self.x, self.y, { radius = 5, fill = _T_, stroke = _P_ } )
			transition.to( tmp, { alpha = 0, time = 1000, onComplete = display.remove } )

		end; listen( "enterFrame", bullet )

		-- When transition ends, stop listening for enterFrame and destroy bullet
		function bullet.onComplete( self )
			ignore("enterFrame", self )
			display.remove(self.aimLine)
			display.remove(self.trail)
			display.remove(self)
		end
		transition.to( bullet, { alpha = 0, time = 100, delay = 10000, onComplete = bullet } )


	end


end

-- =============================================================
-- 
-- =============================================================
function turrets.runDemo( group, aimRate )
	group = group or display.currentStage

	-- Set the projectile turn/aim rate
	--
	turnRate  = aimRate

	-- Set up physics
	--
	local physics = require "physics"
	physics.start()
	physics.setGravity(0,0)
	physics.setDrawMode("hybrid")

	-- Create a collision calculator and configure it
	--
	myCC = ssk.cc:newCalculator()
	myCC:addNames( "player", "enemy",  "pbullet", "ebullet", "trigger", "wall" )
	myCC:collidesWith( "player", { "enemy" , "ebullet", "trigger", "wall"  } )
	myCC:collidesWith( "enemy", { "player", "pbullet", "wall",   } )
	myCC:collidesWith( "pbullet", { "wall" } )
	myCC:collidesWith( "ebullet", { "wall" } )

	-- Set up some rendering layers
	--
	layers = quickLayers( group, "background", "world", { "content" } )

	-- Create kernel demo contents
	--
	ssk.easyInputs.oneTouch.create( layers.background, { debugEn = true, keyboardEn = true })

	turrets.createEnemy()
	
	theTurret = turrets.createTurret( centerX, bottom - 100 )

	listen( "onOneTouch", turrets.fireBullet)

end


return turrets
