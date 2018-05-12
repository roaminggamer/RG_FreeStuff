io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")
--
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================
-- SOLUTION BELOW
-- =====================================================
local cx = display.contentCenterX
local cy = display.contentCenterY

local target = display.newImageRect( "target.png", 300, 300 )
target.x = cx
target.y = cy - display.actualContentHeight/2 + 140

local stone = display.newImageRect( "stone.png", 75, 75 )
stone.x = cx
stone.y = cy + display.actualContentHeight/2 - 50
physics.addBody( stone, { radius = 45 } )
stone.linearDamping = 0.75
stone.angularDamping = 0.30

local turnFactor = 10
local kickForce = 20
local curlCuttoffVelocity = 50
local curlActivationVelocity = 300
local curlFactorModifier = 3000
local curlFactorCap = 5


function stone.touch(self,event)
	if( event.phase == "ended" ) then
		self:applyLinearImpulse( 0, -kickForce * self.mass, self.x, self.y )

		self.angularVelocity = (self.x-event.x) * turnFactor

	end
	return true
end; stone:addEventListener("touch")


function stone.enterFrame( self )
	local vx, vy = self:getLinearVelocity()

	local avy = math.abs( vy )
	if( avy < curlActivationVelocity and avy > curlCuttoffVelocity ) then
		
		local curlFactor = self.angularVelocity * (1 / (avy/curlActivationVelocity)) / curlFactorModifier

		-- cap the factor
		curlFactor = curlFactor < curlFactorCap and curlFactor or curlFactorCap 
		
		vx = curlFactor * avy
		
		self:setLinearVelocity( vx, vy )
	end


	
end; Runtime:addEventListener("enterFrame",stone)

