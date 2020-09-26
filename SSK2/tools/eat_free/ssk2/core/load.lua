-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Core Loader
-- =============================================================
local function exec( local_require )
	local function shallowCopy( src, dst )
		local dst = dst or {}
		if( not src ) then return dst end
		for k,v in pairs(src) do 
			dst[k] = v
		end
		return dst
	end
	-- =============================================================
	local_require("ssk2.core.functions")
	local_require("ssk2.core.variables")
	local_require "ssk2.core.colors"
	--
	local_require "ssk2.core.extensions.display"
	if( not _G.HTML5_MODE ) then
		local_require "ssk2.core.extensions.io"
	end
	local_require "ssk2.core.extensions.math"
	local_require "ssk2.core.extensions.string"
	local_require "ssk2.core.extensions.table"
	--local_require "ssk2.core.extensions.timer2"
	local_require "ssk2.core.extensions.transition"
	--
	local _RGDisplay = {}

	shallowCopy( require( "ssk2.core.display.extended" ), _RGDisplay )
	shallowCopy( require( "ssk2.core.display.layers" ), _RGDisplay )
	shallowCopy( require( "ssk2.core.display.arcs" ), _RGDisplay )
	shallowCopy( require( "ssk2.core.display.lines" ), _RGDisplay )
	_G.ssk.display = _RGDisplay
	--
	local_require "ssk2.core.math2d"
	local_require "ssk2.core.cc"
	--
	local_require "ssk2.core.interfaces.load"
	--
end

return exec

