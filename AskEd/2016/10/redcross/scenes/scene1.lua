local composer       = require( "composer" )
local scene          = composer.newScene()

----------------------------------------------------------------------
-- Locals & Forward Declarations
----------------------------------------------------------------------
local onTouch 

----------------------------------------------------------------------
-- Scene Methods
----------------------------------------------------------------------
function scene:create( event )
   local sceneGroup = self.view
   local background = display.newRect( sceneGroup, centerX, centerY, fullw, fullh )
   background:setFillColor( 0.2, 0.8, 0.5 )
   local title = display.newText( sceneGroup, "Scene 1", centerX, top + 50, 
                                  native.systemFontBold, 36 )

   local msg = display.newText( sceneGroup, "Touch Screen To Go To Scene 2", centerX, bottom - 50, 
                                  native.systemFontBold, 36 )

   background.touch = onTouch
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
onTouch = function( event )
   composer.gotoScene( "scenes.scene2", 
      { 
         time = 250, 
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