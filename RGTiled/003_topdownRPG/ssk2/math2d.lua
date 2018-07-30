-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================

-- Localizing math functions for speedup!
local mDeg  = math.deg
local mRad  = math.rad
local mCos  = math.cos
local mSin  = math.sin
local mAcos = math.acos
local mAsin = math.asin
local mSqrt = math.sqrt
local mCeil = math.ceil
local mFloor = math.floor
local mAtan2 = math.atan2
local mPi = math.pi
local mAbs = math.abs

local math2do = {}

if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.math2d = math2do

-- ==
--    ssk.math2d.add( ... [ , altRet ]) - Calculates the sum of two vectors: <x1, y1> + <x2, y2> == <x1 + x2 , y1 + y2>
-- ==
function math2do.add( ... ) -- ( objA, objB [, altRet] ) or ( x1, y1, x2, y2, [, altRet]  )
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
function math2do.addFast( x1, y1, x2, y2 ) 
	return x1 + x2, y1 + y2
end

-- ==
--    ssk.math2d.sub( ... [ , altRet ]) - Calculates the difference of two vectors: <x2, y2> + <x1, y1> == <x2 - x1 , y2 - y1>
-- ==
function math2do.sub( ... ) -- ( objA, objB [, altRet] ) or ( x1, y1, x2, y2, [, altRet]  )
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
function math2do.subFast( x1, y1, x2, y2 ) 
	return x1 - x2, y1 - y2
end

-- ==
--    diff( ... [ , altRet ]) - Calculates the difference of two vectors: <x2, y2> - <x1, y1> == <x2 - x1 , y2 - y1>
-- ==
function math2do.diff( ... ) -- ( objA, objB [, altRet] ) or ( x1, y1, x2, y2, [, altRet]  )
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
function math2do.diffFast( x1, y1, x2, y2 ) 
	return x2 - x1, y2 - y1
end


-- ==
--    ssk.math2d.dot( ... ) - Calculates the dot (inner) product of two vectors: <x1, y1> . <x2, y2> == x1 * x2 + y1 * y2
-- ==
function math2do.dot( ... ) -- ( objA, objB ) or ( x1, y1, x2, y2 )
	local retVal = 0
	if( type(arg[1]) == "number" ) then
		retVal = arg[1] * arg[3] + arg[2] * arg[4]
	else
		retVal = arg[1].x * arg[2].x + arg[1].y * arg[2].y
	end

	return retVal
end
function math2do.dotFast( x1, y1, x2, y2 )
	return x1 * x2 + y1 * y2
end

-- ==
--    cross( ... ) - Calculates the cross (vector) product of two vectors: <x1, y1> x <x2, y2> == x1 * y2 - x2 * y1
-- ==
function math2do.cross( ... ) -- ( objA, objB ) or ( x1, y1, x2, y2 )
	local retVal = 0
	if( type(arg[1]) == "number" ) then
		retVal = arg[1] * arg[4] - arg[3] * arg[2]
	else
		retVal = arg[1].x * arg[2].y - arg[2].x * arg[1].y
	end

	return retVal
end
function math2do.crossFast( x1, y1, x2, y2 )
	return x1 * y2 - x2 * y1
end

-- ==
--    ssk.math2d.length( ... ) - Calculates the length of vector <x1, y1> == math.sqrt( x1 * x1 + y1 * y1 )
-- ==
function math2do.length( ... ) -- ( objA ) or ( x1, y1 )
	local len
	if( type(arg[1]) == "number" ) then
		len = mSqrt(arg[1] * arg[1] + arg[2] * arg[2])
	else
		len = mSqrt(arg[1].x * arg[1].x + arg[1].y * arg[1].y)
	end
	return len
end
function math2do.lengthFast( x, y )
	return mSqrt( x * x + y * y )
end

-- ==
--    ssk.math2d.length2( ... ) - Calculates the squared length of vector <x1, y1> == x1 * x1 + y1 * y1
-- ==
function math2do.length2( ... ) -- ( objA ) or ( x1, y1 )
	local squareLen
	if( type(arg[1]) == "number" ) then
		squareLen = arg[1] * arg[1] + arg[2] * arg[2]
	else
		squareLen = arg[1].x * arg[1].x + arg[1].y * arg[1].y
	end
	return squareLen
