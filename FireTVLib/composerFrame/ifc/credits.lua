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
local ignoreFTVInputs = true
local onFTVKey

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

	easyIFC:quickLabel( layers.buttons, "Credits", centerX, 30, gameFont, 30 )

	easyIFC:presetPush( layers.buttons, "default", 55, h - 25, 100, 40, "Back (b)", onBack )
end


----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	ignoreFTVInputs = false
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	ignoreFTVInputs = true
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
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

onFTVKey = function( event )
	if(ignoreFTVInputs) then return false end

	local keyName = event.keyName
	local phase = event.phase
	if( phase ~= "ended" ) then return false end

	if( keyName == "back" ) then
		onBack()
		return true
	else
		print( "Detected key: ", keyName, " not currently mapped in this interface.")
	end


	return false
end

Runtime:addEventListener( "onFTVKey", onFTVKey )



---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	screenGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end

function scene:hide( event )
	screenGroup 	= self.view
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
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------

return scene
