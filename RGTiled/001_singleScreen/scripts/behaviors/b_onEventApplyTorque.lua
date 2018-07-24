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
	local event = settings.event or "onTwoTouchRight"
	local torque = settings.torque or 10
	--
	function behavior.onCreate( self ) 
		print("Added torque ", event, torque )
	end
	--	
	behavior.gl[event] = function( self, event ) 
		if( event.phase == "began" ) then
			self:applyTorque( self.mass * torque )
		end
		return false
	end
	--
	return behavior
end


return mod
