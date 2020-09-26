-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- =============================================================
-- display.* - Extension(s)
-- =============================================================
local type = type
display.isValid = function ( obj )
	return ( obj and obj.removeSelf and type(obj.removeSelf) == "function" )
end

local display_newContainer = display.newContainer
function display.newContainer( ... )
	local container = display_newContainer( unpack( arg ) )
	container.__isContainer = true
	container.__isGroup 	= true
	return container
end

local display_newGroup = display.newGroup
function display.newGroup( ... )
	local group = display_newGroup( unpack( arg ) )
	group.__isContainer = false
	group.__isGroup 	= true
	return group
end

-- removeWithDelay( func ) - Remove an object in the next frame or after delay
--
function display.removeWithDelay( obj, delay )
    delay = delay or 1    
    timer.performWithDelay(delay, 
        function() 
            display.remove( obj )
        end )
end

-- Check if a point is in bounds
function display.pointInRect( point, obj )

	if(not obj) then return false end

	local bounds = obj.contentBounds
	if( point.x > bounds.xMax ) then return false end
	if( point.x < bounds.xMin ) then return false end
	if( point.y > bounds.yMax ) then return false end
	if( point.y < bounds.yMin ) then return false end
	return true
end

-- Check an axis-aligned bounding rect of an object overlaps that of another
function display.overlaps( a, b )
	a, b = a.contentBounds, b.contentBounds
  return (a.xMin <= b.xMax) and (a.xMax >= b.xMin) and (a.yMin <= b.yMax) and (a.yMax >= b.yMin)
end

-- Helpers to find position of object sides and centers
function display.getObjectLeft( obj )
	return obj.x - obj.anchorX * obj.contentWidth 
end
function display.getObjectRight( obj ) 
	return obj.x + (1 - obj.anchorX) * obj.contentWidth 
end
function display.getObjectTop( obj ) 
	return obj.y - obj.anchorY * obj.contentHeight 
end
function display.getObjectBottom( obj ) 
	return obj.y + (1 - obj.anchorY) * obj.contentHeight 
end
function display.getObjectHCenter( obj ) 
	return display.getObjectLeft( obj ) + 0.5 * obj.contentWidth 
end
function display.getObjectVCenter( obj ) 
	return display.getObjectTop( obj ) + 0.5 * obj.contentHeight 
end
function display.getObjectCenter( obj ) 
	return display.getObjectHCenter( obj ), display.getObjectVCenter( obj ) 
end


