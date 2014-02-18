-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- =============================================================
--
-- =============================================================

local storyboard = require( "storyboard" )
local scene      = storyboard.newScene()

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local screenGroup
local layers 
local lastTimer
local waitTime = 2000 

-- Callbacks/Functions
local onMainMenu

----------------------------------------------------------------------
--	Scene Methods:
-- scene:createScene( event )  - Called when the scene's view does not exist
-- scene:willEnterScene( event ) -- Called BEFORE scene has moved onscreen
-- scene:enterScene( event )   - Called immediately after scene has moved onscreen
-- scene:exitScene( event )    - Called when scene is about to move offscreen
-- scene:didExitScene( event ) - Called AFTER scene has finished moving offscreen
-- scene:destroyScene( event ) - Called prior to the removal of scene's "view" (display group)
-- scene:overlayBegan( event ) - Called if/when overlay scene is displayed via storyboard.showOverlay()
-- scene:overlayEnded( event ) - Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
----------------------------------------------------------------------
function scene:createScene( event )
	screenGroup = self.view

	-- Create some rendering layers
	layers = ssk.display.quickLayers( screenGroup, "background", "buttons", "overlay" )

	local backImage
	if(build_settings.orientation.default == "landscapeRight") then
		backImage = display.newImage( layers.background, "images/interface/RGSplash1_Landscape.jpg" )
	else
		backImage = display.newImage( layers.background, "images/interface/RGSplash1_Portrait.jpg" )
	end

	backImage.x = w/2
	backImage.y = h/2

	-- Add a touch listener that will switch to the main menu immediately on 'tap'
	backImage.touch = function( self, event )
		
		-- Only do something if the finger is lifted, AND
		-- if the timer handle has not yet been cleared.
		if( event.phase == "ended" and lastTimer ) then
			onMainMenu()
		end

		return true
	end
	
	backImage:addEventListener( "touch", backImage )

	local overlayImage
	overlayImage = display.newImage( layers.overlay, "images/interface/protoOverlay.png" )
	if(build_settings.orientation.default == "landscapeRight") then
		overlayImage.rotation = 90
	end

	overlayImage.x = w/2
	overlayImage.y = h/2

	-- Switch to the Main Menu in 'waitTime' milliseconds
	lastTimer = timer.performWithDelay( waitTime, onMainMenu )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnterScene( event )
	screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:enterScene( event )
	screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:exitScene( event )
	screenGroup = self.view	
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExitScene( event )
	screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroyScene( event )
	screenGroup = self.view
	layers:removeSelf()
	layers = nil
	lastTimer = nil
	screenGroup = nil
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:overlayBegan( event )
	screenGroup = self.view
	local overlay_name = event.sceneName  -- name of the overlay scene
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:overlayEnded( event )
	screenGroup = self.view
	local overlay_name = event.sceneName  -- name of the overlay scene
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onMainMenu = function ( event ) 

	if(lastTimer) then 
		timer.cancel( lastTimer )
		lastTimer = nil
	end
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_MainMenu", options  )	

	return true
end

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "didExitScene", scene )
scene:addEventListener( "destroyScene", scene )
scene:addEventListener( "overlayBegan", scene )
scene:addEventListener( "overlayEnded", scene )
---------------------------------------------------------------------------------

return scene
