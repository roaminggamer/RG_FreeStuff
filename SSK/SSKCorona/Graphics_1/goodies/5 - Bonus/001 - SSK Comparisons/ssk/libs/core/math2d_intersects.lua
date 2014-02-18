-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- 2D Math Library (for operating on display objects)
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

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

local math2do
if( not _G.ssk.math2d ) then
	_G.ssk.math2d = {}
end
math2do = _G.ssk.math2d

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
	local v1sl = ssk.math2d.squarelength( v1 )
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

		if(ssk.math2d.squarelength(l2) > ssk.math2d.squarelength(l1)) then
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


return math2do
