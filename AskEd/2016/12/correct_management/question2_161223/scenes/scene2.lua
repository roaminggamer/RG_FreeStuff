-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  
-- =============================================================
local composer       = require( "composer" )
local scene          = composer.newScene()

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
local rgColor = ssk.RGColor
--ssk.misc.countLocals(1)


   -- Init physics
   local physics = require "physics"
   physics.start()
   physics.setGravity(0,0)


----------------------------------------------------------------------
-- Forward Declarations
----------------------------------------------------------------------
local goBack

----------------------------------------------------------------------
-- Locals
----------------------------------------------------------------------
local cycleDelay = 550 -- Wait this long, then exit scene.  i.e. Should be 550 or higher as not to overlap easing time.
local maxCount   = 10

local layers 

local player

----------------------------------------------------------------------
-- Scene Methods
----------------------------------------------------------------------
function scene:create( event )
   local sceneGroup = self.view

   -- Capture memory usage on:
   -- FIRST LOAD OF THIS SCENE BEFORE CREATING CONTENT
   -- 
   if( _G.sceneStartedCount == nil ) then
      collectgarbage("collect") -- Collect garbage every frame to get 'true' current memory usage
      _G.initialMem = collectgarbage( "count" )    

      _G.sceneStartedCount = 0 

   end

   -- Capture memory usage on:
   -- SECOND LOAD OF THIS SCENE BEFORE CREATING CONTENT
   --
   -- This more truely expresses what memory usage we should see on the final iteration.
   -- 
   if( _G.sceneStartedCount and _G.sceneStartedCount == 1 ) then
      collectgarbage("collect") -- Collect garbage every frame to get 'true' current memory usage
      _G.secondMem = collectgarbage( "count" )    
   end


   -- Incrment 'scene started' counter
   _G.sceneStartedCount = (_G.sceneStartedCount == nil) and 0 or _G.sceneStartedCount
   _G.sceneStartedCount = _G.sceneStartedCount + 1


   -- Capture memory usage on:
   -- LAST LOAD OF THIS SCENE BEFORE CREATING CONTENT
   -- 
   if( _G.sceneStartedCount == maxCount ) then
      collectgarbage("collect") -- Collect garbage every frame to get 'true' current memory usage
      _G.finalMem = collectgarbage( "count" )       
   end


   -- Create Layers For This Scene
   layers = quickLayers( sceneGroup, 
      "underlay", 
      "world",
         {  "background", 
            "content", 
            "foreground" },
      "overlay" )


   local background = newRect( layers.underlay, centerX, centerY, 
                               { w = fullw, h = fullh, fill = hexcolor("0082C7") } )

   local title = easyIFC:quickLabel( layers.overlay, "Scene 2; count == " .. _G.sceneStartedCount,  
                                     centerX, bottom - 10, 
                                     ssk.gameFont(), 50, 
                                     _K_, 0.5, 1 )

   --
   -- Show Result or Make Fake Content
   --
   if( _G.initialMem and _G.finalMem ) then
      --
      -- Show memory usage result
      --
      local tray = newRect( layers.overlay, left + 150, centerY, { w = 300, h = 200, fill = _K_ } )
      easyIFC:quickLabel( layers.overlay, "Initial Mem == " .. round(_G.initialMem/(1024),3) .. " MB",  
                                          tray.x, tray.y - 60, nil, 12 )
      easyIFC:quickLabel( layers.overlay, "Final Mem == " .. round(_G.finalMem/(1024),3) .. " MB",  
                                          tray.x, tray.y - 40, nil, 12 )
      easyIFC:quickLabel( layers.overlay, "Memory Delta == " .. round((_G.finalMem-_G.initialMem)/(1024),3) .. " MB",  
                                          tray.x, tray.y - 20, nil, 12 )


      easyIFC:quickLabel( layers.overlay, "Second Mem == " .. round(_G.secondMem/(1024),3) .. " MB",  
                                          tray.x, tray.y + 20, nil, 12 )
      easyIFC:quickLabel( layers.overlay, "Final Mem == " .. round(_G.finalMem/(1024),3) .. " MB",  
                                          tray.x, tray.y + 40, nil, 12 )
      easyIFC:quickLabel( layers.overlay, "True Memory Delta == " .. round((_G.finalMem-_G.secondMem)/(1024),3) .. " MB",  
                                          tray.x, tray.y + 60, nil, 12 )

   else
      -- 
      -- Create fake scene w/ content, player, and camera
      --

      --
      -- 1. Create 5000 circles in random locations to act as stuff in our 'world'
      --
      for i = 1, 5000 do
         newCircle( layers.background, 
                    mRand( -4 * fullw, 4 * fullw ),
                    mRand( -4 * fullh, 4 * fullh ),
                    { size = mRand( 20,40 ), alpha = 0.5,
                      fill = ssk.colors.pastelRGB( ssk.colors.randomRGB() ) } )
      end

      -- Create a joystick to move our 'player'
      --
      ssk.easyInputs.oneStick.create( layers.overlay , 
                                      { joyParams = { doNorm = true } } )

      -- Create a player with a 'enterFrame' listener to 'move' it.
      --
      local function enterFrame( self, event )  
         self:setLinearVelocity( self.vx, self.vy )
      end
      player = newImageRect( layers.content, centerX, centerY, 
                                    "images/rg256.png", 
                                    { enterFrame = enterFrame,
                                       vx = 0, vy = 0 }, {} )

      -- Add a joystick listener to the player
      function player.onJoystick( self, event ) 
         if( event.state == "off" ) then
            self.vx = 0
            self.vy = 0
         else
            self.vx = event.nx * 500 * event.percent/100
            self.vy = event.ny * 500 * event.percent/100
         end
      end; listen( "onJoystick", player )

      -- ***************************************
      -- Attach a Tracking Camera To Player + World
      -- ***************************************
      ssk.camera.tracking( player, layers.world )
   end

end

----------------------------------------------------------------------
function scene:willShow( event )
  local sceneGroup = self.view
end

----------------------------------------------------------------------
function scene:didShow( event )
   local sceneGroup = self.view

   -- If we didn't reach the maximum count, go back to scene 1
   if( _G.sceneStartedCount < maxCount ) then
      timer.performWithDelay( cycleDelay, goBack )
   end

end

----------------------------------------------------------------------
function scene:willHide( event )
   local sceneGroup = self.view
end

----------------------------------------------------------------------
function scene:didHide( event )
   local sceneGroup = self.view

   ignoreList( { "enterFrame", "onJoystick" }, player )
   player:stopCamera() -- https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/camera/#stopping-cameras
   --display.remove(layers)
   layers = nil

   composer.removeScene( "scenes.scene2" )

end

----------------------------------------------------------------------
function scene:destroy( event )
   local sceneGroup = self.view
end

----------------------------------------------------------------------
--          Custom Scene Functions/Methods
----------------------------------------------------------------------
goBack = function( event )
   local options = 
   { 
      time     = 250, 
      effect   = "slideRight"
   }
   
   composer.gotoScene( "scenes.scene1", options )
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