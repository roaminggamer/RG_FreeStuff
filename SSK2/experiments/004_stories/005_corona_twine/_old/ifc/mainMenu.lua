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

	local tmp = easyIFC:quickLabel( layers.buttons, "Main Menu", centerX, 30, gameFont, 30 )
	tmp.xScale = -1
	transition.to( tmp, { xScale = 1, delay = 1500, time = 1600, transition = easing.outBounce})


	local tmp1 = easyIFC:presetPush( layers.buttons, "default", centerX, centerY - 50, 200, 40, "Play", onPlay, { labelSize = 24, labelColor = _RED_ } )
	local tmp2 = easyIFC:presetPush( layers.buttons, "default", centerX, centerY, 200, 40, "Credits", onCredits, { labelSize = 24, labelColor = _GREEN_ } )
	local tmp3 = easyIFC:presetPush( layers.buttons, "default", centerX, centerY + 50, 200, 40, "Options", onOptions, { labelSize = 24, labelColor = _BLUE_ } )

	easyIFC.easyFlyIn( tmp1, { delay = 500, time = 700, sox = -w, easing = easing.outBack } )
	easyIFC.easyFlyIn( tmp2, { delay = 750, time = 700, sox = w, easing = easing.outBack } )
	easyIFC.easyFlyIn( tmp3, { delay = 1000, time = 700, sox = -w, easing = easing.outBack } )
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
onPlay = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}

	composer.gotoScene( "ifc.playGUI", options  )	

	return true
end

onCredits = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}

	composer.gotoScene( "ifc.credits", options  )	

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

	composer.gotoScene( "ifc.options", options  )	

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
