-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  splash.lua
-- =============================================================

local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local w = display.contentWidth
local h = display.contentHeight
local fullw = display.actualContentWidth
local fullh = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local buttonWidth     = display.actualContentWidth/3
local buttonHeight    = buttonWidth/ 3
local tweenButtons    = buttonHeight/2 + buttonHeight/5
local fontSize   	  = math.floor( buttonHeight/2 )

local splashDelay = 5000 -- Wait 5 seconds, then go to main menu

-- Forward Declarations
local onMainMenu

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	-- Create a simple background
	local back = display.newRect( sceneGroup, centerX, centerY, fullw * 4, fullw * 4 )
	back:setFillColor( 0, 0, 0 )

	-- Create a label showing which scene this is
	local label = display.newText( sceneGroup, "Splash", centerX, centerY, native.systemFont, fontSize * 2 )
	label:setFillColor( 0.8, 1, 1  )

	-- Automatically Go to main menu in 2 seconds 
	--
	local timerHandle = timer.performWithDelay( splashDelay, onMainMenu )

	-- If user touches back, go to main menu early.
	--
	back.touch = function( self, event )
		if(event.phase == "ended") then
			-- Be sure to cancel the outstanding timer
			timer.cancel(timerHandle)

			-- Go to the main menu
			onMainMenu()
		end
		return true
	end
	back:addEventListener( "touch" )	

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
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
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
onMainMenu = function()
	local options =
	{
		effect = "slideLeft", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "ifc.mainMenu", options  )	
end


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
