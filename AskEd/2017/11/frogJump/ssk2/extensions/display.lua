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


