-- TEMPORARY FIX FOR (LINE INTERSETIONS ISSUE: https://forums.coronalabs.com/topic/66714-math2d-crash-on-device/ )

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

local math2do = {}

if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.math2d = math2do


if( ssk.__math2DPlugin ) then
	local function loadPlugin()
		return require( "plugin.math2d" )
	end
	local loaded,msg = pcall( loadPlugin, nil )

	if( loaded )  then
		math2do = nil
		_G.ssk.math2d = loadPlugin() 
		print(loaded, "Loaded plugin version of math2d")
		return _G.ssk.math2d
	end
end


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

--EFM BELOW FUNCTIONS NEED SOME WORK TO BRING THEM IN LINE WITH alternate return protocols
--EFM BELOW FUNCTIONS NEED SOME WORK TO BRING THEM IN LINE WITH alternate return protocols
--EFM BELOW FUNCTIONS NEED SOME WORK TO BRING THEM IN LINE WITH alternate return protocols
--EFM BELOW FUNCTIONS NEED SOME WORK TO BRING THEM IN LINE WITH alternate return protocols

-- **** 
-- **** tweenAngle - Delta between an objA and vector2Angle(objA, objB)
-- ****            - Returns vector2Angle as second return value (for cases where you need it too) :)
-- **** 
function math2do.tweenAngle( objA, objB )
	local vx,vy      = math2do.sub( objA.x, objA.y, objB.x, objB.y )
	vx,vy            = math2do.normalize(vx,vy)
	local vecAngle   = math2do.vector2Angle(vx,vy)
	local tweenAngle = vecAngle - objA.rotation
	return tweenAngle,vecAngle
end

-- **** 
-- **** tweenDist - Distance between objA and objB (EFM fix this and others that return 'extras' to use objects not numbers)
-- ****           - Returns sub( objA, objB ) as second, third value (for cases where you need them too) :)
-- **** 

function math2do.tweenDist( objA, objB )
	local vx,vy = math2do.sub( objA.x, objA.y, objB.x, objB.y )
	local vecLen  = math2do.length(vx,vy)
	return vecLen,vx,vy
end

-- **** 
-- **** tweenData - Returns all data between two objects (in this order)
-- ****
-- ****      vx,vy - equivalent to objMath2d.sub(objA,objB)
-- ****      nx,ny - equivalent to ssk.math2do.normalize(vx,vy)
-- ****     vecLen - equivalent to ssk.math2do.length( vx, vy )
-- ****   vecAngle - equivalent to objMath2d.vector2Angle( objA, objB)
-- **** tweenAngle - equivalent to objMath2d.tweenAngle( objA, objB)
-- **** 

function math2do.tweenData( objA, objB )
	local vx,vy      = math2do.sub( objA.x, objA.y, objB.x, objB.y )
	local nx,ny      = math2do.normalize(vx,vy)
	local vecLen     = math2do.length(vx,vy)
	local vecAngle   = math2do.vector2Angle(nx,ny)
	local tweenAngle = vecAngle - objA.rotation
	return vx,vy,nx,ny,vecLen,vecAngle,tweenAngle
end

