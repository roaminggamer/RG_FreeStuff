-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Actions Library - Move via Physics Functions
-- =============================================================
local movep = {}
_G.ssk.actions = _G.ssk.actions or {}
_G.ssk.actions.movep = movep

-- Forward Declarations
-- SSK
local angle2Vector      = ssk.math2d.angle2Vector
local vector2Angle      = ssk.math2d.vector2Angle
local scaleVec          = ssk.math2d.scale
local addVec            = ssk.math2d.add
local subVec            = ssk.math2d.sub
local diffVec           = ssk.math2d.diff
local getNormals        = ssk.math2d.normals
local lenVec            = ssk.math2d.length
local len2Vec           = ssk.math2d.length2
local normVec           = ssk.math2d.normalize

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


-- Dampen vertical velocity ONLY
movep.dampVert = function( obj, params )
	if( not isValid( obj ) ) then return end

	local vx,vy = obj:getLinearVelocity()

	local dRate = vy * (params.damping or 1)/50
	vy = vy - dRate

	obj:setLinearVelocity( vx, vy )
end

-- Dampen horizontal velocity ONLY
movep.dampHoriz = function( obj, params )
	if( not isValid( obj ) ) then return end

	local vx,vy = obj:getLinearVelocity()

	local dRate = vx * (params.damping or 1)/50
	vx = vx - dRate

	obj:setLinearVelocity( vx, vy )
end

-- Dampen vertical velocity in the downward direction only
movep.dampDown = function( obj, params )
	if( not isValid( obj ) ) then return end

	local vx,vy = obj:getLinearVelocity()

	if( vy <= 0 ) then return end

	local dRate = vy * (params.damping or 1)/25

	if( dRate < 0.0001 ) then return end
	
	vy = vy - dRate

	obj:setLinearVelocity( vx, vy )
end

-- Limit object's linear velocity
movep.limitV = function( obj, params )
	if( not isValid( obj ) ) then return end

	local vx,vy = obj:getLinearVelocity()
	local rate 	= params.rate or 100

	if(len2Vec( vx, vy ) <= ( rate ^ 2) ) then return end

	local vec = normVec({ x = vx, y = vy } )
	vec = scaleVec( vec, rate )
	obj:setLinearVelocity( vec.x, vec.y )
end

-- Limit object's angular velocity
movep.limitAV = function( obj, params )
	if( not isValid( obj ) ) then return end

	local av = obj.angularVelocity
	local rate 	= params.rate or 180

	if(mAbs(av) > rate) then
		obj.angularVelocity = (av>0) and rate or -rate
	end
end

-- Move object forward at fixed velocity
movep.forward = function( obj, params )
	if( not isValid( obj ) ) then return end
	params = params or {}

	local curTime = getTimer()
	if( not obj.__last_forward_time ) then
		obj.__last_forward_time = curTime
	end
	local dt = curTime - obj.__last_forward_time
	obj.__last_forward_time = curTime

	local rate = params.rate or 100

	local v = angle2Vector( obj.rotation, true )
	v = scaleVec( v, rate )

	obj:setLinearVelocity( v.x, v.y )
end


-- Move object forward at fixed velocity
movep.thrustForward = function( obj, params )
	if( not isValid( obj ) ) then return end
	params = params or {}

	local curTime = getTimer()
	if( not obj.__last_thrust_forward_time) then
		obj.__last_thrust_forward_time = curTime
	end
	local dt = curTime - obj.__last_thrust_forward_time
	obj.__last_thrust_forward_time = curTime

	local rate = params.rate or 100

	if( not params.ignoreMass ) then
		rate = rate * obj.mass
	end

	local v = angle2Vector( obj.rotation, true )
	v = scaleVec( v, rate )
	obj:applyForce( v.x, v.y, obj.x, obj.y )
end

-- Move object forward at fixed velocity
movep.impulseForward = function( obj, params )
	if( not isValid( obj ) ) then return end
	params = params or {}

	local mag = params.mag or 1

	if( not params.ignoreMass ) then
		mag = mag * obj.mass
	end	

	local v = angle2Vector( obj.rotation, true )
	v = scaleVec( v, mag )
	obj:applyLinearImpulse( v.x, v.y, obj.x, obj.y )
end


-- Move object toward an angle or object
movep.toward = function( obj, params )
	if( not isValid( obj ) ) then return end
	params = params or {}
	local curTime = getTimer()
	if( not obj.__last_forward_time ) then
		obj.__last_forward_time = curTime
	end
	local dt = curTime - obj.__last_forward_time
	obj.__last_forward_time = curTime

	local rate = params.rate or 100

	local v
	if(params.angle) then		
		v = angle2Vector( params.angle, true )
	else
		v = diffVec( obj, params.target )
		v = normVec( v )
	end
	v = scaleVec( v, rate )

	obj:setLinearVelocity( v.x, v.y )
end

-- Thrust object toward an angle or object
movep.thrustToward = function( obj, params )
	if( not isValid( obj ) ) then return end
	params = params or {}

	local curTime = getTimer()
	if( not obj.__last_thrust_forward_time) then
		obj.__last_thrust_forward_time = curTime
	end
	local dt = curTime - obj.__last_thrust_forward_time
	obj.__last_thrust_forward_time = curTime

	local rate = params.rate or 100

	if( not params.ignoreMass ) then
		rate = rate * obj.mass
	end

	local v
	if(params.angle) then		
		v = angle2Vector( params.angle, true )
	else
		v = diffVec( obj, params.target )
		v = normVec( v )
	end

	v = scaleVec( v, rate )
	obj:applyForce( v.x, v.y, obj.x, obj.y )
end

return movep
