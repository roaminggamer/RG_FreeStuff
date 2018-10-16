io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2

local physics = require "physics"
physics.start()
physics.setGravity(0,10)
physics.setDrawMode("hybrid")

local function option1()

	-- Remove Listener, change body type, and reposition
	local function collision( self, event )
		self:removeEventListener( "collision" )
		local x = event.other.x
		local y = event.other.y - event.other.contentHeight/2 - self.contentHeight/2
		timer.performWithDelay( 1,
			function()
				self.bodyType = "static"
				self.x = x
				self.y = y
			end )
		return false
	end

	local ball = display.newCircle( cx - 100, cy, 40 )
	ball:setFillColor(1,0,0)
	physics.addBody( ball, "dynamic", { radius =  40 } )
	local block = display.newRect( cx - 100, cy + 200, 80, 80 )
	block:setFillColor(0,0,1)
	physics.addBody( block, "static" )
	ball.collision = collision
	ball:addEventListener("collision")
end


local function option2()
	-- Remove Listener, reposition, stop motion, use weld joint
	local function collision( self, event )
		self:removeEventListener( "collision" )
		local other = event.other
		local x = other.x
		local y = other.y - other.contentHeight/2 - self.contentHeight/2
		timer.performWithDelay( 1,
			function()
				self.x = x
				self.y = y
				self:setLinearVelocity(0,0)
				self.myJoint = physics.newJoint( "weld", self, other, x, y )
			end )
		return false
	end

	local ball = display.newCircle( cx + 100, cy, 40 )
	ball:setFillColor(1,0,0)
	physics.addBody( ball, "dynamic", { radius =  40 } )
	local block = display.newRect( cx + 100, cy + 200, 80, 80 )
	block:setFillColor(0,0,1)
	physics.addBody( block, "static" )
	ball.collision = collision
	ball:addEventListener("collision")
end

option1()
option2()