io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- Uncomment: Load and Create Basic Meters
--[[
local meters = require "basic_meters"
meters.create_fps()
meters.create_mem()
--]]
----------------------------------------------
-- Example starts below
----------------------------------------------

local enableReuse = true
collectgarbage("stop")

local physics = require "physics"
physics.start()
physics.setGravity(0,0)

local world = display.newGroup()
local objs  = {}

-- Object to track with 'camera'
local player = display.newRect( world, display.contentCenterX, display.contentCenterY, 40, 40  )
player.lx = player.x
player.ly = player.y
physics.addBody( player )
player:setLinearVelocity( 500, 0 )

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
local maxCount 	= 30

timer.performWithDelay( period, 
	function()

		if( enableReuse ) then
			if( #objs < maxCount ) then
				local obj = display.newCircle( world, player.x + 600, player.y + mRand( -200, 200), mRand( 10, 15 ) )
				objs[#objs+1] = obj
			else
				local obj = objs[1]
				objs[#objs+1] = obj
				table.remove(objs, 1 )
				obj.x = player.x + 600
				obj.y = player.y + mRand( -200, 200)

			end

		else
			local obj = display.newCircle( world, player.x + 600, player.y + mRand( -200, 200), mRand( 10, 15 ) )
			objs[#objs+1] = obj
			display.remove(objs[1])
			table.remove( objs, 1 )			
		end
	end, -1)