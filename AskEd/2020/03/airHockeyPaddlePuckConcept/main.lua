io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
--ssk.easyIFC.generateButtonPresets( nil, true )
-- =====================================================

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua & Corona Functions
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs; local mFloor = math.floor; local mCeil = math.ceil
local strGSub = string.gsub; local strSub = string.sub
-- Common SSK Features
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
local RGTiled = ssk.tiled; local files = ssk.files
local factoryMgr = ssk.factoryMgr; local soundMgr = ssk.soundMgr
--if( ssk.misc.countLocals ) then ssk.misc.countLocals(1) end


-- =====================================================
-- DEMO CODE BEGINS HERE
-- =====================================================
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode("hybrid")


local back = newImageRect( nil, centerX, centerY, "protoBackX.png", { w = 720,  h = 1386, rotation = fullw>fullh and 90 } )

-- Sides of Play Area
newImageRect( nil, left, centerY, "fillW.png", { w = 40, h = fullh, anchorX = 0, fill = _R_ }, { bodyType = "static", bounce = 0.5 }  ) -- left
newImageRect( nil, right, centerY, "fillW.png", { w = 40, h = fullh, anchorX = 1, fill = _G_ }, { bodyType = "static", bounce = 0.5 }  ) -- right
newImageRect( nil, centerX, top, "fillW.png", { w = fullw-80, h = 40, anchorY =  0, fill = _B_ }, { bodyType = "static", bounce = 0.5 }  ) -- top
newImageRect( nil, centerX, bottom, "fillW.png", { w = fullw-80, h = 40, anchorY =  1, fill = _PURPLE_ }, { bodyType = "static", bounce = 0.5 }  ) -- bottom

-- Rectangle To Show Limits of Paddle Movement
local boundsWidth = fullw * 0.5 -- we'll use this value later for the limit code
local boundsHeight = fullh * 0.5 -- we'll use this value later for the limit code
local boundsRect = newRect( nil, centerX, centerY, { w = boundsWidth, h = boundsHeight, fill = _T_, stroke = _Y_, strokeWidth = 4 } )

-- Caculate x,y edges of bounds
local minX 			= centerX - boundsWidth/2
local maxX 			= centerX + boundsWidth/2
local minY 			= centerY - boundsHeight/2
local maxY 			= centerY + boundsHeight/2
local paddleRadius  = 40

-- Make Paddle and add phyics dragger to it.
local paddle = newCircle( nil, centerX, centerY, { radius = paddleRadius, fill = _O_, alpha = 0.5 }, { bodyType = "dynamic"  } )

-- We could use the SSK2 drag helper to add a touch joint:
-- ssk.misc.addPhysicsDrag( paddle, { force = 1e6 } ) 

-- But that isn't quite right so we do this instead:
paddle.touch = function( self, event )
	local phase = event.phase
	local id 	= event.id
	if( phase == "began" ) then
		print("yo")
		self.isFocus = true
		self.tempJoint = physics.newJoint( "touch", self, self.x, self.y )
		self.tempJoint.maxForce = 1e6
		self.tempJoint.dampingRatio = 0
		self.tempJoint.frequency = 2000
		display.currentStage:setFocus( self, id )
	elseif( self.isFocus ) then
		self.tempJoint:setTarget( event.x, event.y )
		if( phase == "ended" or phase == "cancelled" ) then
			self.isFocus = false
			display.currentStage:setFocus( self, nil )
			display.remove( self.tempJoint ) 
		end	
	end
	return false; 
end; paddle:addEventListener("touch")	

-- Add and enterFrame Listener to help limit movement
function paddle.enterFrame( self )
	if (self.x < minX + paddleRadius) then self.x = minX end
	if (self.x > maxX - paddleRadius) then self.x = maxX end
	if (self.y < minY) then self.y = minY end
	if (self.y > maxY) then self.y = maxY end
end; listen( "enterFrame", paddle )


-- Make Puck
local paddle = newCircle( nil, centerX, minY, { radius = paddleRadius/2, fill = _C_, alpha = 1 }, { bodyType = "dynamic", density = 0.1 } )
ssk.misc.addPhysicsDrag( paddle, { force = 1e6 } ) 
