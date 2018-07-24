-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local mRand = math.random
local getTimer = system.getTimer
--
local mod = {}

function mod.new( settings )
	local behavior = {}
	behavior.ll = {} -- local listeners   obj:event() )   ==> ex: obj:addEventListener( "collision" )
	behavior.gl = {} -- global listeners  Runtime:event() ==> ex: Runtime:addEventListener( "enterFrame", obj )
	--
	local pType = settings.type
	local value = settings.value
	--	
	function behavior.ll.collision( self, event ) 
		if( event.phase == "began" ) then
			Runtime:dispatchEvent( { name = "onPickup", type = pType, value = value } )
			timer.performWithDelay( 1,				
				function()
					display.remove(self)
				end )
		end
		return true
	end
	--
	return behavior
end


return mod
