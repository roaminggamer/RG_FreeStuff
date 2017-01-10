-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Play GUI
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local inputs		= require "scripts.inputs"
local common 		= require "scripts.common"

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables

-- Forward Declarations
local onBack

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
end



----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	--table.print_r(event)
	common.layers = ssk.display.quickLayers( sceneGroup, "underlay", "content", "overlay" )
	local layers = common.layers

	--common.curLevel = 1


	local levelCounter = common.createLevelCounter( layers.overlay )
	common.createHelpButton( layers.overlay )
	--common.createSharingButtons( layers.overlay )

	local game = {}
	local games = {}
	for i = 1, 8 do
		game[i] = require( "scripts.game" .. i)
		games[#games+1] = game[8]
	end



	--games[#games+1] = game[7]
	--games[#games+1] = game3
	--games[#games+1] = game3
	--games[#games+1] = game3

	local function onCorrect()
		print("GOOD JOB!")
		common.curLevel = common.curLevel + 1
		if( common.curLevel > #games ) then
			common.curLevel = 1
		end
		transition.to(layers.overlay, { alpha = 1, time = 250 } )
		levelCounter.text = "Level: " .. common.curLevel		

		timer.performWithDelay( 500,
			function()
				transition.to(layers.overlay, { alpha = 0, time = 250 } )
				games[common.curLevel].run( 2000 )		
			end )
	end
	listen( "onCorrect", onCorrect )
	local function onIncorrect()
		print("DERP!")
		transition.to(layers.overlay, { alpha = 1, time = 250 } )

		timer.performWithDelay( 2000,
			function()
				transition.to(layers.overlay, { alpha = 0, time = 250 } )
				games[common.curLevel].run( 2000 )		
			end )
	end
	listen( "onIncorrect", onIncorrect )


	games[common.curLevel].run( 2000 )

	transition.to(layers.overlay, { alpha = 0, time = 250 } )

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
	display.remove( layers )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onBack = function ( self, event ) 
	local options =
	{
		effect = "fromTop", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "ifc.mainMenu", options  )	
	return true
end

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end
function scene:hide( event )
	sceneGroup 	= self.view
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
