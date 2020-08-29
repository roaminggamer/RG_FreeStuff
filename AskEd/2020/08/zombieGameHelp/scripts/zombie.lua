-- Zombie Module
local zombie = {}

local common = require "scripts.common"

zombie.create = function( group, x, y, rot  )
	local theZombie = display.newImageRect( group, "images/kenney/zombie1_stand.png", 33, 43 )
	theZombie.x = x
	theZombie.y = y
	theZombie.rotation = rot or 0

	-- store reference to zombie in common zombie table
	common.zombies[theZombie] = theZombie

	theZombie.timer = function( self )
		-- print("move zombie in random direction")		
		if( display.isValid(theZombie) == false ) then
			return
		end
		common.movePlayerZombie( self, "random" )
		timer.performWithDelay( math.random(500,1500), self )
	end
	timer.performWithDelay( math.random(500,1500), theZombie )
	
	return zombie
end

return zombie