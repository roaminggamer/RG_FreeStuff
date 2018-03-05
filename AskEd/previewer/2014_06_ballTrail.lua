-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local root 	  = "answerpath"
local baseDir = system.DocumentsDirectory
-- =============================================================
local hCommon		= require "scripts.common" -- Harness Common

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua Functions
local getTimer          = system.getTimer
local mRand					= math.random
local mAbs					= math.abs
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
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale

local RGTiled = ssk.tiled
local newText = display.newText

-- =============================================================
-- Locals
-- =============================================================
local layers
local lastTimer
local isRunning 
local speed 			= 150 -- in pixels-per-second
local turnEvery		= 3 -- Turn every time the (counter % this value)  == 0
local trailEvery		= 5 -- Add trail point every time the (counter % this value)  == 0
local turnByDegrees	= 35

local ballRadius 		= 15
local trailRadius 	= 5


-- =============================================================
-- Module Begins
-- =============================================================
local game = {}

function game.create( group, params )
	group = group or display.currentStage
	params = params or {}
	--
	isRunning = false
	--
	display.remove( layers )
	--
	layers = quickLayers( group, "background", "content", "enemies", "player", "interfaces" )

	local drawBall
	local onFinalize
	local onEnterFrame
	local drawTrail
	local drawTrail2
	local drawTrail3

	-- Definitions
	drawBall = function( )
		local myColor = { mRand(20,100)/100, mRand(20,100)/100, mRand(20,100)/100 }
		
		local tmp = newCircle( layers.content, centerX, centerY, 
			                   { rotation = mRand(0,359), 
			                     radius = ballRadius, fill = myColor } )	
		tmp.myColor 	= myColor
		tmp.lastTime 	= getTimer()
		tmp.myCount  	= 0

		-- Randomly choose trail drawing function	
		local trailFunctions = { drawTrail, drawTrail2, drawTrail3 }
		tmp.drawTrail = trailFunctions[math.random(1,3)]

		tmp.enterFrame 	= onEnterFrame
		listen( "enterFrame", tmp )

		tmp.finalize 	= onFinalize
		tmp:addEventListener("finalize")

		timer.performWithDelay( 10000, 
			function()			
				if( not isValid( tmp ) ) then return end
				transition.to( tmp, { alpha = 0, time = 2000, onComplete = display.remove })
			end )
		timer.performWithDelay( 11800, 
			function()
				if( not isValid( tmp ) ) then return end
				ignore( "enterFrame", tmp )
			end )

	end

	onFinalize = function( self )
		ignoreList( { "enterFrame" }, self )
	end

	onEnterFrame = function( self, event )
		if( not isRunning ) then return end
		local curTime = getTimer()
		local dt      = curTime - self.lastTime
		self.lastTime = curTime

		self.myCount = self.myCount + 1
		-- Move the ball by a calculated amount in the current 'facing' direction
		local vec = angle2Vector( self.rotation, true ) 
		vec = normVec( vec )
		local dist = (dt * speed) / 1000
		vec = scaleVec( vec, dist )

		self.lx = self.x -- x before move (useful for non-basic trails)
		self.ly = self.x -- y before move (useful for non-basic trails)
		self.x = self.x + vec.x
		self.y = self.y + vec.y

		-- Turn?
		if( self.myCount % turnEvery == 0 ) then
			self.rotation = self.rotation + mRand( -turnByDegrees, turnByDegrees ) -- small turns only
		end


		-- Add trail point?
		if( self.myCount % trailEvery == 0 ) then
			self:drawTrail( self )
		end

	end

	-- Basic Trail
	drawTrail = function( obj )
		local tmp = newCircle( layers.content, obj.x, obj.y,
			{ radius = trailRadius })	
		tmp.fill = { type="image", filename="images/askEd/chalk.png" }
		tmp:setFillColor( unpack( obj.myColor ) )

		transition.to( tmp, { delay = 5000, time = 1000, alpha = 0, onComplete = display.remove })
		obj:toFront()
	end


	-- Line Trail with Gaps
	drawTrail2 = function( obj )
		if( not obj.last ) then
			obj.last = {x = obj.x, y = obj.y, rotation = obj.rotation}
			return
		end

		local tmp = newRect( layers.content, obj.last.x, obj.last.y, 
			{ w = 7, h = 12, rotation = obj.last.rotation } )	
		tmp.fill = { type="image", filename="images/askEd/chalk.png" }
		tmp:setFillColor( unpack( obj.myColor ) )
		obj.last = nil

		transition.to( tmp, { delay = 5000, time = 1000, alpha = 0, onComplete = display.remove })
		obj:toFront()
	end

	-- Footprint Trail with Gaps
	drawTrail3 = function( obj )
		if( not obj.last ) then
			obj.last = {x = obj.x, y = obj.y, rotation = obj.rotation}
			return
		end
		local tmp = newRect( layers.content, obj.x, obj.y, 
			{ size = 15, rotation = obj.rotation } )	
		tmp.fill = { type="image", filename="images/askEd/dog.png" }
		tmp:setFillColor( unpack( obj.myColor ) )

		transition.to( tmp, { delay = 5000, time = 1000, alpha = 0, onComplete = display.remove })
		obj:toFront()

		local tmp = newRect( layers.content, obj.last.x, obj.last.y, 
			{ size = 15, rotation = obj.last.rotation } )	
		tmp.fill = { type="image", filename="images/askEd/dog.png" }
		tmp:setFillColor( unpack( obj.myColor ) )
		tmp.xScale = -1

		obj.last = nil

		transition.to( tmp, { delay = 5000, time = 1000, alpha = 0, onComplete = display.remove })
		obj:toFront()

	end

	-- The Test
	drawBall()

	lastTimer = timer.performWithDelay( 1500, function() drawBall() end, -1)


end

function game.start()
	isRunning = true
end

function game.stop()
	isRunning = false
end

function game.destroy()
	game.stop()
	--
	if( lastTimer ) then
		timer.cancel(lastTimer)
		lastTimer = nil
	end	
	--
	display.remove( layers )
	layers = nil
end

return game



