-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Actions Library
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
_G.ssk.actions = _G.ssk.actions or {}
local actions
actions = _G.ssk.actions

local movep
if( not actions.movep ) then
	actions.movep = {}
end
movep = actions.movep

-- Forward Declarations
-- SSK
local angle2Vector      = ssk.math2d.angle2Vector
local vector2Angle      = ssk.math2d.vector2Angle
local scaleVec          = ssk.math2d.scale
local addVec            = ssk.math2d.add
local subVec            = ssk.math2d.sub
local getNormals        = ssk.math2d.normals
local lenVec            = ssk.math2d.length
local lenVec2           = ssk.math2d.length2
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


-- Limit object's linear velocity
movep.limitV = function( obj, params )
	if( not isValid( obj ) ) then return end

	local vx,vy = obj:getLinearVelocity()
	local rate 	= params.rate or 100

	if(lenVec2( vx, vy ) <= ( rate ^ 2) ) then return end

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


local lastThrustForwardTime = {}
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

	rate = rate * obj.mass

	local v = angle2Vector( obj.rotation, true )
	v = scaleVec( v, rate )
	obj:applyForce( v.x, v.y, obj.x, obj.y )
end



--[[


local function atPixelsPerFrame( obj, params )
	if( not isValid( obj ) ) then return end

	obj:translate( params.x, params.y )
end

local function atPixelsPerSecond( obj, params )
	if( not isValid( obj ) ) then return end

	local curTime = getTimer()
	if( not obj._lastMoveTime ) then
		obj._lastMoveTime = curTime
	end

	local rate = (curTime - obj._lastMoveTime) / 1000	
	obj:translate( params.x * rate, params.y * rate )

	obj._lastMoveTime = curTime
end

local function atVelocity( obj, params )
	if( not isValid( obj ) ) then return end

	obj:setLinearVelocity( params.x, params.y )
end

local function byForce( obj, params )
	if( not isValid( obj ) ) then return end

	obj:applyForce( params.x, params.y, obj.x, obj.y )
end


local function forwardAtPixelsPerFrame( obj, params )
	if( not isValid( obj ) ) then return end

	local vec = angle2Vector( obj.rotation, true )
	vec = scaleVec( vec, params.rate )
	obj:translate( vec.x, vec.y )
end

local function forwardAtPixelsPerSecond( obj, params )
	if( not isValid( obj ) ) then return end

	local curTime = getTimer()
	if( not obj._lastMoveTime ) then
		obj._lastMoveTime = curTime
	end

	local rate = params.rate * (curTime - obj._lastMoveTime) / 1000	

	local vec = angle2Vector( obj.rotation, true )
	obj:translate( vec.x * rate, vec.y * rate )

	obj._lastMoveTime = curTime
end

local function forwardAtVelocity( obj, params )
	if( not isValid( obj ) ) then return end

	local vec = angle2Vector( obj.rotation, true )
	vec = scaleVec( vec, params.rate)
	obj:setLinearVelocity( vec.x, vec.y )
end

local function forwardByForce( obj, params )
	if( not isValid( obj ) ) then return end

	local vec = angle2Vector( obj.rotation, true )
	vec = scaleVec( vec, params.magnitude )
	obj:applyForce( vec.x, vec.y, obj.x, obj.y )
end


--
-- Expose Module
--
local public = {}
public.limitVelocity 		= limitVelocity

public.atPixelsPerFrame 	= atPixelsPerFrame
public.atPixelsPerSecond 	= atPixelsPerSecond
public.atVelocity 			= atVelocity
public.byForce 				= byForce


public.forwardAtPixelsPerFrame  	= forwardAtPixelsPerFrame
public.forwardAtPixelsPerSecond 	= forwardAtPixelsPerSecond
public.forwardAtVelocity 			= forwardAtVelocity
public.forwardByForce 				= forwardByForce

return public
--]]