io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local physics = require "physics"
physics.start()
physics.setGravity(0,10)
physics.setDrawMode("hybrid")

local screenGroup  = display.newGroup()

local ball = display.newCircle( screenGroup, display.contentCenterX, display.contentCenterY - 50, 10)
physics.addBody(ball, 'dynamic', { friction = 0, bounce = 0.8, radius = 10 } )
ball.linearDamping = 2
ball.isBullet = true

local rectangle = display.newRect( screenGroup, display.contentCenterX, display.contentCenterY - 300, 200, 40 )
rectangle.strokeWidth = 1
rectangle:setFillColor( 0.25, 0.5, 0.25  )
rectangle:setStrokeColor( 0, 3, 0 )
physics.addBody( rectangle, "static", { friction = 1 } )


local rectangle = display.newRect( screenGroup, display.contentCenterX, display.contentCenterY, 200, 40 )
rectangle.strokeWidth = 1
rectangle:setFillColor( 0.25, 0.5, 0.25  )
rectangle:setStrokeColor( 0, 3, 0 )
physics.addBody( rectangle, "dynamic", { friction = 1 } )

-- Don't let paddle rotate
rectangle.isFixedRotation = true

-- Use an enterFrame listener to limit range of paddle
function rectangle.enterFrame( self )

	-- Keep in center horizontall.y
	-- There are cleaner ways to do this; I'm not bothering as this will
	-- work for now.
	self.x = display.contentCenterX

	-- Limit Y position
	if( self.y < display.contentCenterY - 200 ) then 
		self.y = display.contentCenterY - 200
		self:setLinearVelocity(0,0)
	elseif( self.y > display.contentCenterY + 200 ) then 
		self.y = display.contentCenterY + 200
		self:setLinearVelocity(0,0)
	end	
end; Runtime:addEventListener( "enterFrame", rectangle )

-- Add touch joint
--https://docs.coronalabs.com/api/library/physics/newJoint.html
--https://docs.coronalabs.com/guide/physics/physicsJoints/index.html#touch



-- Add touch listener
rectangle.touch = function( self, event )
	local phase = event.phase
	local id = event.id

	-- Debug feature to show 'drag line'
	----[[
	display.remove( self.dragLine )
	self.dragLine = display.newLine( self.parent, self.x, self.y, event.x, event.y )
	self.dragLine.strokeWidth = 4
	self.dragLine:setStrokeColor(0,1,0)
	--]]

	if( phase == "began" ) then
		self.isFocus = true
		display.currentStage:setFocus( self, id )
		self:setFillColor( 1,1,0 )
		rectangle.touchJoint = physics.newJoint( "touch", rectangle, rectangle.x, rectangle.y )
		self.touchJoint:setTarget( event.x, event.y )

	elseif( self.isFocus ) then
		self.touchJoint:setTarget( event.x, event.y )
		if( phase == "ended" or phase == "cancelled" ) then
			self.isFocus = false
			display.currentStage:setFocus( self, nil )
			self:setFillColor( 1,1,1 )
			display.remove( self.dragLine )
			display.remove(self.touchJoint)
		end

	end
	
	return false
end
rectangle:addEventListener( "touch" )