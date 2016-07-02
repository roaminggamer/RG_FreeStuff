--
-- Baseline Experiment - Player moving at 'maxSpeed' pixels-per-second to right w/ 'maxObjs' objects in world at time.
--

local physics = require "physics"
physics.start()
physics.setGravity(0,0)

-- A group to contain all display objects in 'world'
--
local world = display.newGroup()

-- Object to track with 'camera' code
local player = display.newImageRect( world, "smiley.png", 40, 40  )
player.x = display.contentCenterX
player.y = display.contentCenterY
player.lx = player.x
player.ly = player.y
physics.addBody( player )
player:setLinearVelocity( _G.maxSpeed, 0 )

-- Basic camera code.  Keeps player in center of screen; moves world 'around' player
--
function world.enterFrame( self )
	local dx = player.x - player.lx
	local dy = player.y - player.ly
	self:translate(-dx,-dy)
	player.lx = player.x	
	player.ly = player.y
end
Runtime:addEventListener( "enterFrame", world )

-- Generate objects to show 'hiccup' more clearly
local mRand 	= math.random
local period 	= 100  -- create and delete up to 10 objects per second
local maxCount 	= _G.maxObjs
local objs 		= {}   -- table to hold 'object' references

timer.performWithDelay( period, 
	function()
		local obj = display.newCircle( world, player.x + 600, player.y + mRand( -200, 200), mRand( 10, 15 ) )
		obj:setFillColor(mRand(),mRand(),mRand())
		obj:toBack()
		if( #objs > maxCount ) then
			objs[#objs+1] = obj
			display.remove(objs[1])
			table.remove( objs, 1 )			
		end
	end, -1)