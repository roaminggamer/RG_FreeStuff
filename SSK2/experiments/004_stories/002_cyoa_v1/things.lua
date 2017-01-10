local mRand = math.random

-- Things
local things = {}


local addThing
local getDescription


addThing = function( target, descr )
	if( things[target] ~= nil ) then
		error( "Room by the name " .. target .. " already exists!")
		return false
	end

	things[target] = descr
end

getDescription = function( obj, target, word, room )
	print("Get Thing Descr", target, word, room )
	if( things[target] == nil ) then
		error( "Thing by the name " .. target .. " does not exist!")
		return false
	end

	if( type( things[target] ) == "string" ) then
		return (things[target])
	
	elseif( type( things[target] ) == "function" ) then
		local result = things[target]( obj, target, word, room )
		return result

	elseif( type( things[target] ) == "table" ) then
		local list = things[target]
		return ( list[mRand(1,#list)] )
	end

end


local public = {}

public.add = addThing

public.isThing = function( target ) return things[target] ~= nil end

public.getDescription = getDescription

return public