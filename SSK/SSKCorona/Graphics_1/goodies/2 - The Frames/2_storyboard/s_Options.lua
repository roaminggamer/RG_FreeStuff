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

local effectsSlider
local musicSlider

local difficultyLevels = { "Wimpy", "Easy", "Normal", "Hard", "Insane" }

-- Callbacks/Functions
local onEffectsVolumeUpdate
local onMusicVolumeDraggingUpdate
local onMusicVolumeUpdate

local onDifficultyLevel
local onDebugEn

local onBack

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

	-- Add dummy touch catcher to backImage to keep touches from 'falling through'
	backImage.touch = function() return true end
	backImage:addEventListener( "touch", backImage )


	if(build_settings.orientation.default == "landscapeRight") then		
		-- Labels and Buttons
		ssk.labels:quickLabel( layers.buttons, "Options", centerX, 40, nil, 40 )
	
		-- Effects Volume
		local tmp = ssk.labels:quickLabel( layers.buttons, "Effects Volume", 90, centerY - 60, nil, 20 )
		local effectsSlider,knob = ssk.buttons:presetSlider( layers.buttons, "defaultslider", 
															 tmp.x + 220, tmp.y, 250, 16, 
															 ssk.sbc.horizSlider2Table_CB, onEffectsVolumeUpdate, { rotation = 0 } )
		ssk.sbc.prep_horizSlider2Table( effectsSlider, options, "effectsVolume", nil )


		-- Music Volume
		local tmp = ssk.labels:quickLabel( layers.buttons, "Music Volume", 90, centerY , nil, 20 )
		local musicSlider,knob = ssk.buttons:presetSlider( layers.buttons, "defaultslider", 
														   tmp.x + 220, tmp.y, 250, 16, 
														   ssk.sbc.horizSlider2Table_CB, onMusicVolumeUpdate, { rotation = 0 } )
		ssk.sbc.prep_horizSlider2Table( musicSlider, options, "musicVolume", onMusicVolumeDraggingUpdate )


		-- Difficulty Level
		local tmp = ssk.labels:quickLabel( layers.buttons, "Difficulty Level", 90, centerY + 60 , nil, 20 )
		local tmpButton = ssk.buttons:presetPush( layers.buttons, "default", 
												  tmp.x + 145, tmp.y, 100, 30, 
												  options.difficulty, 
								     			  ssk.sbc.table2TableRoller_CB, { fontSize = 16, textOffset = {0,1} } )	
		ssk.sbc.prep_table2TableRoller( tmpButton, options, "difficulty", difficultyLevels, onDifficultyLevel ) 

		-- Debug Enable/Disable
		local tmp = ssk.labels:quickLabel( layers.buttons, "Debug", centerX + 100, centerY + 60 , nil, 20 )
		local tmpButton = ssk.buttons:presetToggle( layers.buttons, "defaultcheck", 
													tmp.x + 70, tmp.y, 30, 30, "", 
													ssk.sbc.tableToggler_CB )	
		ssk.sbc.prep_tableToggler( tmpButton, options, "debugEn", onDebugEn ) 

	else
		-- Labels and Buttons
		ssk.labels:quickLabel( layers.buttons, "Options", centerX, 40, nil, 40 )
	
		-- Effects Volume
		local tmp = ssk.labels:quickLabel( layers.buttons, "Effects Volume", 60, centerY - 60, nil, 16 )
		local effectsSlider,knob = ssk.buttons:presetSlider( layers.buttons, "defaultslider", 
															 tmp.x + 155, tmp.y, 180, 16, 
															 ssk.sbc.horizSlider2Table_CB, onEffectsVolumeUpdate, { rotation = 0 } )
		ssk.sbc.prep_horizSlider2Table( effectsSlider, options, "effectsVolume", nil )


		-- Music Volume
		local tmp = ssk.labels:quickLabel( layers.buttons, "Music Volume", 60, centerY , nil, 16 )
		local musicSlider,knob = ssk.buttons:presetSlider( layers.buttons, "defaultslider", 
														   tmp.x + 155, tmp.y, 180, 16, 
														   ssk.sbc.horizSlider2Table_CB, onMusicVolumeUpdate, { rotation = 0 } )
		ssk.sbc.prep_horizSlider2Table( musicSlider, options, "musicVolume", onMusicVolumeDraggingUpdate )


		-- Difficulty Level
		local tmp = ssk.labels:quickLabel( layers.buttons, "Difficulty Level", 60, centerY + 60 , nil, 16 )
		local tmpButton = ssk.buttons:presetPush( layers.buttons, "default", 
												  tmp.x + 115, tmp.y, 100, 30, 
												  options.difficulty, 
								     			  ssk.sbc.table2TableRoller_CB, { fontSize = 16, textOffset = {0,1} } )	
		ssk.sbc.prep_table2TableRoller( tmpButton, options, "difficulty", difficultyLevels, onDifficultyLevel ) 

		-- Debug Enable/Disable
		local tmp = ssk.labels:quickLabel( layers.buttons, "Debug", 60, centerY + 120 , nil, 16 )
		local tmpButton = ssk.buttons:presetToggle( layers.buttons, "defaultcheck", 
													tmp.x + 75, tmp.y, 30, 30, "", 
													ssk.sbc.tableToggler_CB )	
		ssk.sbc.prep_tableToggler( tmpButton, options, "debugEn", onDebugEn ) 

	end
	-- Back Button
	ssk.buttons:presetPush( layers.buttons, "default", 55, h-25, 100, 40, "Back", onBack )


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
	effectsSlider = nil
	musicSlider = nil

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

onEffectsVolumeUpdate = function( event )
	local target = event.target
	table.save( options, "options.txt" )		
	ssk.gem:post( "EFFECTS_VOLUME_CHANGE" )
	ssk.gem:post( "PLAY_EFFECT" , { effectName = "good" } )
	return false
end

onMusicVolumeDraggingUpdate = function( event )
	local target = event.target
	-- EFM optionaly: modify audio channel volume for music
	ssk.gem:post( "MUSIC_VOLUME_CHANGE" )
	ssk.sounds:setMusicVolume( options.musicVolume )
	return false
end

onMusicVolumeUpdate = function( event )
	local target = event.target
	table.save( options, "options.txt" )
	ssk.gem:post( "MUSIC_VOLUME_CHANGE" )
	ssk.sounds:setMusicVolume( options.musicVolume )
	return false
end


-- ==
-- onDifficultyLevel() - EFM
-- ==
onDifficultyLevel = function( event )
	local target = event.target
	local myText = target:getText()
	table.save( options, "options.txt" )		
	print(myText .. " ==> " .. myText)
end

-- ==
-- onDifficultyLevel() - EFM
-- ==
onDebugEn = function( event )
	local target = event.target

	print(target:pressed())
	table.save( options, "options.txt" )		
end



onBack = function ( event ) 
	ssk.debug.monitorMem()
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
