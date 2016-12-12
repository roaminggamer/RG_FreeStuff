-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  rotating_turret.lua (comments/code)
-- =============================================================

-- =============================================================
-- KERNEL CODE BEGINS BELOW
-- =============================================================

local turrets = {}
-- =============================================================
-- =============================================================
-- =============================================================
-- Useful Localizations
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local mRand					= math.random
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


-- =============================================================
-- Create a simple turret that rotates side-to-side continuously
-- =============================================================
function turrets.createTurret( x, y )
	local turret = newImageRect( layers.content, x, y, "images/arrow.png", { size = 100, rotation = -60, stroke = _W_ } )
	function turret.rotateLeft( self )
		transition.to( self, { rotation = -60, time = 2000, onComplete = self.rotateRight } )
	end
	function turret.rotateRight( self )
		transition.to( self, { rotation = 60, time = 2000, onComplete = self.rotateLeft } )
	end
	turret:rotateRight()
	return turret
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

		local bullet = newCircle( layers.content, pVec.x, pVec.y, 
								  { radius = 10, fill = _G_ },
								  { calculator = myCC, colliderName = "pbullet", bounce = 0.5 } )
		fVec = scaleVec( fVec, 1000 )
		bullet:setLinearVelocity( fVec.x, fVec.y )
		transition.to( bullet, { alpha = 0, time = 100, delay = 3000, onComplete = display.remove } )
	end
end

-- =============================================================
-- Create some walls for out bullet to bounce off of
-- =============================================================
function turrets.createWalls( )
	local lwall = newRect( layers.content, left, centerY, 
						  { w = 40, h = fullh, anchorX = 0, fill = _O_ },
						  { bodyType = "static", calculator = myCC, colliderName = "wall", bounce = 0.5 } )
	local rwall = newRect( layers.content, right, centerY, 
						  { w = 40, h = fullh, anchorX = 1, fill = _O_ },
						  { bodyType = "static", calculator = myCC, colliderName = "wall", bounce = 0.5 } )

	local twall = newRect( layers.content, centerX, top, 
						  { w = fullw, h = 40, anchorY = 0, fill = _O_ },
						  { bodyType = "static", calculator = myCC, colliderName = "wall", bounce = 0.5 } )

	local bwall = newRect( layers.content, centerX, bottom, 
						  { w = fullw, h = 40, anchorY = 1, fill = _O_ },
						  { bodyType = "static", calculator = myCC, colliderName = "wall", bounce = 0.5 } )

end

-- =============================================================
-- 
-- =============================================================
function turrets.runDemo( group )
	group = group or display.currentStage

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
	
	theTurret = turrets.createTurret( centerX, bottom - 100 )
	
	turrets.createWalls()

	listen( "onOneTouch", turrets.fireBullet)



end


return turrets
