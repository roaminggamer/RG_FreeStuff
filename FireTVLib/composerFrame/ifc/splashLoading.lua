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
local lastTimer
local waitTime = 5000 

-- Callbacks/Functions
local onMainMenu

-- Forward Declarations
local imageRect 		= ssk.display.imageRect
local easyIFC			= ssk.easyIFC
local tern 				= _G.ternary
local easyPushButton 	= ssk.easyPush.easyPushButton

local imageRect 		= ssk.display.imageRect
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
	layers = ssk.display.quickLayers( screenGroup, "background", "content", "buttons", "overlay" )

	local backImage
	if( isLandscape ) then
		backImage = imageRect( layers.background, centerX, centerY, "images/interface/protoBack.png", { rotation = 90, w = 380, h = 570 } )
	else
		backImage = imageRect( layers.background, centerX, centerY, "images/interface/protoBack.png", { w = 380, h = 570 } )
	end

	easyIFC:quickLabel( layers.buttons, "Your Awesome Game", centerX, centerY, gameFont, 22 )

	easyPushButton( backImage, onMainMenu, { pressedScale = 1 })

	-- Switch to the Main Menu in 'waitTime' milliseconds
	lastTimer = timer.performWithDelay( waitTime, onMainMenu )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
end
function scene:didEnter( event )
end
function scene:show( event )
	screenGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
end
function scene:didExit( event )
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

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	screenGroup = self.view
	display.remove(layers)
	layers = nil
	lastTimer = nil
	screenGroup = nil
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
