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

-- Forward Declarations

-- Callbacks/Functions

-- Localizations


----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local group = self.view
	display.newText( group, "Scene 1", 160, 240, native.systemFontBold, 40 )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	local nextScene = composer.getSceneName( "previous" )
	print("scene1: nextScene == " .. tostring(nextScene) )

	-- First time we run this, 'nextScene' should be nil
	if( nextScene == nil) then
		nextScene = "scene2"
	end
	timer.performWithDelay( 1000, 
		function()
			composer.gotoScene( nextScene )
		end )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
end


----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
end


----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------


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
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
