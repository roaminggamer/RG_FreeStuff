-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Easy Interfaces Loader
-- =============================================================
local _rgEasyIFC = {}
_G.ssk.easyIFC = _rgEasyIFC

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

shallowCopy( require( "ssk2.core.interfaces.buttons" ), _rgEasyIFC )
shallowCopy( require( "ssk2.core.interfaces.sbc" ), _rgEasyIFC )
shallowCopy( require( "ssk2.core.interfaces.effects" ), _rgEasyIFC )
shallowCopy( require( "ssk2.core.interfaces.labels" ), _rgEasyIFC ) 
shallowCopy( require( "ssk2.core.interfaces.button_utils" ), _rgEasyIFC ) 

require "ssk2.core.interfaces.presets.default.presets"

-- Added for backward compatibility
_rgEasyIFC.isInBounds = display.pointInRect

return _rgEasyIFC
