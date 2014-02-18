-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- =============================================================
--
-- =============================================================

local storyboard = require( "storyboard" )
local scene      = storyboard.newScene()
local mlText = require "mltext"

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
	layers = ssk.display.quickLayers( screenGroup, "background", "buttons", "code", "overlay" )

	local backImage
	--[[
	backImage = display.newImage( layers.background, "images/interface/backImage.jpg" )
	if(build_settings.orientation.default == "landscapeRight") then
		backImage.rotation = 90
	end
	--]]
	backImage = display.newRect(layers.background, 0, 0, w*2 ,h*2 )
	backImage.x = centerX
	backImage.y = centerY

	backImage.touch = function(self, event) 
		if( event.phase == "began" ) then
			layers.code.y0 =  layers.code.y
			self.dragged = false

		elseif( event.phase == "moved" ) then
			layers.code.y = layers.code.y0 + (event.y - event.yStart)				
			self.dragged = true
		
		elseif(event.phase == "ended") then 
			if(not self.dragged) then 
				return onBack() 
			end
		 end
		
		return true
	end
	backImage:addEventListener( "touch", backImage )

	backImage.x = w/2
	backImage.y = h/2

	local overlayImage
	overlayImage = display.newImage( layers.overlay, "images/interface/protoOverlay.png" )
	if(build_settings.orientation.default == "landscapeRight") then
		overlayImage.rotation = 90
	end

	overlayImage.x = w/2
	overlayImage.y = h/2

	local demoFiles = {}

	-- ==
	-- GLOBALS
	-- ==
	demoFiles["Display"]			= "globals/display"
	demoFiles["Color"]				= "globals/color"
	demoFiles["Environment"]		= "globals/environment"
	demoFiles["fnn()"]				= "globals/fnn"
	demoFiles["isDisplayObject()"]	= "globals/isDisplayObject"
	demoFiles["randomColor()"]		= "globals/randomColor"
	demoFiles["round()"]			= "globals/round"
	demoFiles["safeRemove()"]		= "globals/safeRemove"


	-- ==
	-- GLOBALS
	-- ==
	demoFiles["io"]					= "extensions/io"
	demoFiles["math"]				= "extensions/math"
	demoFiles["string"]				= "extensions/string"
	demoFiles["table"]				= "extensions/table"
	demoFiles["timer"]				= "extensions/timer"
	demoFiles["transition"]			= "extensions/transition"
	
	-- ==
	-- CLASSES
	-- ==
	--demoFiles["Collision Calculator"]		= "classes/cc"
	--demoFiles["Buttons"]					= "classes/buttons"

	demoFiles["Push"]						= "classes/push"
	demoFiles["Radio"]						= "classes/radio"
	demoFiles["Toggle"]						= "classes/toggle"
	demoFiles["Sliders"]					= "classes/sliders"
	demoFiles["Presets"]					= "classes/presets"
	demoFiles["Standard Callbacks"]			= "classes/sbc"
	demoFiles["Preset"]						= "classes/labels"
	demoFiles["Quick"]						= "classes/labels"
	demoFiles["Snap"]						= "classes/snap"
	demoFiles["Joystick/DPad"]				= "classes/joy"

	demoFiles["Parameterized"]				= "classes/displayobjects"
	demoFiles["Bodies"]						= "classes/bodies"
	demoFiles["Lines and Arrows"]			= "classes/linesNArrows"
	demoFiles["Layers"]						= "classes/layers"
	demoFiles["Collision Calculator"]		= "classes/cc"
	demoFiles["Text"]						= "classes/huds_text"
	demoFiles["Timer"]						= "classes/huds_text"
	demoFiles["Image Counters"]				= "classes/huds_image"
	demoFiles["Percentage Bars"]			= "classes/huds_pbars"
	demoFiles["Percentage Dials"]			= "classes/huds_pdials"

	demoFiles["2D Math"]					= "classes/2dmath"
	demoFiles["Global Event Manager"]		= "classes/gem"
	demoFiles["Points"]						= "classes/linesNArrows"
	demoFiles["Portable Random Numbers"]	= "classes/prand"
	demoFiles["XML Parser"]					= "classes/xml"
	demoFiles["Debug Utilities"]			= "classes/debugutils"
	demoFiles["Game Piece"]					= "classes/gamepiece"
	demoFiles["Image Sheet Mgr"]			= "classes/sheetmgr"
	demoFiles["Sound Mgr"]					= "classes/sndmgr"
	demoFiles["Actions"]					= "classes/actions"
	demoFiles["Networking"]					= "classes/networking"
	
	

	--demoFiles["EFM"] = "EFM"

	local logicSource = event.params.logicSource
	
	print("***** ", logicSource, demoFiles[logicSource])
	if(demoFiles[logicSource]) then
		local data = io.readFileTable( "demoSrc/" .. demoFiles[logicSource] .. ".txt", system.ResourceDirectory )

		table.dump(data)

		local mlString = ""
		for i = 1, #data do
			mlString = mlString .. data[i] .. "<br>"
		end

		local params =
			{
				font = "Courier New",
				fontSize = 12,
				fontColor = { 0, 0, 0 },
				spaceWidth = 6,
				lineHeight = 16,
				linkColor1 = {0,0,255},
				linkColor2 = {255,0,255},
			}

		local tmp = mlText.newMLText( mlString, 10, 0, params )
		layers.code:insert( tmp )

		print(platformVersion, olderVersion)
	end	
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

	storyboard.hideOverlay( true, "fade", 200  )	

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
