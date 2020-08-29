-- Player Module
local player = {}

local common = require "scripts.common"

player.create = function( group )
	local thePlayer = display.newImageRect( group, "images/kenney/soldier2_gun.png", 52, 43 )
	thePlayer.x = centerX
	thePlayer.y = centerY
	thePlayer.isFiring = false

	thePlayer.finalize = function( self )
		print("Player destoyed.  Cleaning up.")

		ignore( "onMove", self )
		ignore( "onFire", self )

		self:removeEventListener("finalize")
	end
	thePlayer:addEventListener("finalize")

	-- Add a global listener for our custom 'onMove' event (dispatched from game module)
	thePlayer.onMove = function(self, event) 
		print( "Player received 'onMove' event dir == ", event.dir )
		common.movePlayerZombie( self, event.dir )

		return false
	end
	listen( "onMove", thePlayer )

	-- Add a global listener for our custom 'onFire' event (dispatched from game module)
	thePlayer.onFire = function(self, event) 
		print( "Player received 'onFire' event phase == ", event.phase )

		return false
	end
	listen( "onFire", thePlayer )

	return thePlayer
end

return player