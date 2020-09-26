-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- =============================================================
-- Environment
-- =============================================================
local android = {}
_G.ssk = _G.ssk or {}
_G.ssk.android = android

if( _G.onAndroid ) then
   function android.captureBackButton( noCB, yesCB )
      local alert
      local function onComplete( event )
         if "clicked" == event.action then
            local i = event.index
            if 1 == i then
               if( noCB ) then noCB() end
               native.cancelAlert( alert )
               alert = nil
            elseif 2 == i then
               if( yesCB ) then yesCB() end
               native.requestExit()
            end
         end
      end
      local function onKeyEvent( event )
         local phase = event.phase
         local keyName = event.keyName
         if( keyName == "volumeUp" or keyName == "volumeDown") then
            return false 
         elseif( (keyName == "back") and (phase == "down") ) then 
            alert = native.showAlert( "EXIT", "ARE YOU SURE?", { "NO", "YES" }, onComplete )
         end
         return true
      end
      Runtime:addEventListener( "key", onKeyEvent );
   end

   function android.captureVolumeButtons( block, volUp, volDown )
      if( block == nil ) then
         block = true
      end        
      local function onKeyEvent( event )
         local phase = event.phase
         local keyName = event.keyName
         if( keyName == "volumeUp" ) then
            if(volUp) then volUp() end
            return block 
         elseif( keyName == "volumeDown") then
            if(volDown) then volDown() end
            return block 
         end
         return true
      end
      Runtime:addEventListener( "key", onKeyEvent );
   end

   function android.easyAndroidUIVisibility( profile )
      profile = profile or "immersiveSticky"
      local androidVersion = string.sub( system.getInfo( "platformVersion" ), 1, 3)
      if( androidVersion and tonumber(androidVersion) >= 4.4 ) then
         native.setProperty( "androidSystemUiVisibility", profile )
      elseif( androidVersion ) then
         native.setProperty( "androidSystemUiVisibility", "lowProfile" )
      end
   end
else
   function android.captureBackButton() return end
   function android.captureVolumeButtons() return end
   function android.easyAndroidUIVisibility() return end
end

return android