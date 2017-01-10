-- SSK 
local isInBounds		= ssk.easyIFC.isInBounds
local newCircle 		= ssk.display.circle
local newRect 			= ssk.display.rect
local newImageRect 		= ssk.display.imageRect
local easyIFC			= ssk.easyIFC
local ternary			= _G.ternary
local quickLayers  		= ssk.display.quickLayers

local angle2Vector 		= ssk.math2d.angle2Vector
local vector2Angle 		= ssk.math2d.vector2Angle
local scaleVec 			= ssk.math2d.scale
local addVec 			= ssk.math2d.add
local subVec 			= ssk.math2d.sub
local getNormals 		= ssk.math2d.normals

-- Lua and Corona
local mAbs 				= math.abs
local mPow 				= math.pow
local mRand 			= math.random
local getInfo			= system.getInfo
local getTimer 			= system.getTimer
local strMatch 			= string.match
local strFormat 		= string.format
-- Things
local _things = {}


local addThing
local getDescription


addThing = function( target, descr )
	if( _things[target] ~= nil ) then
		error( "Room by the name " .. target .. " already exists!")
		return false
	end

	_things[target] = descr
end

getDescription = function( obj, target, word, room )
	--print("Get Thing Descr", target, word, room )
	local theThing = _things[target]

	if( _things[target] == nil ) then
		error( "Thing by the name " .. target .. " does not exist!")
		return false
	end

	if( type( theThing ) == "string" ) then
		return (theThing)

	elseif( type( theThing ) == "table" ) then
		local list = theThing
		return ( list[mRand(1,#list)] )
	else
		return false, "Missing_Thing_Deescr"
	end

end


local public = {}

public.add = addThing

public.isThing = function( target ) return _things[target] ~= nil end

public.getDescription = getDescription

return public