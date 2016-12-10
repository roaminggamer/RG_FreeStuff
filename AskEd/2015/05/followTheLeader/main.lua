-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"Contrary to what the title says, this question was about making", 
	"a series of objects follow each other in uniform way.",
	"",
	"1. Click anywhere to make objects move an follow each other."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- Load SSK
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            debugLevel 				= 0 } )
--
-- Localize some useful functions
local newCircle    	= ssk.display.newCircle
local newRect       = ssk.display.newRect
local newImageRect  = ssk.display.newImageRect
local easyIFC      	= ssk.easyIFC
local mRand       	= math.random

local angle2Vector  = ssk.math2d.angle2Vector
local vector2Angle  = ssk.math2d.vector2Angle
local scaleVec      = ssk.math2d.scale
local addVec        = ssk.math2d.add
local diffVec       = ssk.math2d.diff
local getNormals    = ssk.math2d.normals
local lenVec        = ssk.math2d.length
local normVec       = ssk.math2d.normalize

--
-- Set up sphysics
local physics = require("physics")
physics.start()
physics.setGravity(0,0)
physics.setDrawMode( "hybrid" )


--
-- Set up some locals to control demo
local group 		= display.newGroup()
local moveSpeed 	= 400
local circleColors 	= { _R_, _G_, _B_, _O_, _Y_, _P_, _C_ }   
local circleRadius 	= {}   

for i = 1, #circleColors do
	circleRadius[i] = 30 - (i-1) * 3
end


--
-- 'enterFrame' lister that does moving work
local function onEnterFrame( self )
	local myNum = self.myNum
	local prior = self.priorCircle
	local vec = diffVec( prior, self )
	vec = normVec( vec )
	vec = scaleVec( vec, 2 * circleRadius[myNum-1] + 2 )
	self.x = prior.x + vec.x
	self.y = prior.y + vec.y
end

-- 
-- Create background object to 'catch' touches
local circles = {}
local x = centerX + 100
local y = centerY
for i = 1, #circleRadius do
	if( i == 1 ) then
		circles[i] = newCircle( group, x, y, { radius = circleRadius[i], fill = circleColors[i] }  )
	else
		circles[i] = newCircle( group, x, y, { radius = circleRadius[i], fill = circleColors[i], myNum = i,  priorCircle = circles[i-1], enterFrame = onEnterFrame }  )         
	end
	x = x - 2 * circleRadius[i] + 2
end

--
-- Touch Listener (and mover)
local function onTouch( self, event )
  if( event.phase == "began" ) then
     -- Stop any current transitions
     -- 
     for i = 1, #circles do
        transition.cancel( circles[i] )
     end

     -- Calc distance First circle needs to move
     --
     local tvec = { x = event.x, y = event.y }
     local vec = diffVec( tvec, circles[1] )
     local len = lenVec( vec )
     local time = 1000 * len / moveSpeed
     transition.to( circles[1], { x = tvec.x, y = tvec.y, time = time })
  end
  return true
end

local touchCatcher = newRect( group, centerX, centerY, { w = fullw, h = fullh, touch = onTouch, fill = _DARKERGREY_ } )
touchCatcher:toBack()
