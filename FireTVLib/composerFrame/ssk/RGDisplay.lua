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

local _RGDisplay = {}


shallowCopy( require( "ssk.display.arcs" ), _RGDisplay )
shallowCopy( require( "ssk.display.chain" ), _RGDisplay )
shallowCopy( require( "ssk.display.extended" ), _RGDisplay )
shallowCopy( require( "ssk.display.layers" ), _RGDisplay )
shallowCopy( require( "ssk.display.lines" ), _RGDisplay )
_G.ssk.display = _RGDisplay

if( not ssk.points ) then
	ssk.points = require( "ssk.display.points" ) 
end

return _RGDisplay
