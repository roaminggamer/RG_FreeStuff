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
local readStory


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

	--layers.content.x = left + 40 --layers.content.x + 40
	--layers.content.y = top + 40

	-- Create a simple background
	local back = display.newImageRect( layers.underlay, "images/fillT.png", 380*2, 570*2 )
	back.x = centerX
	back.y = centerY

	back.touch = function( self, event )
		if( event.phase == "began" ) then
			display.currentStage:setFocus( self, event.id )
			self.isFocus = true
			self.x0 = event.x
			self.y0 = event.y
			return true
		
		elseif( self.isFocus ) then
			local dx = event.x - self.x0
			local dy = event.y - self.y0
			self.x0 = event.x
			self.y0 = event.y
			--print(dx,dy)
			post("onEditDrag", { dx = dx, dy = dy } )
			--self.x = self.x0 + dx
			--self.y = self.y0 + dy
			if( event.phase == "ended" ) then
				display.currentStage:setFocus( self, nil )
				self.isFocus = false
			end
			return true
		end
		return false
	end; back:addEventListener("touch")

	

	local function doEvent( event )
		local eventName = event.target.eventName
		--print(eventName)
		post(eventName, { target = event.target })
	end

	local function onToggleAutoSave( event )
		local eventName = event.target.eventName
		post(eventName, { target = event.target })
		persist.set( "editorSettings.json", "autoSave", event.target:pressed() )
	end

	newRect( layers.overlay, centerX, top + 20, { w = fullw, h = 40, fill = _DARKGREY_, stroke = _DARKERGREY_, strokeWidth = 2})
	newRect( layers.overlay, centerX, bottom - 20, { w = fullw, h = 40, fill = _DARKGREY_, stroke = _DARKERGREY_, strokeWidth = 2})

	-- Buttons
	local tmp = easyIFC:presetPush( layers.overlay, "superpack_default", left + 45, top + 20, 80, 30, "home", doEvent )
	tmp.eventName = "onHome"
	local tmp = easyIFC:presetPush( layers.overlay, "superpack_default", left + 45 + 1 * 90, top + 20, 80, 30, "new", doEvent )
	tmp.eventName = "onNewPage"
	local tmp = easyIFC:presetPush( layers.overlay, "superpack_default", left + 45 + 2 * 90, top + 20, 80, 30, "Delete", doEvent )
	tmp.eventName = "onDeleteSelected"

	local tmp = easyIFC:presetToggle( layers.overlay, "superpack_default", left + 45 + 3 * 90, top + 20, 80, 30, "AutoSave", onToggleAutoSave )
	tmp.eventName = "onToggleAutoSave"

	if( persist.get( "editorSettings.json", "autoSave" ) ) then
		tmp:toggle(true)
	end


	local tmp = easyIFC:presetPush( layers.overlay, "superpack_default", right - 45 - 2 * 90, top + 20, 80, 30, "Zoom In", doEvent )
	tmp.eventName = "onZoomIn"

	local tmp = easyIFC:presetPush( layers.overlay, "superpack_default", right - 45 - 1 * 90, top + 20, 80, 30, "Zoom Out", doEvent )
	tmp.eventName = "onZoomOut"
	
	local read = easyIFC:presetPush( layers.overlay, "superpack_default", right - 45, top + 20, 80, 30, "read", readStory )

	local editor = require "scripts.editor"
	editor.create( layers.content )
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
readStory = function()
	local options =
	{
		effect = "fade", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 100,
		params = { arg1 = "value",  arg2 = 0  }
	}
	composer.gotoScene( "ifc.readerScene", options  )	
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
