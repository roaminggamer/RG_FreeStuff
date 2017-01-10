-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
--
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local screenGroup
local layers 

-- Callbacks/Functions
local onBack

-- Forward Declarations
local imageRect 		= ssk.display.imageRect
local easyIFC			= ssk.easyIFC
local tern 				= _G.ternary

local getTimer 			= system.getTimer
local sysGetInfo		= system.getInfo
local strMatch 			= string.match
local strFormat 		= string.format

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	screenGroup = self.view

	-- Create some rendering layers
	layers = ssk.display.quickLayers( screenGroup, "underlay", "background", "content", "buttons", "overlay" )

	imageRect( layers.underlay, centerX, centerY, 
	           "images/interface/protoBack.png", 
	           { w = 380, h = 570, rotation = tern( isLandscape, 90, 0 ) } )

	easyIFC:quickLabel( layers.buttons, "Options", centerX, 30, gameFont, 30 )


	local push1 = easyIFC:presetPush( layers.buttons, "default", centerX - 90, 100, 120, 40, "Push 1", onPush )
	local push2 = easyIFC:presetPush( layers.buttons, "default", centerX + 90, 100, 120, 40, "Push 2", onPush, { textColor = {1,1,0,1} } )


	local tog1 = easyIFC:presetToggle( layers.buttons, "defaultcheck", centerX - 135, 170, 35, 35, "1", onToggle, { selTextColor = {1,0,0,1}, selImgFillColor = {1,0,0,1} } )
	local tog2 = easyIFC:presetToggle( layers.buttons, "defaultcheck", centerX - 90, 170, 35, 35, "2", onToggle, { selTextColor = {0,1,0,1}, selImgFillColor = {0,1,0,1},} )
	local tog3 = easyIFC:presetToggle( layers.buttons, "defaultcheck", centerX - 45, 170, 35, 35, "3", onToggle, { selTextColor = {0,0,1,1}, selImgFillColor = {0,0,1,1}, } )

	local radioGroup = display.newGroup()
	layers.buttons:insert(radioGroup)
	local rad1 = easyIFC:presetRadio( radioGroup, "defaultradio", centerX + 45, 170, 35, 35, "A", onRadio, { selTextColor = {1,0,0,1}, selImgFillColor = {1,0,0,1} } )
	local rad2 = easyIFC:presetRadio( radioGroup, "defaultradio", centerX + 90, 170, 35, 35, "B", onRadio, { selTextColor = {0,1,0,1}, selImgFillColor = {0,1,0,1},} )
	local rad3 = easyIFC:presetRadio( radioGroup, "defaultradio", centerX + 135, 170, 35, 35, "C", onRadio, { selTextColor = {0,0,1,1}, selImgFillColor = {0,0,1,1}, } )
	rad1:toggle()

	local aSlider,aKnob = easyIFC:presetSlider( layers.buttons, "defaultslider", 
														 centerX, 250, 250, 16, 
														 --easyIFC.horizSlider2Table_CB, onEffectsVolumeUpdate, { rotation = 0 } )
														easyIFC.horizSlider2Table_CB, nil, { rotation = 0 } )
	--easyIFC.prep_horizSlider2Table( aSlider, options, "sliderField", nil )

	easyIFC:presetPush( layers.buttons, "default", 55, h - 25, 100, 40, "Back", onBack )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:show( event )
	screenGroup 	= self.view
	local willDid 	= event.phase
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:hide( event )
	screenGroup 	= self.view
	local willDid 	= event.phase
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	screenGroup = self.view

	display.remove(layers)
	layers = nil

	screenGroup = nil
end


----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onBack = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}
	composer.gotoScene( "ifc.mainMenu", options  )	

	return true
end


---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------

return scene
