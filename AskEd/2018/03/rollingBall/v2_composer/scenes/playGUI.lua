-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Play GUI
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local ball

-- Forward Declarations

-- Useful Localizations
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs

local physics = require "physics"
physics.start()
physics.setGravity(0,10)
physics.setDrawMode("hybrid")

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	-- Create a simple background
	local back = display.newImageRect( sceneGroup, "images/protoBackX.png", 720, 1386 )
	back.x = centerX
	back.y = centerY
	if(w>h) then back.rotation = 90 end
	
	--
	--
	--

	ball = display.newCircle( sceneGroup, display.contentCenterX + 200, display.contentCenterY - 50, 10)
	physics.addBody(ball, 'dynamic', { friction = 1, bounce = 0.8, radius = 10 } )	
	ball.angularDamping = 0.5
	ball.linearDamping = 0.5

	local rectangle = display.newRect( sceneGroup, display.contentCenterX + 100, display.contentCenterY, 300, 20 )
	rectangle.strokeWidth = 1
	rectangle:setFillColor( 0.25, 0.5, 0.25  )
	rectangle:setStrokeColor( 0, 3, 0 )
	physics.addBody( rectangle, "static", { friction = 1 } )

	local rectangle = display.newRect( sceneGroup, display.contentCenterX - 100, display.contentCenterY + 100, 300, 20 )
	rectangle.strokeWidth = 1
	rectangle.rotation = 15
	rectangle:setFillColor( 0.25, 0.5, 0.25  )
	rectangle:setStrokeColor( 0, 3, 0 )
	physics.addBody( rectangle, "static", { friction = 1 } )

	local rectangle = display.newRect( sceneGroup, display.contentCenterX + 200, display.contentCenterY + 200, 300, 20 )
	rectangle.strokeWidth = 1
	rectangle:setFillColor( 0.25, 0.5, 0.25  )
	rectangle:setStrokeColor( 0, 3, 0 )
	physics.addBody( rectangle, "static", { friction = 1 } )

	physics:pause()

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willShow( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didShow( event )
	local sceneGroup = self.view
	physics:start()
	timer.performWithDelay( 1000,
		function()
			ball:applyLinearImpulse( -10 * ball.mass, 0, ball.x, ball.y )
		end )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willHide( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didHide( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
	ball = nil
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willShow( event )
	elseif( willDid == "did" ) then
		self:didShow( event )
	end
end
function scene:hide( event )
	sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willHide( event )
	elseif( willDid == "did" ) then
		self:didHide( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
