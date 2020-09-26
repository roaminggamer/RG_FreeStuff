-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Actions Library - Scene Functions
-- =============================================================
local scene = {}
_G.ssk.actions = _G.ssk.actions or {}
_G.ssk.actions.scene = scene


-- Forward Declarations
-- SSK
local angle2Vector      		= ssk.math2d.angle2Vector
local vector2Angle      		= ssk.math2d.vector2Angle
local scaleVec          		= ssk.math2d.scale
local addVec            		= ssk.math2d.add
local subVec            		= ssk.math2d.sub
local diffVec            		= ssk.math2d.diff
local getNormals        		= ssk.math2d.normals
local lenVec            		= ssk.math2d.length
local len2Vec           		= ssk.math2d.length2
local normVec           		= ssk.math2d.normalize
local segmentCircleIntersect	= ssk.math2d.segmentCircleIntersect
local distanceBetween         = ssk.math2d.distanceBetween

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

scene.rectWrap = function( objectToWrap, wrapRectangle )
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


scene.circWrap = function( objectToWrap, point, radius )
	if( not objectToWrap._rx ) then
		objectToWrap._rx = objectToWrap.x
		objectToWrap._ry = objectToWrap.y
	end
	
	local errorMargin = 0.01
	local x, y, rx, ry = objectToWrap.x, objectToWrap.y, objectToWrap._rx, objectToWrap._ry
	local vec = diffVec( rx, ry, x, y, true )		
	local len2 = len2Vec( vec )
	if( len2 <= errorMargin ) then return end 

	-- If we're less than radius from center, skip all subsequent calculations
	local ox, oy = x - point.x, y - point.y
	if(len2Vec(ox,oy) < radius * radius) then
		objectToWrap._rx = objectToWrap.x
		objectToWrap._ry = objectToWrap.y
		return 
	end

	vec = normVec(vec)
	local nx, ny = vec.x, vec.y
	vec = scaleVec( vec, radius * -3)

	local x2,y2 = addVec( x, y, vec.x, vec.y )
	
	local cx, cy = point.x, point.y

	local v1, v2 = segmentCircleIntersect( { x = x, y = y }, { x = x2, y = y2 }, { x = cx, y = cy }, radius )

	objectToWrap._rx = objectToWrap.x
	objectToWrap._ry = objectToWrap.y

	local wrapV
	if( distanceBetween( objectToWrap, v1 ) > distanceBetween( objectToWrap, v2 ) ) then
		wrapV = v1
	else
		wrapV = v2
	end

	-- Debug Code Left For Future Debugging
	--[[
	local c = display.newCircle( wrapV.x, wrapV.y, 20 )
	c:setFillColor(1,1,0)
	local c = display.newCircle( v1.x, v1.y, 10 )
	c:setFillColor(1,0,0)
	local c = display.newCircle( v2.x, v2.y, 10 )
	c:setFillColor(0,1,0)
	--]]

	objectToWrap.x, objectToWrap.y = wrapV.x, wrapV.y

	-- Debug Code Left For Future Debugging
	--[[
	if(v1) then 
		local tx,ty = subVec( x, y, v1.x, v1.y )
		local c = display.newCircle( v1.x, v1.y, 10 )
		c:setFillColor(1,0,0)
		--print( round(v1.x), round(v1.y), round(tx), round(ty), round(nx,3), round(ny,3) ) 
	end
	if(v2) then 
		local tx,ty = subVec( x, y, v2.x, v2.y )
		local c = display.newCircle( v2.x, v2.y, 10 )
		c:setFillColor(0,1,0)
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
	--]]
end


return scene