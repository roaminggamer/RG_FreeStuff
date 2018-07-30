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
	--table.dump(settings)
	local x0
	local y0
	local lastT
	local x1 = settings.x1 or 0
	local y1 = settings.y1 or 0
	local x2 = settings.x2 or 0
	local y2 = settings.y2 or 0
	local period = settings.period or 0
	--
	function behavior.onCreate( self ) 
		lastT = getTimer()
		x0 = self.x
		y0 = self.y
	end
	--	
	function behavior.gl.enterFrame( self ) 
		local curT = getTimer()
		if( curT - lastT	<  period ) then return end
		lastT = curT
		self.x = x0 + mRand(x1, x2)
		self.y = y0 + mRand(y1, y2)
	end
	--
	return behavior
end


return mod
