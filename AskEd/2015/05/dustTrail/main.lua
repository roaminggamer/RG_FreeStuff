-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user wanted dust trails behind a running character.", 
	"",
	"This example shows a simple implemenation of this that can be modified and amended."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--
-- Load SSK
require "ssk2.loadSSK"
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            measure 					= true,
	            debugLevel 				= 0 } )
--
-- Forward Declarations
-- SSK 
local angle2Vector      = ssk.math2d.angle2Vector
local vector2Angle      = ssk.math2d.vector2Angle
local scaleVec          = ssk.math2d.scale
local addVec            = ssk.math2d.add
local subVec            = ssk.math2d.sub
local normVec           = ssk.math2d.normalize
local getNormals        = ssk.math2d.normals
local vecLen            = ssk.math2d.length
local vecLen2           = ssk.math2d.length2
-- Lua and Corona 
local mAbs              = math.abs
local mRand             = math.random
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format

--
-- Set som parameters for the demo
local buffer  = 140


--
-- Set up physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 10 )
--physics.setDrawMode("hybrid")


-- Create the 'Ground'
--
local ground = display.newRect( display.contentCenterX,
                              display.contentCenterY + 200, 800, 40  )
physics.addBody( ground, "static"  )
ground:setFillColor(0,1,0)


-- Create the 'Player'
--
local player = display.newRect( display.contentCenterX - 300,
                              display.contentCenterY + 160, 40, 40  )
physics.addBody( player, "dynamic", { bounce = 0, friction = 0 }  )
player:setFillColor(1,1,0)

-- Use transitions to run back and forth endlessly (with small pauses at end of movements)
--
local runLeft
local runRight
runLeft =  function ( obj )
	transition.to( obj, { x = display.contentCenterX - 300, time = 2000, delay = 1000, onComplete = runRight } )
end

runRight =  function ( obj )
	transition.to( obj, { x = display.contentCenterX + 300, time = 2000, delay = 1000, onComplete = runLeft } )
end

-- Add 'dust trail' code as an enterFrame Listener
--
player.enterFrame = function( self )
	if( self.removeSelf == nil ) then
		Runtime:removeEventListener( enterFrame, self )
		return
	end

	-- This code helps decide on which side of player to place trail particles.
	if( not self.lastX ) then
		self.lastX = self.x
	end
	if( self.lastX == self.x ) then 
		return
	end
	
	local moveDir = -1
	if( self.lastX > self.x ) then
		moveDir = 1
	end

	self.lastX = self.x


	-- Place some particles and have them 'float' UP		
	for i = 1, 3 do
		local tmp
		if( false ) then -- change to true for rectangles
			tmp = display.newRect( self.parent, 
				                         self.x + moveDir * self.contentWidth/2 + math.random(-2,2), 
				                         self.y + self.contentWidth/2 + math.random(-4,-1), 
				                         math.random( 4, 8), math.random( 4, 8) )
		else
			-- circles
			tmp = display.newCircle( self.parent, 
				                         self.x + moveDir * self.contentWidth/2 + math.random(-2,2), 
				                         self.y + self.contentWidth/2 + math.random(-4,-1), 
				                         math.random( 2, 4 )  )
		end
		tmp.alpha = 0.5
		tmp:setFillColor(0.5,0.5,0.5)
		tmp:toBack()
		transition.to( tmp, { y = tmp.y - math.random( 10, 25 ), x = tmp.x + math.random(-2,2),
			                  alpha = 0.05, xScale = 0.5, yScale = 0.5, time = 1250, onComplete = display.remove })
	end    		
end
Runtime:addEventListener( "enterFrame", player )


-- Start running
--
runRight( player )



