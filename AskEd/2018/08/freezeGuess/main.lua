io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
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
-- == Uncomment following lines if you need  physics
local physics = require "physics"
physics.start()
physics.setGravity(0,10)
--physics.setDrawMode("hybrid")
-- =====================================================
-- YOUR CODE BELOW
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end

local myCC = ssk.cc:newCalculator()
myCC:addNames( "dummy", "walls", "ball" )
myCC:collidesWith( "ball", { "walls" } )

local group = display.newGroup()

local pivot = display.newCircle( group, cx, cy, 10 )
physics.addBody( pivot, "static", { filter =  myCC:getCollisionFilter("dummy") } )

local frame = display.newImageRect( group, "fillT.png", 400, 400 )
frame.x = cx
frame.y = cy
physics.addBody( frame, "dynamic", { filter =  myCC:getCollisionFilter("dummy") } )
physics.newJoint( "pivot", frame, pivot, cx, cy )
frame.angularDamping = 100

local tmp = display.newRect( group, cx, cy-200, 400, 20)
physics.addBody( tmp, "dynamic", { filter =  myCC:getCollisionFilter("walls") } )
physics.newJoint( "weld", tmp, frame, tmp.x, tmp.y )
local tmp = display.newRect( group, cx, cy+200, 400, 20)
physics.addBody( tmp, "dynamic", { filter =  myCC:getCollisionFilter("walls") } )
physics.newJoint( "weld", tmp, frame, tmp.x, tmp.y )
local tmp = display.newRect( group, cx-190, cy, 20, 380)
physics.addBody( tmp, "dynamic", { filter =  myCC:getCollisionFilter("walls") } )
physics.newJoint( "weld", tmp, frame, tmp.x, tmp.y )
local tmp = display.newRect( group, cx+190, cy, 20, 380)
physics.addBody( tmp, "dynamic", { filter =  myCC:getCollisionFilter("walls") } )
physics.newJoint( "weld", tmp, frame, tmp.x, tmp.y )

local tmp = display.newCircle( group, cx, cy, 20 )
physics.addBody( tmp,  {radius = 20, bounce = 0.7, friction = 1, filter =  myCC:getCollisionFilter("ball") } )
tmp.linearDamping = 1
tmp.isBullet = true

function frame.touch( self, event )
	local phase = event.phase
 
    if( phase == "began" ) then
	    display.getCurrentStage():setFocus(self,event.id)
		self.isFocus = true
		self.tempJoint = physics.newJoint( "touch", self, event.x, event.y )

		self.tempJoint.maxForce = 1e15
		self.tempJoint.frequency = 10
		self.tempJoint.dampingRatio = 0
	
	elseif( self.isFocus ) then

		if( phase == "moved" ) then
			self.tempJoint:setTarget( event.x, event.y )

		elseif( phase == "ended" ) then
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false

			display.remove( self.tempJoint ) 
		end			
    end 
    return true
end; frame:addEventListener("touch")
--]]