-- =============================================================
local composer       = require( "composer" )
local scene          = composer.newScene()
----------------------------------------------------------------------
-- Forward Declarations
----------------------------------------------------------------------
local onBack
local enterFrameWorker

----------------------------------------------------------------------
-- Locals
----------------------------------------------------------------------
local content
local interface
local delayedWork
local canWork = false
local curStep
local completionIndicator

----------------------------------------------------------------------
-- scene:create( event ) - Called on first scene open ONLY (unless
-- the scene has been manually or automatically destroyed.)
----------------------------------------------------------------------
function scene:create( event )
   local sceneGroup = self.view
   ssk.display.newImageRect( sceneGroup, centerX, centerY, "protoBack.png",
                             { w = 760, h = 1140 } )

   content = display.newGroup()
   interface = display.newGroup()
   sceneGroup:insert( content )
   sceneGroup:insert( interface )

   content.isVisible = false
   interface.isVisible = false

   ssk.easyIFC:presetPush( interface, "default", centerX, centerY, 300, 60, "Back", onBack )

   completionIndicator = ssk.display.newRect( sceneGroup, centerX, centerY, { w = 300, h = 40, fill = _DARKGREY_ } )
   completionIndicator.bar = ssk.display.newRect( sceneGroup, centerX - 148, centerY, { anchorX = 0, w = 296, h = 36, fill = _G_ } )
   completionIndicator.bar.xScale = 0.001

end

----------------------------------------------------------------------
-- scene:willShow( event ) - Replaces the scene:show() method.  This
-- method is called during the "will" phase of scene:show().
----------------------------------------------------------------------
function scene:willShow( event )
   local sceneGroup = self.view

   canWork = false
   curStep = 1
   delayedWork = {}

   local dummy = require "dummyWorkload"
   for i = 1, _G.workloadIterations do
      local closure = function()
         dummy[math.random(1,4)](content)
      end
      delayedWork[#delayedWork+1] = closure
   end
   local closure = function()
      dummy[2](content)
   end
   delayedWork[#delayedWork+1] = closure

   timer.performWithDelay( 500,  function() canWork = true end )
   
   Runtime:addEventListener( "enterFrame", enterFrameWorker )
   

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
   display.remove(content)
   display.remove(interface)
   content = nil
   interface = nil
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
--          Custom Scene Functions/Methods
----------------------------------------------------------------------
onBack = function( event )
   composer.showOverlay( "home", { time = 500, isModal = true, effect = "slideLeft", params = params } )
end

getTimer = system.getTimer
enterFrameWorker = function()   
   if( not canWork ) then return end

   completionIndicator.bar.xScale = curStep/#delayedWork

   local startT = getTimer()
   local curT   = getTimer()
   local maxT   = 2
   while( ( curStep <= #delayedWork ) and ( curT - startT < maxT ) ) do
      
      delayedWork[curStep]()
      curT   = getTimer()
      curStep = curStep + 1
   end

   if( curStep > #delayedWork ) then
      Runtime:removeEventListener( "enterFrame", enterFrameWorker )
      timer.performWithDelay( 250, 
         function()
            content.isVisible = true
            interface.isVisible = true
            display.remove( completionIndicator.bar )
            display.remove( completionIndicator )
            completionIndicator = nil
         end )
   end
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