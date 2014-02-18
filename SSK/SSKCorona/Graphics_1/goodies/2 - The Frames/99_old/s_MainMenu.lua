-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- SSKCorona Sampler Main Menu
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
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
-- Flags modifying main menu operation and layout


-- Variables
local screenGroup
local layers -- Local reference to display layers 
local backImage 

local playButton 


-- Callbacks/Functions
local createLayers
local addInterfaceElements

local onPlay
local onCredits
local onRG
local onCorona

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

	createLayers()
	addInterfaceElements()
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
	storyboard.printMemUsage()
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

	layers:destroy()
	layers = nil
	playButton = nil
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
-- createLayers() - Create layers for this scene
createLayers = function( )
	layers = ssk.display.quickLayers( screenGroup, "background", "interfaces" )
end

-- addInterfaceElements() - Create interfaces for this scene
addInterfaceElements = function( )

	-- Background Image
	backImage   = ssk.display.backImage( layers.background, "protoBack2.png" ) 

	-- ==========================================
	-- Buttons and Labels
	-- ==========================================
	local curY
	local tmpButton
	local tmpLabel

	-- Game Label / Name
	ssk.labels:presetLabel( layers.interfaces, "default", "Game Name Here", centerX, 30, { fontSize = 32 } )

	-- Version Label
	ssk.labels:presetLabel( layers.interfaces, "default", "Last Modified: " .. releaseDate, centerX, h-10, { fontSize = 12, textColor = _WHITE_ } )

	-- PLAY 
	curY = centerY - 75
	playButton = ssk.buttons:presetPush( layers.interfaces, "default", centerX, curY, 200, 40,  "Play", onPlay )

	-- CREDITS
	curY = centerY + 75
	ssk.buttons:presetPush( layers.interfaces, "default", centerX, curY, 200, 40,  "Credits", onCredits ) 

	-- RG Button
	ssk.buttons:presetPush( layers.interfaces, "RGButton", 30, h-30, 40, 40, "", onRG  )

	-- Corona Badge/Button
	ssk.buttons:presetPush( layers.interfaces, "CoronaButton", w-30, h-30, 108/3, 150/3, "", onCorona  )
end	


onPlay = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 300,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_PlayGUI", options  )	

	return true
end


onOptions = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_Options", options  )	

	return true
end


onCredits = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 400,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_Credits", options  )	

	return true
end


onRG = function(event)
	system.openURL( "http://roaminggamer.com/"  )
	return true
end

onCorona = function(event)
	system.openURL( "http://www.coronalabs.com/"  )
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
