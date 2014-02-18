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


-- Callbacks/Functions
local onGlobals
local onExtensions
local onClasses
local onGoodies

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

	--ssk.labels:quickLabel( layers.buttons, "SSKCorona", centerX, 40, gameFont, 30 )

	local tmp = ssk.display.image( layers.buttons, centerX, 35, "images/SSKCorona.png", {xScale = 1.4, yScale = 1.4}  )



	local backImage
	if(build_settings.orientation.default == "landscapeRight") then
		backImage = display.newImage( layers.background, "images/interface/RGSplash2_Landscape.jpg" )
	else
		backImage = display.newImage( layers.background, "images/interface/RGSplash2_Portrait.jpg" )
	end

	backImage.x = w/2
	backImage.y = h/2

	local overlayImage
	overlayImage = display.newImage( layers.overlay, "images/interface/protoOverlay.png" )
	if(build_settings.orientation.default == "landscapeRight") then
		overlayImage.rotation = 90
	end

	overlayImage.x = w/2
	overlayImage.y = h/2

	-- Create Menu Buttons
	ssk.buttons:presetPush( layers.buttons, "default", centerX, centerY - 50, 160, 40, "Globals", onGlobals )
	ssk.buttons:presetPush( layers.buttons, "default", centerX, centerY , 160, 40, "Extensions", onExtensions )
	ssk.buttons:presetPush( layers.buttons, "default", centerX, centerY + 50, 160, 40, "'Classes'", onClasses )
	ssk.buttons:presetPush( layers.buttons, "default", centerX, centerY + 100, 160, 40, "Goodies", onGoodies )

	ssk.debug.monitorMem()
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
onGlobals = function ( event ) 
	local options =	{ effect = "fromRight",	time = 200	}
	storyboard.gotoScene( "s_Globals", options  )	
	return true
end

onExtensions = function ( event ) 
	local options =	{ effect = "fromRight",	time = 200	}
	storyboard.gotoScene( "s_Extensions", options  )	
	return true
end

onClasses = function ( event ) 
	local options =	{ effect = "fromRight",	time = 200	}
	storyboard.gotoScene( "s_Classes1", options  )	
	return true
end

onGoodies = function ( event ) 
	local options =	{ effect = "fromRight",	time = 200	}
	storyboard.gotoScene( "s_Goodies", options  )	
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