-- CREDIT NOTICE
-- Following Copied/Derived from code by: 
-- Davis Claiborne (https://github.com/davisdude/mlib/blob/master/mlib.lua)
--
local getQuadraticRoots
local checkFuzzy
local getSlope
local checkInput
local getYIntercept

checkInput =  function( ... )
	local input = {}
	if type( ... ) ~= 'table' then input = { ... } else input = ... end
	return input
end

checkFuzzy = function( number1, number2 )
	return ( number1 - .00001 <= number2 and number2 <= number1 + .00001 )
end

getSlope = function( x1, y1, x2, y2 )
	if checkFuzzy( x1, x2 ) then return false end 
	return ( y1 - y2 ) / ( x1 - x2 )
end

getYIntercept = function( x, y, ... )
	local input = checkInput( ... )
	local slope

	if #input == 1 then
		slope = input[1]
	else
		slope = getSlope( x, y, unpack( input ) )
	end

	if not slope then return x, true end -- This way we have some information on the line.
	return y - slope * x, false
end

getQuadraticRoots = function ( a, b, c )
	local discriminant = b ^ 2 - ( 4 * a * c )
	if discriminant < 0 then return false end
	discriminant = math.sqrt( discriminant )
	local denominator = ( 2 * a )
	return ( -b - discriminant ) / denominator, ( -b + discriminant ) / denominator
end

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
			return { x = x1, y = y1 }, nil, 'tangent'
		else
			return { x = x1, y = y1 }, { x = x2, y = y2 }, 'secant'
		end
	else -- Vertical Lines
		local lengthToPoint1 = circleX - x1
		local remainingDistance = lengthToPoint1 - radius
		local intercept = math.sqrt( -( lengthToPoint1 ^ 2 - radius ^ 2 ) )

		if -( lengthToPoint1 ^ 2 - radius ^ 2 ) < 0 then return false end

		local bottomX, bottomY = x1, circleY - intercept
		local topX, topY = x1, circleY + intercept

		if topY ~= bottomY then
			return { x = topX, y = topY }, { x = bottomX, y = bottomY }, 'secant'
		else
			return { x = topX, y = topY }, nil, 'tangent'
		end
	end
end


-- // Derived from code by: Davis Claiborne (https://github.com/davisdude/mlib/blob/master/mlib.lua)
local function getLineLineIntersection( ... )
	local input = checkInput( ... )
	local x1, y1, x2, y2, x3, y3, x4, y4
	local slope1, intercept1
	local slope2, intercept2
	local x, y

	if #input == 4 then -- Given slope1, intercept1, slope2, intercept2.
		slope1, intercept1, slope2, intercept2 = unpack( input )

		-- Since these are lines, not segments, we can use arbitrary points, such as ( 1, y ), ( 2, y )
		y1 = slope1 and slope1 * 1 + intercept1 or 1
		y2 = slope1 and slope1 * 2 + intercept1 or 2
		y3 = slope2 and slope2 * 1 + intercept2 or 1
		y4 = slope2 and slope2 * 2 + intercept2 or 2
		x1 = slope1 and ( y1 - intercept1 ) / slope1 or intercept1
		x2 = slope1 and ( y2 - intercept1 ) / slope1 or intercept1
		x3 = slope2 and ( y3 - intercept2 ) / slope2 or intercept2
		x4 = slope2 and ( y4 - intercept2 ) / slope2 or intercept2
	elseif #input == 6 then -- Given slope1, intercept1, and 2 points on the other line.
		slope1, intercept1 = input[1], input[2]
		slope2 = getSlope( input[3], input[4], input[5], input[6] )
		intercept2 = getYIntercept( input[3], input[4], input[5], input[6] )

		y1 = slope1 and slope1 * 1 + intercept1 or 1
		y2 = slope1 and slope1 * 2 + intercept1 or 2
		y3 = input[4]
		y4 = input[6]
		x1 = slope1 and ( y1 - intercept1 ) / slope1 or intercept1
		x2 = slope1 and ( y2 - intercept1 ) / slope1 or intercept1
		x3 = input[3]
		x4 = input[5]
	elseif #input == 8 then -- Given 2 points on line 1 and 2 points on line 2.
		slope1 = getSlope( input[1], input[2], input[3], input[4] )
		intercept1 = getYIntercept( input[1], input[2], input[3], input[4] )
		slope2 = getSlope( input[5], input[6], input[7], input[8] )
		intercept2 = getYIntercept( input[5], input[6], input[7], input[8] )

		x1, y1, x2, y2, x3, y3, x4, y4 = unpack( input )
	end

	if not slope1 and not slope2 then -- Both are vertical lines
		if x1 == x3 then -- Have to have the same x positions to intersect
			return true
		else
			return false
		end
	elseif not slope1 then -- First is vertical
		x = x1 -- They have to meet at this x, since it is this line's only x
		y = slope2 and slope2 * x + intercept2 or 1
	elseif not slope2 then -- Second is vertical
		x = x3 -- Vice-Versa
		y = slope1 * x + intercept1
	elseif checkFuzzy( slope1, slope2 ) then -- Parallel (not vertical)
		if checkFuzzy( intercept1, intercept2 ) then -- Same intercept
			return true
		else
			return false
		end
	else -- Regular lines
		x = ( -intercept1 + intercept2 ) / ( slope1 - slope2 )
		y = slope1 * x + intercept1
	end

	return x, y
end

function math2do.lineLineIntersect( x1, y1, x2, y2, x3, y3, x4, y4 ) 
	local x, y = getLineLineIntersection( x1, y1, x2, y2, x3, y3, x4, y4 ) 
	if( not x) then return nil end
	return { x = x, y = y }
end

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
			if y1 > y2 then low = y2; high = y1
			else low = y1; high = y2 end

			if py >= low and py <= high then return true
			else return false end
		else
			return false
		end
	elseif checkFuzzy( lengthY, 0 ) then -- Horizontal line
		if checkFuzzy( py, y1 ) then
			local low, high
			if x1 > x2 then low = x2; high = x1
			else low = x1; high = x2 end

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

	local x, y = getLineLineIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )
	if x and checkSegmentPoint( x, y, x1, y1, x2, y2 ) and checkSegmentPoint( x, y, x3, y3, x4, y4 ) then
		return { x = x,  y = y }
	end
	return nil
end 


-- CREDIT NOTICE:
-- Following derived from: https://gist.github.com/Xeoncross/9511295

-- Rotate About Point
-- rotates point around the center by degrees
-- rounds the returned coordinates using math.round() if round == true
-- returns new coordinates object
math2do.rotateAboutPoint = function( point, degrees, center )
	local pt = { x=point.x - center.x, y=point.y - center.y }
	pt = math2do.rotateTo( pt, degrees )
	pt.x, pt.y = pt.x + center.x, pt.y + center.y
	return pt
end

 
-- rotates a point around the (0,0) point by degrees
-- returns new point object
-- center: optional
math2do.rotateTo = function( point, degrees, center )
	if (center ~= nil) then
		return math2do.rotateAboutPoint( point, degrees, center )
	else
		local x, y = point.x, point.y 
		local theta = math.rad( degrees ) 
		local pt = {
			x = x * math.cos(theta) - y * math.sin(theta),
			y = x * math.sin(theta) + y * math.cos(theta)
		}		
		return pt
	end
end

math2do.smallestAngleDiff = function( target, source )
	local a = target - source 
	if (a > 180) then
		a = a - 360
	elseif (a < -180) then
		a = a + 360
	end 
	return a
end


math2do.midPoint = function( pts )
	local x, y, c = 0, 0, pts.numChildren or #pts	
	for i=1, c do
		x = x + pts[i].x
		y = y + pts[i].y
	end
	if(c==0) then return { x =0, y = 0 } end
	return { x=x/c, y=y/c }
end



return math2do
