-- =============================================================
--  main.lua
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

local physics = require "physics"
physics.start()
--physics.setDrawMode("hybrid")

local planet
local moon
local running = false
local subtractVelocity = true
local angularVelocity = 360

local function doit()
	running = true

	display.remove( planet )
	display.remove( moon )

	planet = display.newCircle( display.contentCenterX, 100, 30 )
	physics.addBody( planet, "kinematic", { radius = 30 } )
	--planet:setLinearVelocity( 0, 100 )
	planet.angularVelocity = angularVelocity
	planet.vy0 		= 100
	planet.t0 		= system.getTimer()
	planet.accel 	= 15

	function planet.enterFrame( self )
		local dt = system.getTimer() - self.t0
		dt  = dt / 1000
		local vy = self.accel * dt * dt
		self:setLinearVelocity(0, vy)
	end; Runtime:addEventListener("enterFrame", planet)

	function planet.finalize( self ) 
		Runtime:removeEventListener("enterFrame", self )
	end; planet:addEventListener( "finalize" )

	moon = display.newCircle( display.contentCenterX - 100, 100, 10 )
	physics.addBody( moon, "dynamic", { radius = 10 } )


	planet.myJoint = physics.newJoint( "weld", planet, moon, moon.x, moon.y )
end

local function touch( event )
	if( not running ) then return end
	if( not planet or not moon ) then return end
	if( event.phase ~= "ended" ) then return false end

	display.remove( planet.myJoint )

   if( subtractVelocity ) then
   	local vxp, vyp = planet:getLinearVelocity()
   	local vxm, vym = moon:getLinearVelocity()
   	moon:setLinearVelocity( vxm - vxp, vym - vyp  )
   end

   timer.performWithDelay( 2000, doit )

end; Runtime:addEventListener("touch",touch)

doit()


