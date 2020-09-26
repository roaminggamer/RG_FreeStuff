-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local customButtons = {}
local private = {}

function customButtons.attach( buttonLib )
   for k,v in pairs( private ) do
      buttonLib[k] = v
   end
   --table.dump(buttonLib)
end 

--
-- Navigation 
--
-- This button takes 'special' parameters via the 'overrideParams' table:
--   toScene - Full path of scene file to load.
-- isOverlay - Use 'showOverlay', instead of 'gotoScene' for navigation action.
--   options - Table of scene transition options: https://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
--
--
function private.presetNavButton( self, parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
   local _onRelease = onRelease 
   overrideParams = overrideParams or {}

   onRelease = function( event )
      local target = event.target      
      print("In Navigation onRelease()")
      local composer = require "composer"

      -- Is the toScene an overlay?
      if( overrideParams.isOverlay ) then
         composer.showOverlay( overrideParams.toScene, overrideParams.options )      
      -- Nope, its a regular scene.
      else      
         composer.gotoScene( overrideParams.toScene, overrideParams.options )
      end

      if(_onRelease) then _onRelease( event ) end
      return true
   end
   return self:presetPush( parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
end   

--
-- Back 
--
function private.presetBackButton( self, parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
   local _onRelease = onRelease 
   overrideParams = overrideParams or {}

   onRelease = function( event )
      local target = event.target            
      local composer = require "composer"
      local prevScene = composer.getSceneName( "previous" )      
      print("In Back Button onRelease() ", prevScene)

      composer.gotoScene( prevScene, overrideParams.options )
      if(_onRelease) then _onRelease( event ) end
      return true
   end

   return self:presetPush( parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
end   

--
-- Audio 
--
function private.presetAudioButton( self, parentGroup, presetName, x, y, w, h, labelText, onEvent, overrideParams )
   local _onEvent = onEvent 
   overrideParams = overrideParams or {}

   local settingsMgr = require "com.roaminggamer.settingsMgr"

   local soundType = overrideParams.audioCategory or "all_sound"  
   local settingName = ( soundType == "all_sound" ) and "soundEn" or ( ( soundType == "music_only" ) and "musicEn" or "sfxEn" )
   local soundEventName = "on" .. string.first_upper( settingName )

   onEvent = function( event )      
      local target = event.target
      local settingsMgr = require "com.roaminggamer.settingsMgr"      
     
      settingsMgr.set( settingName, not settingsMgr.get( settingName ) )
      post( soundEventName, { enable = settingsMgr.get( settingName ) } )
      print("In Audio Button onEvent()", soundEventName, settingsMgr.get( settingName ) )
      if(_onEvent) then _onEvent( event ) end
      return true
   end

   local button = self:presetToggle( parentGroup, presetName, x, y, w, h, labelText, onEvent, overrideParams )

   if( settingsMgr.get( settingName ) ) then button:toggle(true) end
   post( soundEventName, { enable = settingsMgr.get( settingName ) } )
   print("In Audio Button onEvent()", soundEventName, settingsMgr.get( settingName ) )

   return button
end   

 

--
-- Event 
--
function private.presetEventButton( self, parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
   local _onRelease = onRelease 
   overrideParams = overrideParams or {}

   onRelease = function( event )
      local target = event.target
      print("In Event Button onRelease()")
      if( overrideParams.eventName ) then post( overrideParams.eventName ) end
      if(_onRelease) then _onRelease( event ) end
      return true
   end
   return self:presetPush( parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
end   

--
-- Share 
--
function private.presetShareButton( self, parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
   local _onRelease = onRelease 
   overrideParams = overrideParams or {}

   onRelease = function( event )
      local target = event.target
      print("In Share Button onRelease()")
      if(_onRelease) then _onRelease( event ) end
      return true
   end
   return self:presetPush( parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
end   

--
-- Buy 
--
function private.presetBuyButton( self, parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
   local _onRelease = onRelease 
   overrideParams = overrideParams or {}

   onRelease = function( event )
      local target = event.target
      print("In Buy Button onRelease()")
      if(_onRelease) then _onRelease( event ) end
      return true
   end
   return self:presetPush( parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
end   

--
-- URL 
--
function private.presetURLButton( self, parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
   local _onRelease = onRelease 
   overrideParams = overrideParams or {}

   onRelease = function( event )
      local target = event.target
      print("In URL Button onRelease()")
      if( overrideParams.url ) then system.openURL( overrideParams.url ) end
      if(_onRelease) then _onRelease( event ) end
      return true
   end
   return self:presetPush( parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
end   

--
-- Rate 
--
function private.presetRateButton( self, parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
   local _onRelease = onRelease 
   overrideParams = overrideParams or {}

   onRelease = function( event )
      local target = event.target
      local id = overrideParams.androidRateID
      if( _G.onAmazon ) then
         if( overrideParams.kindleRateID ) then
            id = overrideParams.kindleRateID
         end
      elseif( _G.onAndroid ) then
         if( overrideParams.androidRateID ) then
            id = overrideParams.androidRateID
         end
      elseif( _G.oniOS ) then    
         if( overrideParams.iosRateID ) then
            id = overrideParams.iosRateID
         end
      elseif( _G.onAppleTV ) then      
         if( overrideParams.tvosRateID ) then
            id = overrideParams.tvosRateID
            appName = overrideParams.tvosAppName
            preProcessed = overrideParams.preProcessed
         end
      end

      if( id ) then ssk.easySocial.rate( { id = id, appName = appName, preProcessed = preProcessed } ) end

      if(_onRelease) then _onRelease( event ) end
      return true
   end
   return self:presetPush( parentGroup, presetName, x, y, w, h, labelText, onRelease, overrideParams )
end   




return customButtons