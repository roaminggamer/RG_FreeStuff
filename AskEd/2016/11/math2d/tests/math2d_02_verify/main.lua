--------------------------------------------------------------------------------
-- Copyright (c) 2016 Roaming Gamer, LLC.
--
-- MIT Licensed
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy 
-- of this software and associated documentation files (the "Software"), to deal 
-- in the Software without restriction, including without limitation the rights 
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
-- copies of the Software, and to permit persons to whom the Software is furnished 
-- to do so, subject to the following conditions:
--  
-- The above copyright notice and this permission notice shall be included in all 
-- copies or substantial portions of the Software. 
--  
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL  
-- THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  
-- SOFTWARE.
--------------------------------------------------------------------------------
-- ==
--    round(val, n) - Rounds a number to the nearest decimal places. 
--                    Used in verifier to limit range of decimal places in answers for verification
--                    comparisons.  
--    (http://lua-users.org/wiki/FormattingNumbers)
-- ==
local function round (val, n)if (n) then return math.floor( (val * 10^n) + 0.5) / (10^n); else return math.floor(val+0.5); end; end


--
-- This sample both demonstrates basic usage of math2d and verifies it is working properly.
--

print( "Math2D Verifier #2 Start" )


local math2d = require( "plugin.math2d" )
local legacy_math2d = require( "legacy_math2d" )

local vec1 = { x = 1, y = 1 }
local vec2 = { x = -0.25, y = 0.25 }
local scale = 1.59
local angle = -79

local function fourWayTest( func1, func2, name )
	print("Comparing all variations of " .. name )

	-- Style 1
	local o1 = func1( vec1, vec2, false )
	local o2 = func2( vec1, vec2, false )
	if( o1.x ~= o2.x or o1.y ~= o2.y ) then 
		print( name .. " - Usage style 1 failed." )
		table.dump(o1)
		table.dump(o2)
	end

	-- Style 2
	local o1 = func1( vec1.x, vec1.y, vec2.x, vec2.y, true )
	local o2 = func2( vec1.x, vec1.y, vec2.x, vec2.y, true )
	if( o1.x ~= o2.x or o1.y ~= o2.y ) then 
		print( name .. " - Usage style 2 failed." )
		table.dump(o1)
		table.dump(o2)
	end

	-- Style 3
	local x1,y1 = func1( vec1, vec2, true )
	local x2,y2 = func2( vec1, vec2, true )
	if( x1 ~= x2 or y1 ~= y2 ) then 
		print( name .. " - Usage style 3 failed." )
		print( x1, y1 )
		print( x2, y2 )
	end

	-- Style 4
	local x1,y1 = func1( vec1.x, vec1.y, vec2.x, vec2.y, false )
	local x2,y2 = func2( vec1.x, vec1.y, vec2.x, vec2.y, false )
	if( x1 ~= x2 or y1 ~= y2 ) then 
		print( name .. " - Usage style 4 failed." )
		print( x1, y1 )
		print( x2, y2 )
	end
end

local function fourWayScaleTest( func1, func2, name )
	print("Comparing all variations of " .. name )

	-- Style 1
	local o1 = func1( vec1, scale, false )
	local o2 = func2( vec1, scale, false )
	if( o1.x ~= o2.x or o1.y ~= o2.y ) then 
		print( name .. " - Usage style 1 failed." )
		table.dump(o1)
		table.dump(o2)
	end

	-- Style 2
	local o1 = func1( vec1.x, vec1.y, scale, true )
	local o2 = func2( vec1.x, vec1.y, scale, true )
	if( o1.x ~= o2.x or o1.y ~= o2.y ) then 
		print( name .. " - Usage style 2 failed." )
		table.dump(o1)
		table.dump(o2)
	end

	-- Style 3
	local x1,y1 = func1( vec1, scale, true )
	local x2,y2 = func2( vec1, scale, true )
	if( x1 ~= x2 or y1 ~= y2 ) then 
		print( name .. " - Usage style 3 failed." )
		print( x1, y1 )
		print( x2, y2 )
	end

	-- Style 4
	local x1,y1 = func1( vec1.x, vec1.y, scale, false )
	local x2,y2 = func2( vec1.x, vec1.y, scale, false )
	if( x1 ~= x2 or y1 ~= y2 ) then 
		print( name .. " - Usage style 4 failed." )
		print( x1, y1 )
		print( x2, y2 )
	end
end

local function fourWayNormalizeTest( func1, func2, name )
	print("Comparing all variations of " .. name )

	-- Style 1
	local o1 = func1( vec1, false )
	local o2 = func2( vec1, false )
	if( o1.x ~= o2.x or o1.y ~= o2.y ) then 
		print( name .. " - Usage style 1 failed." )
		table.dump(o1)
		table.dump(o2)
	end

	-- Style 2
	local o1 = func1( vec1.x, vec1.y, true )
	local o2 = func2( vec1.x, vec1.y, true )
	if( o1.x ~= o2.x or o1.y ~= o2.y ) then 
		print( name .. " - Usage style 2 failed." )
		table.dump(o1)
		table.dump(o2)
	end

	-- Style 3
	local x1,y1 = func1( vec1, true )
	local x2,y2 = func2( vec1, true )
	if( x1 ~= x2 or y1 ~= y2 ) then 
		print( name .. " - Usage style 3 failed." )
		print( x1, y1 )
		print( x2, y2 )
	end

	-- Style 4
	local x1,y1 = func1( vec1.x, vec1.y, false )
	local x2,y2 = func2( vec1.x, vec1.y, false )
	if( x1 ~= x2 or y1 ~= y2 ) then 
		print( name .. " - Usage style 4 failed." )
		print( x1, y1 )
		print( x2, y2 )
	end
end

local function fourWayNormalsTest( func1, func2, name )
	print("Comparing all variations of " .. name )

	-- Style 1
	local o1,o2 = func1( vec1, false )
	local o3,o4 = func2( vec1, false )	
	if( o1.x ~= o3.x or 
		o1.y ~= o3.y or 
		o2.x ~= o4.x or 
		o2.y ~= o4.y ) then 
		print( name .. " - Usage style 1 failed." )
		table.dump(o1)
		table.dump(o2)
		table.dump(o3)
		table.dump(o4)
	end

	-- Style 2
	local o1,o2 = func1( vec1.x, vec1.y, true )
	local o3,o4 = func2( vec1.x, vec1.y, true )
	if( o1.x ~= o3.x or 
		o1.y ~= o3.y or 
		o2.x ~= o4.x or 
		o2.y ~= o4.y ) then 
		print( name .. " - Usage style 2 failed." )
		table.dump(o1)
		table.dump(o2)
		table.dump(o3)
		table.dump(o4)
	end

	-- Style 3
	local x1,y1,x2,y2 = func1( vec1, true )
	local x3,y3,x4,y4 = func2( vec1, true )
	if( x1 ~= x3 or y1 ~= y3 or x2 ~= x4 or y2 ~= y4 ) then 
		print( name .. " - Usage style 3 failed." )
		print( x1, y1 )
		print( x2, y2 )
		print( x3, y3 )
		print( x4, y4 )
	end

	-- Style 4
	local x1,y1,x2,y2 = func1( vec1.x, vec1.y, false )
	local x3,y3,x4,y4 = func2( vec1.x, vec1.y, false )
	if( x1 ~= x3 or y1 ~= y3 or x2 ~= x4 or y2 ~= y4 ) then 
		print( name .. " - Usage style 4 failed." )
		print( x1, y1 )
		print( x2, y2 )
		print( x3, y3 )
		print( x4, y4 )
	end
end
local function twoWayAngle2VectorTest( func1, func2, name )
	print("Comparing all variations of " .. name )

	-- Style 1
	local o1 = func1( angle, true )
	local o2 = func2( angle, true )
	o1.x = round( o1.x, 4)
	o1.y = round( o1.y, 4)
	o2.x = round( o2.x, 4)
	o2.y = round( o2.y, 4)
	if( o1.x ~= o2.x or o1.y ~= o2.y ) then 
		print( name .. " - Usage style 1 failed." )
		table.dump(o1)
		table.dump(o2)
	end

	-- Style 2
	local x1, y1 = func1( angle )
	local x2, y2 = func2( angle )
	x1 = round(x1,4)
	y1 = round(y1,4)
	x2 = round(x2,4)
	y2 = round(y2,4)
	if( x1 ~= x2 or y1 ~= y2 ) then 
		print( name .. " - Usage style 2 failed." )
		print(x1,y1)
		print(x2,y2)
	end
end


local function twoWayTest( func1, func2, name, alt )
	print("Comparing all variations of " .. name )

	-- Style 1
	local o1 = alt and func1( vec1 ) or func1( vec1, vec2 )
	local o2 = alt and func2( vec1 ) or func2( vec1, vec2 )
	if( o1 ~= o2 ) then 
		print( name .. " - Usage style 1 failed." )
		print(o1,o2)
	end

	-- Style 2
	local o1 = alt and func1( vec1.x, vec1.y ) or func1( vec1.x, vec1.y, vec2.x, vec2.y )
	local o2 = alt and func2( vec1.x, vec1.y ) or func2( vec1.x, vec1.y, vec2.x, vec2.y )
	if( o1 ~= o2 ) then 
		print( name .. " - Usage style 1 failed." )
		print(o1,o2)
	end
end


local function verifyFunctions()
	-- Add
	fourWayTest( legacy_math2d.add, math2d.add, "Add")
	fourWayTest( legacy_math2d.sub, math2d.sub, "Sub")
	fourWayTest( legacy_math2d.diff, math2d.diff, "Diff")
	twoWayTest( legacy_math2d.dot, math2d.dot, "dot")
	twoWayTest( legacy_math2d.cross, math2d.cross, "Cross")
	twoWayTest( legacy_math2d.length, math2d.length, "Length", true )
	twoWayTest( legacy_math2d.length2, math2d.length2, "Squared Length", true )
	fourWayScaleTest( legacy_math2d.scale, math2d.scale, "Scale")
	fourWayNormalizeTest( legacy_math2d.normalize, math2d.normalize, "Normalize")
	fourWayNormalsTest( legacy_math2d.normals, math2d.normals, "Normals")
	twoWayTest( legacy_math2d.vector2Angle, math2d.vector2Angle, "Vector To Angle", true )
	twoWayAngle2VectorTest( legacy_math2d.angle2Vector, math2d.angle2Vector, "Angle To Vector" )
end

verifyFunctions()
