-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Core Library Extentions (Loader)
-- =============================================================
-- Note: Modify code below if you put libraries in alternate folder.
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