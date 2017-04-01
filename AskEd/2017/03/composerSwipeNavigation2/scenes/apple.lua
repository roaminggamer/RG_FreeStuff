-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Splash Screen
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local widget = require("widget")
require( "scripts.pushButtonClass" )

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local w 			= display.contentWidth
local h 			= display.contentHeight
local fullw			= display.actualContentWidth 
local fullh			= display.actualContentHeight
local centerX 		= display.contentCenterX
local centerY 		= display.contentCenterY
local isLandscape 	= (w>h)

-- Forward Declarations

-- Useful Localizations
local getTimer          = system.getTimer
local pairs             = pairs

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
	-- Create a simple background
	local back = display.newImageRect( sceneGroup, "images/back1.jpg", 320, 480 )
	back.x = centerX
	back.y = centerY
	if(isLandscape) then back.rotation = 90 end

	-- Create a label showing which scene this is
	local label = display.newText( sceneGroup, "A is for Apple", centerX, centerY-100, native.systemFont, 30 )
	label:setFillColor( 1,0,0 )

	-- Picture of fruit
	local pic = display.newImageRect( sceneGroup, "images/apple.png", 200, 200 )
	pic.x = centerX
	pic.y = centerY + 50

	-- Create an action event and hook it to a button
	local function onAction( self, event )
		transition.cancel(pic)
		pic.rotation = 45
		transition.to( pic, { rotation = 0, time = 1000, transition = easing.outBounce } )
	end
	local buttonGroup = display.newGroup()
	PushButton( buttonGroup, centerX, centerY + fullh/2 - 30, "Action", onAction )

	local function listener()
		return false
	end

	local scrollView = widget.newScrollView({
		width = fullw,
		height = fullh,
		x = centerX,
		y = centerY,
		horizontalScrollDisabled = true,
		hideBackground = true,
		listener = listener
	})
	scrollView:addEventListener("tap", function() return false end)

	sceneGroup:insert(scrollView)
	
	scrollView:insert( label )
	--label.x = (fullw-100)/2
	label.y = label.y - 100

	scrollView:insert(pic)
	--pic.x = (fullw-100)/2
	pic.y = pic.y - 100

	scrollView:insert(buttonGroup)

	-- Create a swiper on this page ONLY
	local swiper = composer.createSwipe( nil, {alwaysTo = "front"} )
	scrollView:insert( swiper )

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	local sceneGroup = self.view
	composer.enableSwipe( true )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
	composer.enableSwipe( false )
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------


---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end
function scene:hide( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willExit( event )
	elseif( willDid == "did" ) then
		self:didExit( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
