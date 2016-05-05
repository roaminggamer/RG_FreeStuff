-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  main.lua
-- =============================================================
-- Generated using 'EAT - Frameworks'
-- https://gumroad.com/l/EATFrameOneTime
-- =============================================================


io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

local function stayOnScreen( obj )
	buffer = buffer or 0
	local minX = display.contentCenterX - display.actualContentWidth/2 + obj.contentWidth/2 + buffer
	local maxX = display.contentCenterX + display.actualContentWidth/2 - obj.contentWidth/2 - buffer
	local minY = display.contentCenterY - display.actualContentHeight/2 + obj.contentHeight/2 + buffer
	local maxY = display.contentCenterY + display.actualContentHeight/2 - obj.contentHeight/2 - buffer
	local correctedX = false
	local correctedY = false
	if( obj.x < minX ) then obj.x = minX; correctedX = true end
	if( obj.x > maxX ) then obj.x = maxX; correctedX = true  end
	if( obj.y < minY ) then obj.y = minY; correctedY = true end
	if( obj.y > maxY ) then obj.y = maxY; correctedY = true end

	local vx,vy = obj:getLinearVelocity()

	if( correctedX ) then 
		vx = 0
	end
	if( correctedY ) then 
		vy = 0
	end
	if( correctedX or correctedY ) then 
		obj:setLinearVelocity( vx, vy )
	end
end

local physics = require "physics"
physics.start()

local boy = display.newImageRect( "images/boy.png", 80, 90 )
boy.x = display.contentCenterX
boy.y = display.contentCenterY + 300
physics.addBody( boy, "dynamic" )

function boy.enterFrame( self )
	stayOnScreen( self )
end
Runtime:addEventListener( "enterFrame", boy )

function boy.touch( self, event )
	if( event.phase == "ended") then
		self:applyLinearImpulse( 0, -10 * self.mass, self.x, self.y )
	end
	return true
end
Runtime:addEventListener( "touch", boy )


