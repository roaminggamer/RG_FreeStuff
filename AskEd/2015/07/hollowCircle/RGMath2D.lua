-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
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

--[[  All standard math functions
math.abs   math.acos  math.asin  math.atan math.atan2 math.ceil
math.cos   math.cosh  math.deg   math.exp  math.floor math.fmod
math.frexp math.huge  math.ldexp math.log  math.log10 math.max
math.min   math.modf  math.pi    math.pow  math.rad   math.random
math.randomseed       math.sin   math.sinh math.sqrt  math.tanh
math.tan
--]]

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
function math2do.subFast( x1, y1, x2, y2 ) 
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


--     Ray start: < x1, y1 > -- Point 1
--       Ray end: < y2, y2 > -- Point 2
-- Circle center: < cx, cy >
-- Circle radius: cr
--
-- Possible Returns: 
-- nil, nil            - No intersection
-- {x1, y1}, nil       - Single point of intersection
-- {x1, y1}, {x2, y2}  - Two points of intersection sorted nearest-to-furthest
--
-- EFM needs update to match math2d standard API
math2do.rcIntersect =  function ( x1, y1, x2, y2, cx, cy, cr ) 
	local v1 = { x = x2 - x1, y = y2 - y1 } -- Vector from point 1 to point 2
	local v2 = { x = cx - x1, y = cy - y1 }   -- Vector from point 1 to circle's center
	local dot = v1.x * v2.x + v1.y * v2.y
	local v1sl = ssk.math2d.length2( v1 )
	local dv = dot / v1sl
	local proj1 = { x = dv * v1.x, y = dv * v1.y }
	local midpt = { x = x1 + proj1.x, y =  y1 + proj1.y }
	local distToCenter = (midpt.x - cx) * (midpt.x - cx) + (midpt.y - cy) * (midpt.y - cy)

	if( distToCenter > (cr ^ 2) ) then
		return nil,nil
	elseif( distToCenter == (cr ^ 2) ) then
		return midpt,nil
	end

	local distToIntersection
	if( distToCenter == 0)	then
		distToIntersection = cr
	else
		distToIntersection = math.sqrt( cr ^ 2 + distToCenter )
	end

	local v3 = ssk.math2d.normalize( v1 )
	v3 = ssk.math2d.scale( v3, distToIntersection )

	local solution1 = ssk.math2d.add( v3, midpt )
	local solution2 = ssk.math2d.sub( v3, midpt )

	local i1 = ( (solution1.x - x1) * v3.x + (solution1.y - y1 ) * (v3.y) )
	local i2 = ( (solution2.x - x1) * v3.x + (solution2.y - y1 ) * (v3.y) )

	if( i1 > 0 and i2 > 0) then

		-- Return the two points in nearest to point 1 order
		--
		local l1 = ssk.math2d.sub( x1, y1, solution1.x, solution1.y, true)
		local l2 = ssk.math2d.sub( x1, y1, solution2.x, solution2.y, true)

		if(ssk.math2d.length2(l2) > ssk.math2d.length2(l1)) then
			return solution1, solution2
		else
			return solution2, solution1
		end

	elseif( i1 > 0 ) then

		return solution1,nil

	elseif( i2 > 0 ) then
		return solution2,nil
	end		

	return nil,nil
end

-- Test for intersection between two line segments
math2do.lsIntersect =  function ( a1, a2, b1, b2 ) 
	-- Derived from this code: http://pastebin.com/JH7rWWPY
	local x1, y1, x2, y2, x3, y3, x4, y4
	x1 = a1.x
	y1 = a1.y
	x2 = a2.x
	y2 = a2.y
	x3 = b1.x
	y3 = b1.y
	x4 = b2.x
	y4 = b2.y

	d = (y4-y3)*(x2-x1)-(x4-x3)*(y2-y1)
	Ua_n = ((x4-x3)*(y1-y3)-(y4-y3)*(x1-x3))
	Ub_n = ((x2-x1)*(y1-y3)-(y2-y1)*(x1-x3))
	
	if d == 0 then
		if Ua_n == 0 and Ua_n == Ub_n then
			return true
		end
		return false
	end
	
	Ua = Ua_n / d
	Ub = Ub_n / d
	
	if Ua >= 0 and Ua <= 1 and Ub >= 0 and Ub <= 1 then      
		return true
	end
    
	return false
end


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
		return rotateAboutPoint( point, degrees, center )
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

--[[
        Description:
                Perform the cross product on two vectors. In 2D this produces a scalar.
        
        Params:
                a: {x,y}
                b: {x,y}
        
        Ref:
                http://www.iforce2d.net/forums/viewtopic.php?f=4&t=79&sid=b9ecd62533361594e321de04b3929d4f
]]--
math2do.cross = function( a, b )
	return a.x * b.y - a.y * b.x;
end



--[[
        Description:
                Calculates the average of all the x's and all the y's and returns the average centre of all points.
                Works with a display group or table proceeding { {x,y}, {x,y}, ... }
        
        Params:
                pts = list of {x,y} points to get the average middle point from
        
        Returns:
                {x,y} = average centre location of all the points
]]--
math2do.midPoint = function( pts )
	local x, y, c = 0, 0, pts.numChildren or #pts	
	for i=1, c do
		x = x + pts[i].x
		y = y + pts[i].y
	end
	if(c==0) then return { x =0, y = 0 } end
	return { x=x/c, y=y/c }
end


if( not _G.ssk ) then
	_G.ssk = {}
end
_G.ssk.math2d = math2do


return math2do
