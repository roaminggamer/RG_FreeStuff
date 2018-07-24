-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local mRand = math.random
local getTimer = system.getTimer
local mAbs = math.abs
--
local mod = {}

function mod.new( settings )
	local behavior = {}
	behavior.ll = {} -- local listeners   obj:event() )   ==> ex: obj:addEventListener( "collision" )
	behavior.gl = {} -- global listeners  Runtime:event() ==> ex: Runtime:addEventListener( "enterFrame", obj )
	--
	--table.dump(settings)
	local event = settings.event or "touch"
	local phase = settings.phase or "all"
	local toPost = settings.post or "onEventPost"
	--
	function behavior.onCreate( self ) 
		print("Added local event post ", event, phase, toPost )
	end
	--	
	behavior.ll[event] = function( self, event )
		if( phase == "all" or event.phase == phase ) then
			local event = table.shallowCopy(event)
			event.name = nil
			post( toPost, event )
		end
		return false
	end
	--
	return behavior
end


return mod
