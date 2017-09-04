-- =============================================================
--require "ssk2.loadSSK"
--_G.ssk.init()
-- =============================================================
local physics = require "physics"
--physics.setDrawMode("hybrid")
physics.start()

local cx = display.contentCenterX
local cy = display.contentCenterY


local function newFireBall( x, y, impulseMag, params )
	params = params or {}	

	local fireBall = display.newImageRect( "fireball.png", 100, 100 )
	fireBall.x = x
	fireBall.y = y

	physics.addBody( fireBall, { radius = 40, bounce = 0 } )

	for k,v in pairs( params ) do
		fireBall[k] = v
	end

	fireBall.isFixedRotation = true

	fireBall.collision = function( self, event  )
		if(event.phase ~= "began" ) then return false end

		timer.performWithDelay( 1,
			function()
				self:applyLinearImpulse( 0, -impulseMag * self.mass, self.x, self.y )
			end )
		return true
	end; fireBall:addEventListener( "collision" )

end

local ground = display.newRect( cx, cy + display.actualContentHeight/2- 40, display.actualContentWidth, 80 )
ground:setFillColor(0,1,0,0.2)
physics.addBody( ground, "static", { bounce = 0 } )

-- base case
newFireBall( cx - 300, cy, 10 ) -- base case

-- typical damping
newFireBall( cx - 150, cy, 20, { linearDamping = 1 } )

-- strong damping (I like this one the best)
newFireBall( cx, cy, 30, { linearDamping = 2 } )

-- half gravityScale
newFireBall( cx + 150, cy, 10, { gravityScale = 0.5 } )

-- half gravityScale + typical damping
newFireBall( cx + 300, cy, 20, { gravityScale = 0.5, linearDamping = 1 } )
