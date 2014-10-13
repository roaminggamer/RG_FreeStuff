-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Core Library Extentions (Loader)
-- =============================================================
-- Note: Modify code below if you put libraries in alternate folder.
-- =============================================================

if( not _G.ssk ) then
	_G.ssk = {}
end

-- ==
--    table.shallowCopy( src [ , dst ]) - Copies single-level tables; handles non-integer indexes; does not copy metatable
-- ==
local function shallowCopy( src, dst )
	local dst = dst or {}
	if( not src ) then return dst end
	for k,v in pairs(src) do 
		dst[k] = v
	end
	return dst
end

local _RGInputs = {}


shallowCopy( require( "ssk.inputs.joystick" ), _RGInputs )
shallowCopy( require( "ssk.inputs.horizSnap" ), _RGInputs )
shallowCopy( require( "ssk.inputs.vertSnap" ), _RGInputs )
_G.ssk.inputs = _RGInputs

return _RGInputs