end
function math2do.length2Fast( x, y )
	return x * x + y * y
end


-- ==
--    ssk.math2d.scale( ..., scale [ , altRet ]) - Calculates a scaled vector scale * <x1, y1> = <scale * x1, scale * y1>
-- ==
function math2do.scale( ... ) -- ( objA, scale [, altRet] ) or ( x1, y1, scale, [, altRet]  )
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
function math2do.scaleFast( x, y, scale )
	return x * scale, y * scale
end


-- ==
--    ssk.math2d.normalize( ... [ , altRet ]) - Calculates the normalized (unit length) version of a vector.  A normalized vector has a length of 1.
-- ==
function math2do.normalize( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local len = math2do.length( arg[1], arg[2], false )
		local x,y = arg[1]/len,arg[2]/len

		if(arg[3]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local len = math2do.length( arg[1], arg[2], true )
		local x,y = arg[1].x/len,arg[1].y/len
			
		if(arg[2]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end
function math2do.normalizeFast( x, y )
	local len = mSqrt( x * x + y * y )
	return x/len, y/len
end

-- ==
--    ssk.math2d.normals( ... [ , altRet ]) - Returns the two normal vectors for a vector. (Every vector has two normal vectors. i.e. Vectors at 90-degree angles to the original vector.)
--
--    Warning: These normal vectors are not normalized and may need more processing to be useful in other calculations.
-- ==
function math2do.normals( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
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
function math2do.normalsFast( x, y )
	return -y, x, y, -x
end

-- ==
--    ssk.math2d.vector2Angle( ... ) - Converts a screen-space vector to a display object angle (rotation).
-- ==
function math2do.vector2Angle( ... ) -- ( objA ) or ( x1, y1 )
	local angle
	if( type(arg[1]) == "number" ) then
		angle = mCeil(mAtan2( (arg[2]), (arg[1]) ) * 180 / mPi) + 90
	else
		angle = mCeil(mAtan2( (arg[1].y), (arg[1].x) ) * 180 / mPi) + 90
	end
	return angle
end
function math2do.vector2AngleFast( x, y )
	return mCeil(mAtan2( y, x ) * 180 / mPi) + 90
end


-- ==
--    ssk.math2d.angle2Vector( angle [ , altRet ]) - Converts a display object angle (rotation) into a screen-space vector.
-- ==
function math2do.angle2Vector( angle, tableRet )
	local screenAngle = mRad(-(angle+90))
	local x = mCos(screenAngle) 
	local y = mSin(screenAngle) 

	if(tableRet == true) then
		return { x=-x, y=y }
	else
		return -x,y
	end
end
function math2do.angle2VectorFast( angle )
	local screenAngle = mRad(-(angle+90))
	local x = mCos(screenAngle) 
	local y = mSin(screenAngle) 
	return -x,y
end


-- ==
--    ssk.math2d.cartesian2Screen( ... [ , altRet ]) - Converts cartesian coordinates to the equivalent screen coordinates.
-- ==
function math2do.cartesian2Screen( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		if(arg[3]) then
			return { x=arg[1], y=-arg[2] }
		else
			return arg[1],-arg[2]
		end
	else
		if(arg[2]) then
			return arg[1].x,-arg[1].y
		else
			return { x=arg[1].x, y=-arg[1].y }
		end
	end
end

-- ==
--    ssk.math2d.screen2Cartesian( ... [ , altRet ]) - Converts screen coordinates to the equivalent cartesian coordinates.
-- ==
function math2do.screen2Cartesian( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		if(arg[3]) then
			return { x=arg[1], y=-arg[2] }
		else
			return arg[1],-arg[2]
		end
	else
		if(arg[2]) then
			return arg[1].x,-arg[1].y
		else
			return { x=arg[1].x, y=-arg[1].y }
		end
	end
end


-- ==
--    ssk.math2d.distanceBetween( ... ) - Calculates the distance between two points
-- ==
function math2do.distanceBetween( ... ) -- ( objA ) or ( x1, y1 )
	if( type(arg[1]) == "number" ) then
		local vx,vy = math2do.subFast( arg[1], arg[2], arg[3], arg[4] )
		return math2do.lengthFast( vx, vy )
	else
		local vx,vy = math2do.subFast( arg[1].x, arg[1].y, arg[2].x, arg[2].y )
		return math2do.lengthFast( vx, vy )
	end
end

-- ==
--    ssk.math2d.isWithinDistance( ... ) - Calculates whether point1 and 2 are within distance of each other
-- ==
function math2do.isWithinDistance( ... ) -- ( objA ) or ( x1, y1 )
	if( type(arg[1]) == "number" ) then
		local vx,vy = math2do.subFast( arg[1], arg[2], arg[3], arg[4] )
		return math2do.length2Fast( vx, vy ) <= (arg[5] * arg[5])
	else
		local vx,vy = math2do.subFast( arg[1].x, arg[1].y, arg[2].x, arg[2].y )
		return math2do.length2Fast( vx, vy ) <= (arg[3] * arg[3])
	end
end

-- ==
--    ssk.math2d.rotateAbout( ... ) - 
-- ==
-- Rotate About ( Point )
math2do.rotateAbout = function( obj, point, angle, distance  )
	local radians = -(mPi/180) * (angle + 90)
	local vx = -mCos(radians)
	local vy = mSin(radians)
	vx = vx * distance
	vy = vy * distance
	obj.x = point.x + vx
	obj.y = point.y + vy
end

-- ==
--    ssk.math2d.clockwiseAngleSweep( ... ) - Clockwise angle between two vectors with the same tail.
-- ==
math2do.clockwiseAngleSweep = function( vec1, vec2 )
	-- Normalize the vectors
	local len1 = mSqrt(vec1.x * vec1.x + vec1.y * vec1.y)
	local nx1 = vec1.x / len1
	local ny1 = vec1.y / len1

	local len2 = mSqrt(vec2.x * vec2.x + vec2.y * vec2.y)
	local nx2 = vec2.x / len2
	local ny2 = vec2.y / len2

	local angle = mAtan2(ny2, nx2) - mAtan2(ny1, nx1)
	while (angle < 0) do
		angle = angle + 2 * mPi
	end
	angle = (180.0 * angle / mPi)
	return angle
end

-- ==
--    ssk.math2d.angleBetween( ... )
-- ==
math2do.angleBetween = function( ... ) 
   local vec1, vec2

	if( type(arg[1]) == "number" ) then
		vec1 = { x = arg[1], y = arg[2] }
		vec2 = { x = arg[3], y = arg[4] }
	else
		vec1 = arg[1]
		vec2 = arg[2]
	end

	-- Normalize the vectors
	local len1 = mSqrt(vec1.x * vec1.x + vec1.y * vec1.y)
	local nx1 = vec1.x / len1
	local ny1 = vec1.y / len1

	local len2 = mSqrt(vec2.x * vec2.x + vec2.y * vec2.y)
	local nx2 = vec2.x / len2
	local ny2 = vec2.y / len2

	local angle = mAcos(nx1 * nx2 + ny1 * ny2)
	while (angle < 0) do
		angle = angle + 2 * mPi
	end
	angle = (180 * angle / mPi)
	return angle
end

-- Rotate About ( Point )
math2do.inFOV = function( target, observer, fov, offsetAngle )
	offsetAngle = offsetAngle or 0
	local half_fov = fov/2

	-- Calculate facing vector
	local facingX = target.x - observer.x
	local facingY = target.y - observer.y
	local len = mSqrt(facingX * facingX + facingY * facingY)
	facingX = facingX / len
	facingY = facingY / len

	-- Calculate my two facing vectors (left and right for sides of FOV triangle)
	local angle = observer.rotation - half_fov + offsetAngle
	local radians = -(mPi / 180) * (angle + 90)
	local leftX = -mCos(radians)
	local leftY = mSin(radians)

	local angle = observer.rotation + half_fov + offsetAngle
	radians = -(mPi / 180) * (angle + 90)
	local rightX = -mCos(radians)
	local rightY = mSin(radians)

	local tweenLeft = math2do.clockwiseAngleSweep( { x = leftX, y = leftY }, { x = facingX, y = facingY } )
	local tweenRight = math2do.clockwiseAngleSweep( { x= facingX, y = facingY }, { x =rightX, y = rightY } )

	local isInFOV = (tweenLeft >= 0 and tweenLeft <= half_fov) or (tweenRight >= 0 and tweenRight <= half_fov)

	return isInFOV
end

-- ==
--    isInFront, isBehind, isToleft, isToRight - 
-- ==
-- isInFront, isBehind, isToleft, isToRight
local function inFront(target, observer, offsetAngle )
	offsetAngle = offsetAngle or 0
	local minV		= 0.0001

	-- Calculate diff vector
	local diffX = target.x - observer.x
	local diffY = target.y - observer.y
	local len = mSqrt(diffX * diffX + diffY * diffY)
	diffX = diffX / len
	diffY = diffY / len

	-- Calculate facing vector
	local angle = observer.rotation
	local radians = -(mPi / 180) * (angle + offsetAngle + 90)
	local facingX = -mCos(radians)
	local facingY = mSin(radians)
	len = mSqrt(facingX * facingX + facingY * facingY)
	facingX = facingX / len
	facingY = facingY / len

	-- Calculate dot product of diff and facing vectors
	local dotV = diffX * facingX + diffY * facingY
	if (mAbs(dotV) < minV) then
		dotV = 0.0
	end

	return dotV > 0.0
end
function math2do.isInFront( target, observer, offsetAngle ) 
	return inFront( target, observer, 0 ) 
end
function math2do.isBehind( target, observer, offsetAngle ) 
	return inFront( target, observer, 180 ) 
end
function math2do.isToLeft( target, observer, offsetAngle ) 
	return inFront( target, observer, -90 ) 
end
function math2do.isToRight( target, observer, offsetAngle ) 
	return inFront( target, observer, 90 ) 
end


-- =============================================================
-- Wholly copied from Davis Claiborne's mlib: https://github.com/davisdude/mlib/blob/master/mlib.lua
--
-- checkFuzzy, getSlope, getQuadraticRoots, getYIntercept, removeDuplicatePointsFlat, addPoints
--
-- Derived from Davis Claiborne's mlib: https://github.com/davisdude/mlib/blob/master/mlib.lua
--
-- segmentCircleIntersect (signature and returns changed)
-- checkLinePoint (signature and returns changed)
-- checkSegmentPoint (signature and returns changed)
-- segmentSegmentIntersect (signature and returns changed)
-- 
-- =============================================================
local checkFuzzy, getSlope, getQuadraticRoots, getYIntercept, removeDuplicatePointsFlat, addPoints
checkFuzzy = function( number1, number2 )
	return ( number1 - .00001 <= number2 and number2 <= number1 + .00001 )
end
getQuadraticRoots = function ( a, b, c )
	local discriminant = b ^ 2 - ( 4 * a * c )
	if discriminant < 0 then return false end
	discriminant = math.sqrt( discriminant )
	local denominator = ( 2 * a )
	return ( -b - discriminant ) / denominator, ( -b + discriminant ) / denominator
end
getSlope = function( x1, y1, x2, y2 )
	if checkFuzzy( x1, x2 ) then return false end 
	return ( y1 - y2 ) / ( x1 - x2 )
end
getYIntercept = function( x, y, ... )
	local slope
	if #arg == 1 then
		slope = arg[1]
	else
		slope = getSlope( x, y, arg[1], arg[2] )
	end
	if not slope then return x, true end 
	return y - slope * x, false
end

-- Removes duplicate points from table of points { x0, y0, x1, y1, ... }
removeDuplicatePointsFlat = function( tab )
	for i = #tab, 1 -2 do
		for ii = #tab - 2, 3, -2 do
			if i ~= ii then
				local x1, y1 = tab[i], tab[i + 1]
				local x2, y2 = tab[ii], tab[ii + 1]
				if checkFuzzy( x1, x2 ) and checkFuzzy( y1, y2 ) then
					table.remove( tab, ii ); table.remove( tab, ii + 1 )
				end
			end
		end
	end
	return tab
end

-- Helper to add points to flat table.
addPoints = function ( tab, x, y )
    tab[#tab + 1] = x
    tab[#tab + 1] = y
end


-- ==
--    ssk.math2d.segmentCircleIntersect( ... ) - Checks for intercept(s) between line-segment
--    and circle.  Returns intercepts or nil.
--     Secant Intercept (2): i1, i2 
--    Tangent Intercept (1): i1, nil
--          No intercept(0): nil, nil
-- ==
math2do.segmentCircleIntersect = function( p1, p2, circ, radius )
	local x1 = p1.x
	local y1 = p1.y
	local x2 = p2.x
	local y2 = p2.y
	local circleX = circ.x
	local circleY = circ.y

	local slope = getSlope( x1, y1, x2, y2 )
	local intercept = getYIntercept( x1, y1, slope )

	if slope then
		local a = ( 1 + slope ^ 2 )
		local b = ( -2 * ( circleX ) + ( 2 * slope * intercept ) - ( 2 * circleY * slope ) )
		local c = ( circleX ^ 2 + intercept ^ 2 - 2 * ( circleY ) * ( intercept ) + circleY ^ 2 - radius ^ 2 )

		x1, x2 = getQuadraticRoots( a, b, c )

		if not x1 then
			return nil,nil
		end

		y1 = slope * x1 + intercept
		y2 = slope * x2 + intercept

		if checkFuzzy( x1, x2 ) and checkFuzzy( y1, y2 ) then
			return { x = x1, y = y1 }, nil
		else
			return { x = x1, y = y1 }, { x = x2, y = y2 }
		end
	else -- Vertical Lines
		local lengthToPoint1 = circleX - x1
		local remainingDistance = lengthToPoint1 - radius
		local intercept = math.sqrt( -( lengthToPoint1 ^ 2 - radius ^ 2 ) )

		if -( lengthToPoint1 ^ 2 - radius ^ 2 ) < 0 then 
			return nil,nil 
		end

		local bottomX, bottomY = x1, circleY - intercept
		local topX, topY = x1, circleY + intercept

		if topY ~= bottomY then
			return { x = topX, y = topY }, { x = bottomX, y = bottomY }
		else
			return { x = topX, y = topY }, nil
		end
	end
end


-- ==
--    ssk.math2d.lineLineIntersect( ... ) - 
-- ==

-- ==
--    ssk.math2d.lineLineIntersect( ... ) - Check for intercept between two lines and retuns 
--    intercept point or nil.
-- ==
function math2do.lineLineIntersect( ... )
	local x1, y1, x2, y2, x3, y3, x4, y4
	local slope1, intercept1
	local slope2, intercept2
	local x, y

	if( type( arg[1] )  == "table" ) then
		x1, y1, x2, y2, x3, y3, x4, y4  = 
			arg[1].x, arg[1].y, arg[2].x, arg[2].y,
			arg[3].x, arg[3].y, arg[4].x, arg[4].y
	else 
		x1, y1, x2, y2, x3, y3, x4, y4  = unpack( arg )
	end

	slope1 = getSlope( x1, y1, x2, y2 )
	intercept1 = getYIntercept( x1, y1, x2, y2 )
	slope2 = getSlope( x3, y3, x4, y4 )
	intercept2 = getYIntercept( x3, y3, x4, y4 )

	if not slope1 and not slope2 then -- Both are vertical lines
		if x1 == x3 then -- Have to have the same x positions to intersect
			return nil, true, true -- No single intercept, parallel, co-tangent
			
		else
			return nil, true, false -- No single intercept, parallel, NOT co-tangent

		end
	elseif not slope1 then -- First is vertical
		x = x1 -- They have to meet at this x, since it is this line's only x
		y = slope2 and slope2 * x + intercept2 or 1
	
	elseif not slope2 then -- Second is vertical
		x = x3 -- Vice-Versa
		y = slope1 * x + intercept1
	
	elseif checkFuzzy( slope1, slope2 ) then -- Parallel (not vertical)
		if checkFuzzy( intercept1, intercept2 ) then -- Same intercept
			return nil, true, true -- No single intercept, parallel, co-tangent

		else
			return nil, true, false -- No single intercept, parallel, NOT co-tangent

		end
	
	else -- Regular lines
		x = ( -intercept1 + intercept2 ) / ( slope1 - slope2 )
		y = slope1 * x + intercept1
	end

	return { x = x, y = y }
end


-- ==
--    ssk.math2d.checkLinePoint( ... ) - 
-- ==
-- Checks if a point is on a line.
-- Does not support the format using slope because vertical lines would be impossible to check.
local function checkLinePoint( x, y, x1, y1, x2, y2 )
	local m = getSlope( x1, y1, x2, y2 )
	local b = getYIntercept( x1, y1, m )

	if not m then -- Vertical
		return checkFuzzy( x, x1 )
	end
	return checkFuzzy( y, m * x + b )
end
math2do.checkLinePoint = checkLinePoint

-- ==
--    ssk.math2d.checkSegmentPoint( ... ) - 
-- ==
-- Gives whether or not a point lies on a line segment.
local function checkSegmentPoint( px, py, x1, y1, x2, y2 )
	-- Explanation around 5:20: https://www.youtube.com/watch?v=A86COO8KC58
	local x = checkLinePoint( px, py, x1, y1, x2, y2 )
	if not x then return false end

	local lengthX = x2 - x1
	local lengthY = y2 - y1

	if checkFuzzy( lengthX, 0 ) then -- Vertical line
		if checkFuzzy( px, x1 ) then
			local low, high
			if y1 > y2 then low = y2 high = y1
			else low = y1 high = y2 end

			if py >= low and py <= high then return true
			else return false end
		else
			return false
		end
	elseif checkFuzzy( lengthY, 0 ) then -- Horizontal line
		if checkFuzzy( py, y1 ) then
			local low, high
			if x1 > x2 then low = x2 high = x1
			else low = x1 high = x2 end

			if px >= low and px <= high then return true
			else return false end
		else
			return false
		end
	end

	local distanceToPointX = ( px - x1 )
	local distanceToPointY = ( py - y1 )
	local scaleX = distanceToPointX / lengthX
	local scaleY = distanceToPointY / lengthY

	if ( scaleX >= 0 and scaleX <= 1 ) and ( scaleY >= 0 and scaleY <= 1 ) then -- Intersection
		return true
	end
	return false
end
math2do.checkSegmentPoint = checkSegmentPoint



-- ==
--    ssk.math2d.segmentSegmentIntersect( ... ) - 
-- ==
function math2do.segmentSegmentIntersect( x1, y1, x2, y2, x3, y3, x4, y4 )
	local slope1, intercept1 = getSlope( x1, y1, x2, y2 ), getYIntercept( x1, y1, x2, y2 )
	local slope2, intercept2 = getSlope( x3, y3, x4, y4 ), getYIntercept( x3, y3, x4, y4 )

	if ( ( slope1 and slope2 ) and checkFuzzy( slope1, slope2 ) ) or ( not slope1 and not slope2 ) then -- Parallel lines
		if checkFuzzy( intercept1, intercept2 ) then -- The same lines, possibly in different points.
			local points = {}
			if checkSegmentPoint( x1, y1, x3, y3, x4, y4 ) then addPoints( points, x1, y1 ) end
			if checkSegmentPoint( x2, y2, x3, y3, x4, y4 ) then addPoints( points, x2, y2 ) end
			if checkSegmentPoint( x3, y3, x1, y1, x2, y2 ) then addPoints( points, x3, y3 ) end
			if checkSegmentPoint( x4, y4, x1, y1, x2, y2 ) then addPoints( points, x4, y4 ) end

			points = removeDuplicatePointsFlat( points )
			if #points == 0 then return nil end
			return unpack( points )
		else
			return nil
		end
	end

	local vec = math2do.lineLineIntersect( x1, y1, x2, y2, x3, y3, x4, y4 )
	if vec.x and 
		checkSegmentPoint( vec.x, vec.y, x1, y1, x2, y2 ) and 
		checkSegmentPoint( vec.x, vec.y, x3, y3, x4, y4 ) then
		
		return vec
	end
	return nil
end 



return math2do
