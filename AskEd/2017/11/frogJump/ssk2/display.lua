-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Display Factories Loader
-- =============================================================
local function shallowCopy( src, dst )
	local dst = dst or {}
	if( not src ) then return dst end
	for k,v in pairs(src) do 
		dst[k] = v
	end
	return dst
end

local _RGDisplay = {}

shallowCopy( require( "ssk2.display.extended" ), _RGDisplay )
shallowCopy( require( "ssk2.display.layers" ), _RGDisplay )
shallowCopy( require( "ssk2.display.arcs" ), _RGDisplay )
shallowCopy( require( "ssk2.display.lines" ), _RGDisplay )

_G.ssk.display = _RGDisplay

return _RGDisplay
