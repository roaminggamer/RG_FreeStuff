-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  
-- =============================================================
local composer       = require( "composer" )
local scene          = composer.newScene()

local onBegin

local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
local easyIFC = ssk.easyIFC

----------------------------------------------------------------------
-- Scene Methods
----------------------------------------------------------------------
function scene:create( event )
   local sceneGroup = self.view

   local background = newRect( sceneGroup, centerX, centerY, 
                               { w = fullw, h = fullh, fill = hexcolor("0082C7") } )

   local oy = 0
   if( ssk.meters ) then
      oy = 40
      easyIFC:quickLabel( sceneGroup, "Wait For Meters To Initialize",  centerX, centerY - oy, ssk.gameFont(), 32, _K_ )
   end
   easyIFC:quickLabel( sceneGroup, "Then Tap Screen To Start Demo",  centerX, centerY + oy , ssk.gameFont(), 32, _K_ )

   background.touch = function( self, event )
      if( event.phase == "ended" ) then
         onBegin()
      end
      return true
   end
   background:addEventListener( "touch" )

end

----------------------------------------------------------------------
function scene:willShow( event )
   local sceneGroup = self.view
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

end

----------------------------------------------------------------------
function scene:destroy( event )
   local sceneGroup = self.view
end

----------------------------------------------------------------------
--          Custom Scene Functions/Methods
----------------------------------------------------------------------
onBegin = function( )

   composer.gotoScene( "scenes.scene1", 
      { 
         time = 100, 
         effect = "fade",
      } ) 
end

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------

-- This code splits the "show" event into two separate events: willShow and didShow
-- for ease of coding above.
function scene:show( event )
   local sceneGroup  = self.view
   local willDid  = event.phase
   if( willDid == "will" ) then
      self:willShow( event )
   elseif( willDid == "did" ) then
      self:didShow( event )
   end
end

-- This code splits the "hide" event into two separate events: willHide and didHide
-- for ease of coding above.
function scene:hide( event )
   local sceneGroup  = self.view
   local willDid  = event.phase
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