-- =============================================================
-- Ask Ed 2016
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2016 (http://roaminggamer.com/)
-- =============================================================


local function newTurret( x, y )
	local turret = display.newCircle( x, y, 20 )	
	turret.barrel = display.newLine( x, y, x, y - 30)
	turret.barrel.strokeWidth = 8
	turret.barrel.anchorX = 0
	turret.angle = 0 -- variable to hold value barrel facing angle

	function turret.setAngle( self, angle )
		self.barrel.rotation = angle
		self.angle = angle 
	end

	function turret.getAngle( self ) 
		return self.angle		
	end

	return turret
end

local aTurret = newTurret( 100, 100 )


timer.performWithDelay( 30, 
	function()
		local angle = aTurret:getAngle()
		angle = angle + 2
		aTurret:setAngle( angle )
	end, 180)
