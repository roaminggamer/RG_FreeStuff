-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  scenes/play.lua
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
-- Forward Declarations
----------------------------------------------------------------------
local easySceneButton

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
   background:setFillColor( 0.25, 0.25, 0.25 )

   -- Create a label showing this is the home screen
   -- https://docs.coronalabs.com/daily/api/library/display/newText.html#syntax-legacy
   local title = display.newText( sceneGroup, "Play", centerX, centerY, native.systemFontBold, 36 )
   title.anchorY = 0

   -- Create a back button to take us back home.  (Make sure it is always snugged in the upper-left corner.)
   --
   -- Tip: We forward declared easySceneButton() near the top of the file, and
   --      implemented it later, near the bottom.  This keeps the scene file clean and well organized.
   --
   --      In reality you will probably use another means of creating buttons, but this works for now, and
   --      it demonstrates some useful coding techniques.

   -- Go to home
   easySceneButton( sceneGroup, left + 50, top + 25, "Home", "scenes.home" )

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

-- ==
-- Is the center of obj over obj2 (inside its axis aligned bounding box?)
-- ==
local function isInBounds( obj, obj2 )

   if(not obj2) then return false end

   local bounds = obj2.contentBounds
   if( obj.x > bounds.xMax ) then return false end
   if( obj.x < bounds.xMin ) then return false end
   if( obj.y > bounds.yMax ) then return false end
   if( obj.y < bounds.yMin ) then return false end
   return true
end


-- ==
--
-- Shared touch listener for our buttons.
--
-- All of the buttons do basically the same thing except they send us to different scenes.
-- So, why write unique code for each one, when with a little smarts we can use one listener instead?
--
-- ==
local function onTouch( self, event )
   local phase = event.phase
   if( event.phase == "began" ) then
      -- https://docs.coronalabs.com/daily/api/type/ShapeObject/setFillColor.html
      self:setFillColor( 1, 1, 0 )
      self.label:setFillColor( 0, 0, 0 )

      -- Be sure all future events associated with this touch go ONLY to
      -- this button.
      --
      -- Tip: We do this to allow for more complex button behavior.  See below...
      --
      -- Tip 2: This code is multitouch ready.
      --
      self.isFocus = true
      display.currentStage:setFocus( self, event.id )

   elseif( self.isFocus ) then
      -- Update the fill of the button and label according to the current
      -- position of the users finger.
      if( isInBounds( event, self ) ) then
         -- https://docs.coronalabs.com/daily/api/type/ShapeObject/setFillColor.html
         self:setFillColor( 1, 1, 0 )
         self.label:setFillColor( 0, 0, 0 )
      else
         -- https://docs.coronalabs.com/daily/api/type/ShapeObject/setFillColor.html
         self:setFillColor( 0.8, 0.8, 0 )
         self.label:setFillColor( 1, 1, 1  )
      end

      if( phase == "ended" or phase == "canceled" ) then

         -- Stop sending touch events to this function
         self.isFocus = false
         display.currentStage:setFocus( self, nil )

         -- Reset the button and label fills
         -- https://docs.coronalabs.com/daily/api/type/ShapeObject/setFillColor.html
         self:setFillColor( 0.8, 0.8, 0 )
         self.label:setFillColor( 1, 1, 1  )
        

         -- Go to the scene that this button is configured for...
         --
         -- See easySceneButton() function below to see where toScene is assigned to 
         -- each button.
         --
         -- https://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
         if( isInBounds( event, self ) ) then
            composer.gotoScene( self.toScene, { time = 500, effect = "crossFade" } )
         end
      end

   end

   -- Stop touch from propagating to objects 'below' the button
   return true 
end


-- ==
-- A basic push button builder.
-- ==
easySceneButton = function( group, x, y, labelText, toScene  )

   -- Draw a simple rectangle as the button.
   -- https://docs.coronalabs.com/daily/api/library/display/newRect.html
   local button = display.newRect( group, x, y, 100, 50 )
   -- https://docs.coronalabs.com/daily/api/type/ShapeObject/setFillColor.html
   button:setFillColor(  0.8, 0.8, 0 )
   -- https://docs.coronalabs.com/daily/api/type/ShapeObject/strokeWidth.html
   button.strokeWidth = 2
   -- https://docs.coronalabs.com/daily/api/type/ShapeObject/setStrokeColor.html
   button:setStrokeColor(0,0,0)

   -- Add a label
   -- https://docs.coronalabs.com/daily/api/library/display/newText.html#syntax-legacy
   button.label = display.newText( group, labelText, x, y, native.systemFontBold, 28 )

   -- Tell this button where it should take us if pressed
   button.toScene = toScene

   -- Attach the shared touch listener
   -- Tip: This is a very efficient way of coding when you have multiple objects 
   -- that effectively do the same thing with a small change for each instance.
   --
   button.touch = onTouch
   button:addEventListener( "touch" )
end


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