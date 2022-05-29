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

local move
if( not actions.move ) then
	actions.move = {}
end
move = actions.move

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



-- Limit the bounds within with object may move
move.limit = function( obj, params )
end

-- Limit the radial bounds within with object may move
move.limitr = function( obj, params )
end

local lastForwardTime = {}
-- Move object forward at fixed rate
move.forward = function( obj, params )
	if( not isValid( obj ) ) then return end
	params = params or {}

	local curTime = getTimer()
	if( not lastForwardTime[obj]) then
		lastForwardTime[obj] = curTime
	end
	local dt = curTime - lastForwardTime[obj]
	lastForwardTime[obj] = curTime

	local pps = params.rate or 100
	local rate = pps * dt/1000

	local v = angle2Vector( obj.rotation, true )
	v = scaleVec( v, rate )
	obj:translate( v.x, v.y )
end


-- Move object in x,y direction at fixed rate per-second or per-frame
move.at = function( obj, params )
	if( not isValid( obj ) ) then 
		return 
	end
	params = params or {}

	local perSecond = not params.perFrame -- set this to true to move perFrame

	local x  = params.x or 0
	local y  = params.y or 0

	if( perSecond ) then
	
	local curTime = getTimer()
	if( not obj.__last_move_at_time) then
		obj.__last_move_at_time = curTime
	end
	local dt = curTime - obj.__last_move_at_time
	obj.__last_move_at_time = curTime
		x = x * dt/1000
		y = y * dt/1000
		obj:translate( x, y )
	else
		obj:translate( x, y )
	end
end

