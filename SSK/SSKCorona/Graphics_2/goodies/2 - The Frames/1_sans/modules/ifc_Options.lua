-- =============================================================
-- ifc_Options.lua
-- =============================================================

-- EFM add difficulty roller

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
-- none.


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
-- Load the saved 'options' table if it exists, otherwise create one.
if( io.exists( "options.txt", system.DocumentsDirectory ) ) then
	print("Loading OPTIONS file" )
	_G.options  = table.load( "options.txt" )
end

if( not options ) then
	print("Creating OPTIONS file" )
	_G.options = 
		{ 
		   effectsVolume = 0.25, 
		   musicVolume = 0.25, 
		   difficulty = "Normal",
		   debugEn = true,
   	   }
	table.save( options, "options.txt" )		
end



----------------------------------------------------------------------
-- 3. Declarations
----------------------------------------------------------------------
-- Locals
local layers 

local effectsSlider
local musicSlider

local difficultyLevels = { "Wimpy", "Easy", "Normal", "Hard", "Insane" }

-- Forward Declarations
local create 
local destroy

local onEffectsVolumeUpdate
local onMusicVolumeDraggingUpdate
local onMusicVolumeUpdate

local onDifficultyLevel
local onDebugEn

local onBack

----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------
-- ==
-- create() - Create EFM
-- ==
create = function ( parentGroup )
	local parentGroup = parentGroup or display.currentStage

	-- Create some rendering layers
	layers = ssk.display.quickLayers( parentGroup, "background", "buttons", "overlay" )

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


	transition.from( layers, {alpha = 0, time = sceneCrossFadeTime, onComplete = closure } )
end

-- ==
-- destroy() - Destroy EFM
-- ==
destroy = function ( )
	layers:removeSelf()
	layers = nil
	effectsSlider = nil
	musicSlider = nil

end

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



-- ==
-- onBack() - EFM
-- ==
onBack = function( event ) 
	
	local closure = 
		function()
			destroy()
			ssk.debug.monitorMem()
		end
	transition.to( layers, {alpha = 0, time = sceneCrossFadeTime, onComplete = closure } )	
end



----------------------------------------------------------------------
-- 5. The Module
----------------------------------------------------------------------
local public = {}
public.create  = create
public.destroy = destroy

return public
