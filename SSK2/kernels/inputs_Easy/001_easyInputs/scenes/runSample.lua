-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  scenes/splash.lua
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

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
--
-- Specialized SSK Features
local actions = ssk.actions
local rgColor = ssk.RGColor

ssk.misc.countLocals(1)

----------------------------------------------------------------------
-- Locals
----------------------------------------------------------------------
local tmpGroup 

----------------------------------------------------------------------
-- Scene Methods
----------------------------------------------------------------------
function scene:create( event )
   local sceneGroup = self.view
   
end

----------------------------------------------------------------------
function scene:willShow( event )
   local sceneGroup = self.view

   local sampleScript = event.params.sampleScript

   tmpGroup = display.newGroup()
   sceneGroup:insert( tmpGroup )
   require(sampleScript).run( tmpGroup )

   local function onHome( event )
      require(sampleScript).stop()

      composer.gotoScene( "scenes.home", 
            { 
               time = 100, 
               effect = "fade"
            } )
      return true
   end
   local homeB = easyIFC:presetPush( sceneGroup, "default", left + 25, top + 25, 50, 50, "X", onHome, { labelColor = _R_, labelFont = _G.fontB, labelSize = 36, strokeWidth = 0 } )
   nextFrame( function() homeB:toFront() end )   
end

----------------------------------------------------------------------
function scene:didShow( event )
   local sceneGroup = self.view
end

----------------------------------------------------------------------
function scene:willHide( event )
   local sceneGroup = self.view

end

----------------------------------------------------------------------
function scene:didHide( event )
   local sceneGroup = self.view
   display.remove(tmpGroup)
   tmpGroup = nil
end

----------------------------------------------------------------------
function scene:destroy( event )
   local sceneGroup = self.view

end

----------------------------------------------------------------------
--				Custom Scene Functions/Methods
----------------------------------------------------------------------


---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------

-- This code splits the "show" event into two separate events: willShow and didShow
-- for ease of coding above.
function scene:show( event )
   local sceneGroup 	= self.view
   local willDid 	= event.phase
   if( willDid == "will" ) then
      self:willShow( event )
   elseif( willDid == "did" ) then
      self:didShow( event )
   end
end

-- This code splits the "hide" event into two separate events: willHide and didHide
-- for ease of coding above.
function scene:hide( event )
   local sceneGroup 	= self.view
   local willDid 	= event.phase
   if( willDid == "will" ) then
      self:willHide( event )
   elseif( willDid == "did" ) then
      self:didHide( event )
   end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene