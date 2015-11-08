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

-- EFM DISABLED FOR NOW BECAUSE IT IS BREAKING REVMOB
--[[
local __G = _G

-- create proxy
_G = {}

local mt = {
  __index = function (t,k)
    return __G[k]   -- access the original table
  end,

  __newindex = function (t,k,v)
	if( __G[k] ~= nil )  then 
		print( "Warning! RGGlobals overwrote: _G." .. tostring(k) ..  " this may cause your app to malfunction" )
	end

    __G[k] = v   -- update original table
  end
}
local tmp = getmetatable( _G )
setmetatable(_G, mt)
--]]

require("ssk.globals.variables")
require("ssk.globals.functions")

--[[
_G = __G
setmetatable(_G, tmp)
__G = nil
--]]