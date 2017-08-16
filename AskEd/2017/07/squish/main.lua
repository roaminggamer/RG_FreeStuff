local centerX = display.contentCenterX
local centerY = display.contentCenterY
local fullw = display.actualContentWidth
local fullh = display.actualContentHeight

local physics = require "physics"
physics.start()
physics.setGravity(0,9.8)
physics.setDrawMode("hybrid")
--physics.setPositionIterations( 20 )
--physics.setVelocityIterations( 128 )



local group = display.newGroup()

local maxOffset = 40

local ground = display.newRect( group, centerX, centerY + fullh/2 - 100, fullw, 40 )
ground:setFillColor(0,1,0)
ground.alpha = 0.5
physics.addBody( ground, "static", { bounce = 0, friction = 1 } )

local function makeBlock()
	local block = display.newRect( group, centerX, centerY - fullh/2 + 100, 60, 60 )
	if(maxOffset > 0) then
		block.x = block.x + math.random(-maxOffset, maxOffset)
	end
	block:setFillColor(1,1,0)
	block.alpha = 0.5
	physics.addBody( block, "dynamic", { bounce = 0, density = 1, friction = 1 } )
	block.linearDamping = 0.25
	block.isFixedRotation = true

	-- failed experiments
	--[[
	function block.preCollision(self,event)
		self:removeEventListener( "preCollision" )		
		local vx,vy = self:getLinearVelocity()
		print("BOOP ", vx, vy )
		timer.performWithDelay(1,			
			function()
		      self.linearDamping = 1000
		      self:setLinearVelocity(vx,0)
				local vx,vy = self:getLinearVelocity()
				print("BOP ", vx, vy )
				self.y = self.y - 1
		      transition.to( self, { linearDamping = 0.25, delay = 250, time = 0 } )
			end )		      
	end;block:addEventListener("preCollision")
	--]]
end

timer.performWithDelay( 1000, makeBlock, 10)