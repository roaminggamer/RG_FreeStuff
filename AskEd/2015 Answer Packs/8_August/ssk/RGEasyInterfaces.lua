-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
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

local _rgEasyIFC = {}

shallowCopy( require( "ssk.interfaces.buttons" ), _rgEasyIFC )
shallowCopy( require( "ssk.interfaces.sbc" ), _rgEasyIFC )
shallowCopy( require( "ssk.interfaces.effects" ), _rgEasyIFC )
shallowCopy( require( "ssk.interfaces.labels" ), _rgEasyIFC )
_G.ssk.easyIFC = _rgEasyIFC

require "ssk.presets.defaultbuttons.presets"
require "ssk.presets.defaultlabels.presets"

return _rgEasyIFC
