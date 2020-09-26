-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Actions Library - Target Acquisition Functions
-- =============================================================
local target = {}
_G.ssk.actions = _G.ssk.actions or {}
_G.ssk.actions.target = target


-- Forward Declarations
local angle2Vector      = ssk.math2d.angle2Vector
local vector2Angle      = ssk.math2d.vector2Angle
local scaleVec          = ssk.math2d.scale
local addVec            = ssk.math2d.add
local subVec            = ssk.math2d.sub
local getNormals        = ssk.math2d.normals
local lenVec            = ssk.math2d.length
local len2Vec           = ssk.math2d.length2
local normVec           = ssk.math2d.normalize

local fnn 				= _G.fnn
local isValid 			= display.isValid

-- Lua and Corona
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getTimer          = system.getTimer

--
-- Utility Functions
--
-- Set the target manually
target.set = function( obj, newTarget )
	if( not isValid( obj ) ) then return end
	obj._target = newTarget
end

-- Get the target manually
target.get = function( obj )	
	return obj._target
end

--
-- Actions 
--
target.loseOnDestroyed = function( obj )
	-- Has valid target?  Exit now.
	if( not obj._target.removeSelf ) then 
		obj._target = nil		
	end

	return obj._target == nil
end	

target.loseAtMaxDistance = function( obj, params )
	local maxDist = params.maxDist or math.huge
	local targets = params.targets

	maxDist = maxDist ^ 2

	local dist = subVec( obj, obj._target )
	dist = len2Vec( dist )

	if( dist >= maxDist ) then 
		obj._target = nil
	end

	return obj._target == nil
end

target.loseAtMinAlpha = function( obj, params )
	-- If alpha below 'minAlpha' lose this target
	if( obj._target.alpha <= (params.alpha or 0.5) ) then 
		obj._target = nil
	end
	return obj._target == nil
end

target.loseNotVisible = function( obj )
	-- If not visible, lose this target
	if( obj._target.isVisible == false) then 
		obj._target = nil
	end
	return obj._target == nil
end

-- Acquire nearest target from queue
target.acquireNearest = function( obj, params )
	if( not isValid( obj ) ) then return end

	if( not params or not params.targets ) then return end

	obj._target = nil
	
	local maxDist = params.maxDist or math.huge
	local targets = params.targets

	maxDist = maxDist ^ 2

	local newTarget
	local dist
	local pairs = pairs
	
	for k,v in pairs( targets ) do
		if( isValid( v ) and not v._targeter ) then
			dist = subVec( obj, v )
			dist = len2Vec( dist )
			if( dist <= maxDist ) then
				maxDist = dist
				newTarget = v
			end
		end
	end

	obj._target = newTarget

	return (obj._target ~= nil)
end


-- Acquire nearest target from queue
target.acquireRandom = function( obj, params )
	if( not isValid( obj ) ) then return end

	if( not params or not params.targets ) then return end

	obj._target = nil
	
	local targets = params.targets

	local tmpTargets = {}
	if(#targets > 0) then
		tmpTargets = targets
	else
		for k,v in pairs( targets ) do
			tmpTargets[#tmpTargets+1] = v 
		end
	end

	obj._target = table.getRandom( tmpTargets )

	return (obj._target ~= nil)
end

--
-- Debug Actions
--

-- Draw line between object and target if there is one
target.drawDebugLine = function( obj, params )
	if( not isValid( obj ) ) then return end
	params = params or {}

	if( obj._lastline ) then display.remove( obj._lastline ) end

	local group = params.parent or display.currentStage

	obj._lastline = display.newLine( group, obj.x, obj.y, obj._target.x, obj._target.y )
	obj._lastline:toBack()
	obj._lastline.timer = function( self ) display.remove(self) end 
	timer.performWithDelay( 1, obj._lastline  )
end


-- Print current distance to
target.drawDebugDistanceLabel = function( obj, params )
	if( not isValid( obj ) ) then return end
	params = params or {}

	if( obj._lasttext ) then display.remove( obj._lasttext ) end

	local dist = subVec( obj, obj._target )

	dist = lenVec( dist )
	dist = mFloor( dist + 0.5 )

	local group = params.parent or display.currentStage

	obj._lasttext = display.newText( group, round(dist), obj.x, obj.y, native.systemFont, 14 )

	obj._lasttext.x = obj.x + (params.xOffset or 0)
	obj._lasttext.y = obj.y + (params.yOffset or 0)

	obj._lasttext.timer = function( self ) display.remove(self) end 
	timer.performWithDelay( 1, obj._lasttext  )
end


-- Print current distance to
target.drawDebugAngleDistanceLabel = function( obj, params )
	if( not isValid( obj ) ) then return end
	params = params or {}

	if( obj._lasttext ) then display.remove( obj._lasttext ) end

	local dist = subVec( obj, obj._target )

	dist = lenVec( dist )
	dist = mFloor( dist + 0.5 )

	local group = params.parent or display.currentStage

	local targetAngle = subVec( obj, obj._target )
	targetAngle = vector2Angle( targetAngle )

	local angle = mFloor((targetAngle - obj.rotation) + 0.5)
	angle =  (angle + 180) % 360 - 180

	obj._lasttext = display.newText( group, "< a:" .. round(angle) .. ", d:" .. round(dist) .. " >", obj.x, obj.y, native.systemFont, 14 )

	obj._lasttext.x = obj.x + (params.xOffset or 0)
	obj._lasttext.y = obj.y + (params.yOffset or 0)

	obj._lasttext.timer = function( self ) display.remove(self) end 
	timer.performWithDelay( 1, obj._lasttext  )
end


return target