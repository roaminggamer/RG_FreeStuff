-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  scenes/splash.lua
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
-- Locals
----------------------------------------------------------------------
local centerX  = display.contentCenterX
local centerY  = display.contentCenterY
local fullw    = display.actualContentWidth
local fullh    = display.actualContentHeight
local left     = centerX - fullw/2
local right    = centerX + fullw/2
local top      = centerY - fullh/2
local bottom   = centerY + fullh/2


----------------------------------------------------------------------
-- Improved Scene Methods
----------------------------------------------------------------------
--
-- Tip: This composer template is slightly different from the "standard" template found here:
-- https://docs.coronalabs.com/daily/api/library/composer/index.html#scene-template
--
-- I have split the scene:show() and scene:hide() methods into these distinct sub-methods:
--
-- * scene:willShow() - Called in place of "will" phase of scene:show().
-- * scene:didShow()  - Called in place of "did" phase of scene:show().
-- * scene:willHide()  - Called in place of "will" phase of scene:hide().
-- * scene:didHide()   - Called in place of "did" phase of scene:hide().
--
-- I did this to help folks logically separate the phases and for those converting from storyboard.* which
-- had similar methods.
--
----------------------------------------------------------------------

----------------------------------------------------------------------
-- scene:create( event ) - Called on first scene open ONLY (unless
-- the scene has been manually or automatically destroyed.)
----------------------------------------------------------------------
function scene:create( event )
   local sceneGroup = self.view
   
   -- Create a simple background using a colored rectangle
   -- https://docs.coronalabs.com/daily/api/library/display/newRect.html
   local background = display.newRect( sceneGroup, centerX, centerY, fullw, fullh )
   -- https://docs.coronalabs.com/daily/api/type/ShapeObject/setFillColor.html
   background:setFillColor( 0.2, 0.5, 0.8 )

   -- Create a label showing the game title (Splash for now...)
   -- https://docs.coronalabs.com/daily/api/library/display/newText.html#syntax-legacy
   local title = display.newText( sceneGroup, "Splash", centerX, centerY, native.systemFontBold, 36 )

   -- Wait 5 seconds and go automatically to the home scene (main menu)
   -- https://docs.coronalabs.com/daily/api/library/timer/performWithDelay.html
   local lastTimer = timer.performWithDelay( 5000,
      function()
         -- https://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
         composer.gotoScene( "scenes.home", { time = 500, effect = "crossFade" } )
      end )

   -- Allow the player to touch the screen to go directly to the home scene
   function background.touch( self, event )      
      if( event.phase == "began" ) then
         -- Cancel the outstanding timer
         -- https://docs.coronalabs.com/daily/api/library/timer/cancel.html
         timer.cancel( lastTimer )

         -- Go to the home scene
         -- https://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
         composer.gotoScene( "scenes.home", { time = 500, effect = "crossFade" } )
      end
   end
   background:addEventListener( "touch" )

end

----------------------------------------------------------------------
-- scene:willShow( event ) - Replaces the scene:show() method.  This
-- method is called during the "will" phase of scene:show().
----------------------------------------------------------------------
function scene:willShow( event )
   local sceneGroup = self.view

end

----------------------------------------------------------------------
-- scene:didShow( event ) - Replaces the scene:show() method.  This
-- method is called during the "did" phase of scene:show().
----------------------------------------------------------------------
function scene:didShow( event )
   local sceneGroup = self.view

end

----------------------------------------------------------------------
-- scene:willHide( event ) - Replaces the scene:hide() method.  This
-- method is called during the "will" phase of scene:hide().
----------------------------------------------------------------------
function scene:willHide( event )
   local sceneGroup = self.view

end

----------------------------------------------------------------------
-- scene:didHide( event ) - Replaces the scene:hide() method.  This
-- method is called during the "did" phase of scene:hide().
----------------------------------------------------------------------
function scene:didHide( event )
   local sceneGroup = self.view

end

----------------------------------------------------------------------
-- scene:destroy( event ) - Called automatically by Composer scene library
-- to destroy the contents of the scene (based on settings and memory constraints):
-- https://docs.coronalabs.com/daily/api/library/composer/recycleOnSceneChange.html
--
-- Also called if you manually call composer.removeScene()
-- https://docs.coronalabs.com/daily/api/library/composer/removeScene.html
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