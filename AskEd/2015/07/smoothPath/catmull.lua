-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================
-- Note: This code was derived from various sources and I've lost the credits link.  
-- If you know it, please tell me here: roaminggamer@gmail.com
-- =============================================================

-- EFM https://en.wikipedia.org/wiki/B%C3%A9zier_curve (redo with this)
-- https://github.com/neostar20/Bezier-Curve-for-Corona-SDK/blob/master/Examples/Three%20Curves/bezier.lua
-- https://github.com/neostar20/Bezier-Curve-for-Corona-SDK/tree/master/Examples/Three%20Curves
-- https://github.com/neostar20/Bezier-Curve-for-Corona-SDK/blob/master/Examples/Three%20Curves/main.lua

local public =  {}

-- Catmull Spline Function
local function genCatMullPoints( p0 , p1 , p2 , p3 , steps ) 
        local points = {} 
        for t = 0 , 1 , 1 / steps do
	        local xPoint = 0.5 * ( ( 2 * p1.x ) + ( p2.x - p0.x ) * t + ( 2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x ) * t * t + ( 3 * p1.x - p0.x - 3 * p2.x + p3.x ) * t * t * t )
	        local yPoint = 0.5 * ( ( 2 * p1.y ) + ( p2.y - p0.y ) * t + ( 2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y ) * t * t + ( 3 * p1.y - p0.y - 3 * p2.y + p3.y ) * t * t * t )
	        table.insert( points , { x= xPoint , y = yPoint } )
        end
        return points
end

function public.smoothPath( points, steps )
	if ( #points > 2 ) then	 
	    local curveSteps = steps or 5

	    local function tAppend( t1, t2 )
	    	for i = 1, #t2 do 
	    		t1[#t1+1] = t2[i]
	    	end
	    end

	    local newPoints = {}

	    -- First Segment
	    local firstSegement = genCatMullPoints( points[1] , points[1] , points[2] , points[3] , curveSteps )
	    tAppend( newPoints, firstSegement )

	    -- Segments Inbetween
	    for i = 2 , #points - 2 , 1 do
	        local middleSegment = genCatMullPoints( points[i-1] , points[i] , points[i+1] , points[i+2] , curveSteps )
	        tAppend( newPoints, middleSegment )
	    end
	    -- Last Segment
	    local lastSegment = genCatMullPoints( points[#points-2] , points[#points-1] , points[#points] , points[#points] , curveSteps )
		tAppend( newPoints, lastSegment )

		return newPoints
	end

	return points
end

function public.squareDist( p0, p1)
	return ( (p0.x - p1.x) ^ 2 + (p0.y - p1.y) ^ 2 )
end

return public
