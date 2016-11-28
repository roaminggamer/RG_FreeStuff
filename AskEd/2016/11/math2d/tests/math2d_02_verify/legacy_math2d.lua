
local Library = require "CoronaLibrary"

-- Create library
local lib = Library:new{ name='math2d', publisherId='com.roaminggamer' }

-- Localizing math functions for speedup!
local mDeg  	= math.deg
local mRad  	= math.rad
local mCos  	= math.cos
local mSin  	= math.sin
local mAcos 	= math.acos
local mAsin 	= math.asin
local mSqrt 	= math.sqrt
local mCeil 	= math.ceil
local mFloor 	= math.floor
local mAtan2 	= math.atan2
local mPi 		= math.pi

local lib = {}
lib.fast = {}

-- ==
--    add( ... [ , altRet ]) - Calculates the sum of two vectors: <x1, y1> + <x2, y2> == <x1 + x2 , y1 + y2>
-- ==
function lib.add( ... ) -- ( objA, objB [, altRet] ) or ( x1, y1, x2, y2, [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local x,y = arg[1] + arg[3], arg[2] + arg[4]

		if(arg[5]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local x,y = arg[1].x + arg[2].x, arg[1].y + arg[2].y
			
		if(arg[3]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end
function lib.fast.add( x1, y1, x2, y2 ) 
	return x1 + x2, y1 + y2
end

-- ==
--    sub( ... [ , altRet ]) - Subtracts one vector from another (in order of arguments) : <x1, y1> - <x2, y2>  == <x1 - x2 , y1 - y2>
-- ==
function lib.sub( ... ) -- ( objA, objB [, altRet] ) or ( x1, y1, x2, y2, [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local x,y = arg[1] - arg[3], arg[2] - arg[4]

		if(arg[5]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local x,y = arg[1].x - arg[2].x, arg[1].y - arg[2].y
			
		if(arg[3]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end
function lib.fast.sub( x1, y1, x2, y2 ) 
	return x1 - x2, y1 - y2
end

-- ==
--    diff( ... [ , altRet ]) - Calculates the difference of two vectors: <x2, y2> - <x1, y1> == <x2 - x1 , y2 - y1>
-- ==
function lib.diff( ... ) -- ( objA, objB [, altRet] ) or ( x1, y1, x2, y2, [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local x,y = arg[3] - arg[1], arg[4] - arg[2]

		if(arg[5]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local x,y = arg[2].x - arg[1].x, arg[2].y - arg[1].y
			
		if(arg[3]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end
function lib.fast.diff( x1, y1, x2, y2 ) 
	return x2 - x1, y2 - y1
end

-- ==
--    dot( ... ) - Calculates the dot (inner) product of two vectors: <x1, y1> . <x2, y2> == x1 * x2 + y1 * y2
-- ==
function lib.dot( ... ) -- ( objA, objB ) or ( x1, y1, x2, y2 )
	local retVal = 0
	if( type(arg[1]) == "number" ) then
		retVal = arg[1] * arg[3] + arg[2] * arg[4]
	else
		retVal = arg[1].x * arg[2].x + arg[1].y * arg[2].y
	end

	return retVal
end
function lib.fast.dot( x1, y1, x2, y2 )
	return x1 * x2 + y1 * y2
end


-- ==
--    dot( ... ) - Calculates the cross (vector) product of two vectors: <x1, y1> x <x2, y2> == x1 * y2 - x2 * y1
-- ==
function lib.cross( ... ) -- ( objA, objB ) or ( x1, y1, x2, y2 )
	local retVal = 0
	if( type(arg[1]) == "number" ) then
		retVal = arg[1] * arg[4] - arg[3] * arg[2]
	else
		retVal = arg[1].x * arg[2].y - arg[2].x * arg[1].y
	end

	return retVal
end
function lib.fast.cross( x1, y1, x2, y2 )
	return x1 * y2 - x2 * y1
end



-- ==
--    length( ... ) - Calculates the length of vector <x1, y1> == math.sqrt( x1 * x1 + y1 * y1 )
-- ==
function lib.length( ... ) -- ( objA ) or ( x1, y1 )
	local len
	if( type(arg[1]) == "number" ) then
		len = mSqrt(arg[1] * arg[1] + arg[2] * arg[2])
	else
		len = mSqrt(arg[1].x * arg[1].x + arg[1].y * arg[1].y)
	end
	return len
end
function lib.fast.length( x, y )
	return mSqrt( x * x + y * y )
end

-- ==
--    length2( ... ) - Calculates the squared length of vector <x1, y1> == x1 * x1 + y1 * y1
-- ==
function lib.length2( ... ) -- ( objA ) or ( x1, y1 )
	local squareLen
	if( type(arg[1]) == "number" ) then
		squareLen = arg[1] * arg[1] + arg[2] * arg[2]
	else
		squareLen = arg[1].x * arg[1].x + arg[1].y * arg[1].y
	end
	return squareLen
end
function lib.fast.length2( x, y )
	return x * x + y * y
end


-- ==
--    scale( ..., scale [ , altRet ]) - Calculates a scaled vector scale * <x1, y1> = <scale * x1, scale * y1>
-- ==
function lib.scale( ... ) -- ( objA, scale [, altRet] ) or ( x1, y1, scale, [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local x,y = arg[1] * arg[3], arg[2] * arg[3]

		if(arg[4]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local x,y = arg[1].x * arg[2], arg[1].y * arg[2]
			
		if(arg[3]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end
function lib.fast.scale( x, y, scale )
	return x * scale, y * scale
end


-- ==
--    normalize( ... [ , altRet ]) - Calculates the normalized (unit length) version of a vector.  A normalized vector has a length of 1.
-- ==
function lib.normalize( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local len = lib.length( arg[1], arg[2], false )
		local x,y = arg[1]/len,arg[2]/len

		if(arg[3]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local len = lib.length( arg[1], arg[2], true )
		local x,y = arg[1].x/len,arg[1].y/len
			
		if(arg[2]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end
function lib.fast.normalize( x, y )
	local len = mSqrt( x * x + y * y )
	return x/len, y/len
end

-- ==
--    normals( ... [ , altRet ]) - Returns the two normal vectors for a vector. (Every vector has two normal vectors. i.e. Vectors at 90-degree angles to the original vector.)
--
--    Warning: These normal vectors are not normalized and may need more processing to be useful in other calculations.
-- ==
function lib.normals( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local nx1,ny1,nx2,ny2 = -arg[2], arg[1], arg[2], -arg[1]

		if(arg[3]) then
			return { x=nx1, y=ny1 }, { x=nx2, y=ny2 }
		else
			return nx1,ny1,nx2,ny2
		end
	else
		local nx1,ny1,nx2,ny2 = -arg[1].y, arg[1].x, arg[1].y, -arg[1].x

		if(arg[2]) then
			return nx1,ny1,nx2,ny2			
		else
			return { x=nx1, y=ny1 }, { x=nx2, y=ny2 }
		end
	end
end
function lib.fast.normals( x, y )
	return -y, x, y, -x
end

-- ==
--    vector2Angle( ... ) - Converts a screen-space vector to a display object angle (rotation).
-- ==
function lib.vector2Angle( ... ) -- ( objA ) or ( x1, y1 )
	local angle
	if( type(arg[1]) == "number" ) then
		angle = mCeil(mAtan2( (arg[2]), (arg[1]) ) * 180 / mPi) + 90
	else
		angle = mCeil(mAtan2( (arg[1].y), (arg[1].x) ) * 180 / mPi) + 90
	end
	return angle
end
function lib.fast.vector2Angle( x, y )
	return mCeil(mAtan2( y, x ) * 180 / mPi) + 90
end


-- ==
--    angle2Vector( angle [ , altRet ]) - Converts a display object angle (rotation) into a screen-space vector.
-- ==
function lib.angle2Vector( angle, tableRet )
	local screenAngle = mRad(-(angle+90))
	local x = mCos(screenAngle) 
	local y = mSin(screenAngle) 

	if(tableRet == true) then
		return { x=-x, y=y }
	else
		return -x,y
	end
end
function lib.fast.angle2Vector( angle )
	local screenAngle = mRad(-(angle+90))
	local x = mCos(screenAngle) 
	local y = mSin(screenAngle) 
	return -x,y
end



return lib
