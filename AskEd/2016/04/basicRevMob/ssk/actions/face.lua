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


local lastTime = {}


actions.face = function( obj, params )
	if( not isValid( obj ) )then return end	

	-- Extract some possible parameters
	local target = params.target or obj._target 
	local angle  = params.angle
	local doPause = params.pause

	-- Once started, face must be called every frame, but
	-- you can pause the face action any time, to avoid 
	-- the following heavy calculations.
	--
	if(doPause) then 
		obj.__last_face_time = getTimer()
		return
	end

	target = isValid( target ) and target or { x = params.x or 0, y = params.y or 0 }

	-- Face target 'immediately'
	if( params.rate == nil ) then
		if( angle == nil ) then
			local vec = subVec( obj, target )
			angle = vector2Angle( vec )
		end
		obj.rotation = angle
	
	-- Face target at rate (degrees per second)
	else
		local curTime = getTimer()
		if( not obj.__last_face_time ) then
			obj.__last_face_time = curTime
		end
		local dt = curTime - obj.__last_face_time
		obj.__last_face_time = curTime
		
		local dps = params.rate or 180
		local rate = params.rate * dt / 1000	

		local targetAngle = angle or vector2Angle( subVec( obj, target ) )

		local deltaAngle = mFloor((targetAngle - obj.rotation) + 0.5)
		deltaAngle =  (deltaAngle + 180) % 360 - 180

		if( mAbs( deltaAngle ) <= rate ) then
			obj.rotation = targetAngle
		elseif( deltaAngle > 0 ) then
			obj.rotation = obj.rotation + rate
		else
			obj.rotation = obj.rotation - rate
		end

		if( obj.rotation < 0 ) then obj.rotation = obj.rotation + 360 end
		if( obj.rotation >= 360 ) then obj.rotation = obj.rotation - 360 end		
	end
end
