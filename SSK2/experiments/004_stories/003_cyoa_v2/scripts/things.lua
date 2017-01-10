-- =============================================================
-- Localizations
-- =============================================================
-- Lua
local mAbs = math.abs;local mPow = math.pow;local mRand = math.random
local getInfo = system.getInfo; local getTimer = system.getTimer
local strMatch = string.match; local strFormat = string.format
local strGSub = string.gsub; local strSub = string.sub

--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
--
-- Specialized SSK Features
local actions = ssk.actions
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