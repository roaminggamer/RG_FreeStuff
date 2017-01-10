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

-- Objects
local _objects = {}


local addObject
local getDescription
local getShort


addObject = function( target, short, descr, cantake )
	if( _objects[target] ~= nil ) then
		error( "Room by the name " .. target .. " already exists!")
		return false
	end

	local theObject = {}
	_objects[target] = theObject
	theObject.short = short
	theObject.descr = descr
	theObject.cantake = fnn(cantake,true)
end

getDescription = function( obj, target, word, room )
	--print("Get Object Descr", target, word, room )
	local theObject = _objects[target]

	if( type( theObject.descr ) == "string" ) then
		local tmp = theObject.descr
		tmp = string.gsub( tmp, "_", " ")
		return theObject.cantake, tmp

	elseif( type( theObject.descr ) == "table" ) then
		local list = theObject.descr
		local tmp = list[mRand(1,#list)]
		tmp = string.gsub( tmp, "_", " ")

		return theObject.cantake, tmp
	else
		return false, "Missing_Object_Deescr"
	end

end

getShort = function( target, room )
	--print("Get Object Short", target, room )

	local theObject = _objects[target]

	if(theObject == nil ) then
		return "Missing_Object_Short"
	end

	local tmp = theObject.short
	--tmp = string.gsub( tmp, "_", " ")

	print("tmp ", theObject.short)

	return tmp
end

local public = {}

public.add = addObject

public.isObject = function( target ) return _objects[target] ~= nil end

public.getDescription = getDescription
public.getShort = getShort

return public