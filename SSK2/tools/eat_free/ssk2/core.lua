-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Core Loader
-- =============================================================
--   Last Updated: 29 NOV 2016
-- Last Validated: 29 NOV 2016
-- =============================================================
local core = {}
_G.ssk.core = core
require("ssk2.core.variables")
require("ssk2.core.functions")

_G.ssk.core.init = function( launchArgs ) 
	launchArgs = launchArgs or {}
	if( ssk.__debugLevel > 0 ) then
		table.dump( launchArgs,nil, "^-launchArgs\n" )
	end
end

-- Export all core fields/functions as globals
function core.export()
	for k,v in pairs( core ) do
		if( k ~= "export" ) then
			_G[k] = v 
		end
	end
end

