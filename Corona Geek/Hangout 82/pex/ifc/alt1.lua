-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
--
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local json 			= require "json"

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

local pdAltLoader = require "scripts.pdAltLoader"

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:show( event )
	screenGroup 	= self.view
	local willDid 	= event.phase

	if( willDid == "will") then
		layers = ssk.display.quickLayers( screenGroup, "underlay", "background", "content", "buttons", "overlay" )
		imageRect( layers.underlay, centerX, centerY, 
		           "images/interface/protoBack.png", 
		           { w = 380, h = 570, rotation = tern( isLandscape, 90, 0 ) } )
		easyIFC:quickLabel( layers.buttons, "Alternative Particle Examples", centerX, 15, gameFont, 14 )
		easyIFC:quickLabel( layers.buttons, "http://onebyonedesign.com/flash/particleeditor/", centerX, 35, gameFont, 14 )
		
		easyIFC:presetPush( layers.buttons, "default", 55, h - 25, 100, 40, "Back", onBack )


		local example = {
			{ src = "particle1", x = 70, y = 100, size = 100, ex = 0, ey = 0 },
			{ src = "particle2", x = 180, y = 100, size = 100, ex = 0, ey = 0 },
			{ src = "particle4", x = 360, y = 170, size = 240, ex = 20, ey = -10 },

			{ src = "particle3", x = 70, y = 210, size = 100, ex = 0, ey = 20 },
			{ src = "particle5", x = 180, y = 210, size = 100, ex = 0, ey = 0 },
		}

		for i = 1, #example do
			local pd = example[i]
			local tmp = pdAltLoader( layers.content, pd.x, pd.y, pd.src, { ex = pd.ex, ey = pd.ey, width = pd.size, imageRoot = "PD_Alternative/",  } )
		end
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:hide( event )
	screenGroup 	= self.view
	local willDid 	= event.phase

	if( willDid == "did") then
		display.remove(layers)
		layers = nil
		screenGroup = nil
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	screenGroup = self.view
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
	composer.gotoScene( "ifc.menu", options  )	

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
