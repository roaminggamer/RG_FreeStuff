-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Splash Screen
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables


-- Forward Declarations
local goToPlayGUI


-- =============================================================
-- Localizations
-- =============================================================
-- Lua
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs
local strMatch = string.match; local strGSub = string.gsub; local strSub = string.sub
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale


----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
	local layers = ssk.display.quickLayers( sceneGroup, "underlay", "content", "overlay" )


	-- Create a simple background
	local back = display.newImageRect( layers.underlay, "images/fillT.png", 380*2, 570*2 )
	back.x = centerX
	back.y = centerY
	if(w>h) then back.rotation = 90 end


	easyIFC:quickLabel( layers.content, "Circles", centerX, centerY - 80, gameFont, 60 ) --, hexcolor("#dbf5cf")  )
	easyIFC:quickLabel( layers.content, "Count", centerX, centerY , gameFont, 60 ) --, hexcolor("#dbf5cf")  )
	easyIFC:quickLabel( layers.content, "(Squares Don't)", centerX, centerY + 80, gameFont, 40 ) --, hexcolor("#dbf5cf")  )


	-- Automatically Go to main menu in 2 seconds 
	--
	local timerHandle = timer.performWithDelay( 2000, goToPlayGUI )

	-- If user touches back, go to main menu early.
	--
	back.touch = function( self, event )
		if(event.phase == "ended") then
			timer.cancel(timerHandle)
			goToPlayGUI()
		end
		return true
	end
	back:addEventListener( "touch" )	

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
goToPlayGUI = function()
	local options =
	{
		effect = "slideUp", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 1000,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "ifc.playGUI", options  )	
end


---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end
function scene:hide( event )
	local sceneGroup 	= self.view
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
