local aTan2 	= math.atan2
local mCeil 	= math.ceil
local mCos 		= math.cos
local mFloor 	= math.floor
local mPi 		= math.pi
local mRad 		= math.rad
local mSin 		= math.sin
local mSqrt 	= math.sqrt

local function addVec( x1 , y1, x2, y2 )
	return x2+x1,y2+y1
end

local function subVec( x1 , y1, x2, y2 )
	return x2-x1,y2-y1
end

local function lenVec( x1, y1 )
	return mSqrt(x1 * x1 + y1 * y1 )
end

local function lenVec2( x1, y1 )
	return x1 * x1 + y1 * y1
end

-- Warning: screen coordinates NOT cartessian.
local function angle2Vec(angle)
	local screenAngle = mRad(-(angle+90))
	local x = mCos(screenAngle) 
	local y = mSin(screenAngle) 
	return -x,y
end

-- Cached angle2Vector
local vecCache = {}
for i = 0, 359 do
	local x,y = angle2Vec(i)
	vecCache[#vecCache+1] = { x, y }
end

local function angle2Vec2(angle)
	while(angle >= 360) do angle = angle - 360 end
	while(angle < 0 ) do angle = angle + 360 end
	angle = mFloor( angle + 0.5 )
	local cache = vecCache[angle]
	if( cache ) then 
		return cache[1], cache[2]
	end
	return nil,nil	
end

-- Warning: screen coordinates NOT cartessian.
local function vec2Angle( x1, y1 )
	angle = mCeil( mAtan2( y1, x1 )  * 180 / mPi ) + 90 
end


local function normVec( x1 , y1 )
	local len = lenVec( x1, y1 )
	return x1/len, y1/len
end


local public = {}
public.addVec 		= addVec
public.subVec 		= subVec
public.lenVec 		= lenVec
public.lenVec2 		= lenVec2
public.angle2Vec 	= angle2Vec
public.angle2Vec2 	= angle2Vec2
public.vec2Angle 	= vec2Angle
public.normVec 		= normVec
return public