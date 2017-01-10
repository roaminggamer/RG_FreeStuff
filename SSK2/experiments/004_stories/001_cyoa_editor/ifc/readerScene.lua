-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Splash Screen
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

local coronaTwine 	= require "scripts.coronaTwine"
local values		= require "scripts.values"
local parser 		= require "scripts.parser"
local pu 			= require "scripts.parse_utils"


----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables


-- Forward Declarations
local editStory
local layers
local purgeListeners

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


end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view

	layers = ssk.display.quickLayers( sceneGroup, "underlay", "content", "overlay" )

	-- Create a simple background
	local back = display.newImageRect( layers.underlay, "images/fillT.png", 380*2, 570*2 )
	back.x = centerX
	back.y = centerY

	easyIFC:presetPush( layers.overlay, "default", right - 45, top + 20, 80, 30, "edit", editStory )


	local data = table.load( "testStory.json", system.DocumentsDirectory )
	print("Loaded story?")
	local passages = pu.extractPassages( data )
	local story = pu.createStory( passages )
	pu.setStory( story )


	print("=============================")
	print("=============================")
	--table.print_r( data )
	--table.dump( passages )
	--print("=============================")
	--table.print_r( passages["start"] )
	--print("=============================")
	--table.print_r( passages["embeddedtarget"] )

	
	--table.print_r( story )
	--[[	
	local function willEnterPage( event )
		print(event.name,event.target,event.time)
		--table.dump(event)
	end; listen( "willEnterPage", willEnterPage )

	local function didEnterPage( event )
		print(event.name,event.target,event.time)
		--table.dump(event)
	end; listen( "didEnterPage", didEnterPage )

	local function willExitPage( event )
		print(event.name,event.target,event.time)
		--table.dump(event)
	end; listen( "willExitPage", willExitPage )

	local function didExitPage( event )
		print(event.name,event.target,event.time)
		--table.dump(event)
	end; listen( "didExitPage", didExitPage )
	--]]

	local group = pu.displayPage( "Start" )

	layers.content:insert( group )

	local function onNavigate( event )
		table.dump(event)
		group = pu.displayPage( event.target, group  )
		layers.content:insert( group )
	end; listen( "onNavigate", onNavigate )

	purgeListeners = function()
		ignore( "onNavigate", onNavigate )
	end

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
	purgeListeners()
	display.remove(layers)
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
editStory = function()
	local options =
	{
		effect = "fade", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 100,
		params = { arg1 = "value",  arg2 = 0  }
	}
	composer.gotoScene( "ifc.editorScene", options  )	
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
