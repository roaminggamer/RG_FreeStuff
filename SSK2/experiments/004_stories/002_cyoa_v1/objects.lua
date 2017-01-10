local mRand = math.random

-- Objects
local objects = {}


local addObject
local getDescription
local getShort


addObject = function( target, short, descr, inventorySummary, onUse )
	if( objects[target] ~= nil ) then
		error( "Room by the name " .. target .. " already exists!")
		return false
	end

	local theObject = {}
	objects[target] = theObject
	theObject.short = short
	theObject.descr = descr
end

getDescription = function( obj, target, word, room )
	print("Get Object Descr", target, word, room )
	if( objects[target] == nil ) then
		error( "Object by the name " .. target .. " does not exist!")
		return false
	end

	if( type( objects[target].descr ) == "string" ) then
		return true, (objects[target].descr)
	
	elseif( type( objects[target].descr ) == "function" ) then
		local cantake, result = objects[target].descr( obj, target, word, room )
		return cantake, result

	elseif( type( objects[target].descr ) == "table" ) then
		local list = objects[target].descr
		return true, ( list[mRand(1,#list)] )
	end

	--return (objects[target].descr)
end

getShort = function( target, room )
	print("Get Object Short", target, room )
	if( objects[target] == nil ) then
		error( "Object by the name " .. target .. " does not exist!")
		return false
	end

	return (objects[target].short)
end

local public = {}

public.add = addObject

public.isObject = function( target ) return objects[target] ~= nil end

public.getDescription = getDescription
public.getShort = getShort

return public