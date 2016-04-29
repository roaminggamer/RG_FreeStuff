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
local rcIntersect		= ssk.math2d.rcIntersect

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

-- Safety check; Skip action processing if any of these tests is false
local function skip( obj )
	return ( obj == nil or obj.removeSelf == nil )
end

actions.rectWrap = function( objectToWrap, wrapRectangle )
	local right = wrapRectangle.x + wrapRectangle.contentWidth / 2
	local left  = wrapRectangle.x - wrapRectangle.contentWidth / 2

	local top = wrapRectangle.y - wrapRectangle.contentHeight / 2
	local bot  = wrapRectangle.y + wrapRectangle.contentHeight / 2

	if(objectToWrap.x >= right) then
		objectToWrap.x = left + objectToWrap.x - right
	elseif(objectToWrap.x <= left) then 
		objectToWrap.x = right + objectToWrap.x - left
	end

	if(objectToWrap.y >= bot) then
		objectToWrap.y = top + objectToWrap.y - bot
	elseif(objectToWrap.y <= top) then 
		objectToWrap.y = bot + objectToWrap.y - top
	end
end


actions.circWrap = function( objectToWrap, point, radius )
	if( not objectToWrap._rx ) then
		objectToWrap._rx = objectToWrap.x
		objectToWrap._ry = objectToWrap.y
	end
	
	local errorMargin = 0.01
	local x, y, rx, ry = objectToWrap.x, objectToWrap.y, objectToWrap._rx, objectToWrap._ry
	local vec = subVec( rx, ry, x, y, true )		
	local len2 = lenVec2( vec )
	if( len2 <= errorMargin ) then return end 

	-- If we're less than radius from center, skip all subsequent calculations
	local ox, oy = x - point.x, y - point.y
	if(lenVec2(ox,oy) < radius * radius) then
		objectToWrap._rx = objectToWrap.x
		objectToWrap._ry = objectToWrap.y
		return 
	end

	vec = normVec(vec)
	local nx, ny = vec.x, vec.y
	vec = scaleVec( vec, radius * -3)

	local x2,y2 = addVec( x, y, vec.x, vec.y )
	
	local cx, cy = point.x, point.y

	local v1, v2 = rcIntersect( x, y, x2, y2, cx, cy, radius )

	objectToWrap._rx = objectToWrap.x
	objectToWrap._ry = objectToWrap.y

	if(v1) then 
		local tx,ty = subVec( x, y, v1.x, v1.y )
		--print( round(v1.x), round(v1.y), round(tx), round(ty), round(nx,3), round(ny,3) ) 
	end
	if(v2) then 
		local tx,ty = subVec( x, y, v2.x, v2.y )
		--print( round(v2.x), round(v2.y), round(tx), round(ty), round(nx,3), round(ny,3) ) 
	end

	if(v1 and v2) then
		local vec2 = subVec( v2, v1 )
		local vec2 = normVec( vec2 )
		--print(round(nx,3), round(ny,3), round(vec2.x,3), round(vec2.y,3) )
		if( (nx - vec2.x + ny - vec2.y) < errorMargin ) then
			objectToWrap.x = v2.x	
			objectToWrap.y = v2.y
		else
			objectToWrap.x = v1.x	
			objectToWrap.y = v1.y
		end
		objectToWrap._rx = objectToWrap.x
		objectToWrap._ry = objectToWrap.y		
	end
end


