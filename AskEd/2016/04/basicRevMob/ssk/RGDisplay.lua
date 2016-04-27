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
--EFM not working properly right now 
-- shallowCopy( require( "ssk.display.chain" ), _RGDisplay )
shallowCopy( require( "ssk.display.extended" ), _RGDisplay )
shallowCopy( require( "ssk.display.layers" ), _RGDisplay )
shallowCopy( require( "ssk.display.lines" ), _RGDisplay )
_G.ssk.display = _RGDisplay

return _RGDisplay
