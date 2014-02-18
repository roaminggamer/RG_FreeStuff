-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- SSKCorona Sampler - Generic Scene (used to load all samples)
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
storyboard.isDebug = true
local scene = storyboard.newScene()
local json = require "json"

local gameLogic

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables

-- Callbacks/Functions
local onHome
local doOpenCloseTesting

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
	print("generic_scene: createScene()")
	storyboard.printMemUsage()
	print(NL)

	local screenGroup = self.view
	local params      = event.params

	print(params.logicSource)

	gameLogic = require(params.logicSource)

	gameLogic:createScene( screenGroup )
	ssk.buttons:presetPush( screenGroup, "homeButton", w-26, 24 , 40, 40, "", onHome )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnterScene( event )
	local screenGroup = self.view
	local params      = event.params
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:enterScene( event )
	local screenGroup = self.view
	local params      = event.params

	if( enableOpenCloseTesting  or enableRandomOpenCloseTesting) then
		doOpenCloseTesting()
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:exitScene( event )
	local screenGroup = self.view
	local params      = event.params
	gameLogic:destroyScene( screenGroup )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExitScene( event )
	local screenGroup = self.view
	local params      = event.params
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroyScene( event )
	local screenGroup = self.view
	local params      = event.params

	print("generic_scene: destroyScene()")
	storyboard.printMemUsage()
	print(NL)
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:overlayBegan( event )
	local screenGroup = self.view
	local params      = event.params
	local overlay_name = event.sceneName  -- name of the overlay scene
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:overlayEnded( event )
	local screenGroup = self.view
	local params      = event.params
	local overlay_name = event.sceneName  -- name of the overlay scene
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onHome = function ( event )
	storyboard.gotoScene( "s_MainMenu" , "slideRight", 400  )	
end

doOpenCloseTesting = function()
	-- Below for testing 
	local closure = function() storyboard.gotoScene( "s_MainMenu" , "fade", 0  ) end
	timer.performWithDelay(math.random(openCloseTestingMinDelay,openCloseTestingMaxDelay), closure)
end


---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc.
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

 
