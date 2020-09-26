-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2020 (All Rights Reserved)
-- =============================================================
local hideDelay   = 1 
local fontSize    = 28
local topInset, leftInset, bottomInset, rightInset = display.getSafeAreaInsets()
local lastBanner, lastInterstitial, lastRewardedVideo
--
local public = {}

public.hideBanner = function()
   if( lastBanner ) then
      Runtime:removeEventListener( "enterFrame", lastBanner )
      display.remove(lastBanner)
      lastBanner = nil      
   end
end

public.showBanner = function( provider, id, position, placement, height, width )
   print( "in fake showBanner")
   position = position or "bottom"
   height = height or 72
   width = width or display.actualContentWidth
   if( lastBanner ) then
      Runtime:removeEventListener( "enterFrame", lastBanner )
      display.remove(lastBanner)
      lastBanner = nil
   end
   display.remove( lastBanner )   
   lastBanner = display.newGroup()
   lastBanner.tray = display.newRect( lastBanner, display.contentCenterX, 0, width, height )
   lastBanner.tray:setFillColor(0.5, 0.5, 0.5)
   lastBanner.label = display.newText( lastBanner, "FAKE " .. provider .. " BANNER ", display.contentCenterX, -height/4, native.systemFont, fontSize )   
   lastBanner.label:setFillColor(0)

   if( id and placement ) then
      lastBanner.id = display.newText( lastBanner, "id: " .. tostring(id), display.contentCenterX,  height/4, native.systemFont, fontSize/2 )
      lastBanner.id.anchorY = 1
      lastBanner.id:setFillColor(0)
      if(lastBanner.id.width>(lastBanner.tray.width-20) ) then
         local scale = (lastBanner.tray.width-20)/lastBanner.id.width
         lastBanner.id:scale(scale,scale)
      end
      lastBanner.placement = display.newText( lastBanner, "placement: " .. tostring(placement), display.contentCenterX,  height/4, native.systemFont, fontSize/2 )
      lastBanner.placement.anchorY = 0
      lastBanner.placement:setFillColor(0)
      if(lastBanner.placement.width>(lastBanner.tray.width-20) ) then
         local scale = (lastBanner.tray.width-20)/lastBanner.placement.width
         lastBanner.placement:scale(scale,scale)
      end

   elseif( id ) then
      lastBanner.id = display.newText( lastBanner, "id: " .. tostring(id), display.contentCenterX,  height/4, native.systemFont, fontSize )
      lastBanner.id:setFillColor(0)
      if(lastBanner.id.width>(lastBanner.tray.width-20) ) then
         local scale = (lastBanner.tray.width-20)/lastBanner.id.width
         lastBanner.id:scale(scale,scale)
      end
   end

   if( tonumber(position) ~= nil ) then
      lastBanner.tray.anchorY = 0
      lastBanner.tray.y = position
      lastBanner.label.y = lastBanner.tray.y + height/4
      if( lastBanner.id ) then
         lastBanner.id.y = lastBanner.tray.y + 3*height/4
         if( lastBanner.placement ) then
            lastBanner.placement.y = lastBanner.tray.y + 3*height/4
         end
      else
         lastBanner.label.y = lastBanner.tray.y + height/2
      end

   end

   if( position == "top" ) then
      lastBanner.tray.anchorY = 0
      lastBanner.tray.y = display.contentCenterY - display.actualContentHeight/2 + topInset
      lastBanner.label.y = lastBanner.tray.y + height/4
      if( lastBanner.id ) then
         lastBanner.id.y = lastBanner.tray.y + 3*height/4
         if( lastBanner.placement ) then
            lastBanner.placement.y = lastBanner.tray.y + 3*height/4
         end
      else
         lastBanner.label.y = lastBanner.tray.y + height/2
      end

   elseif( position == "center" ) then
      lastBanner.tray.anchorY = 0
      lastBanner.tray.y = display.contentCenterY - height/2
      lastBanner.label.y = lastBanner.tray.y + height/4
      if( lastBanner.id ) then
         lastBanner.id.y = lastBanner.tray.y + 3*height/4
         if( lastBanner.placement ) then
            lastBanner.placement.y = lastBanner.tray.y + 3*height/4
         end
      else
         lastBanner.label.y = lastBanner.tray.y + height/2
      end


   elseif( position == "bottom" ) then
      lastBanner.tray.anchorY = 1
      lastBanner.tray.y = display.contentCenterY + display.actualContentHeight/2
      lastBanner.label.y = lastBanner.tray.y - 3*height/4
      if( lastBanner.id ) then
         lastBanner.id.y = lastBanner.tray.y - height/4
         if( lastBanner.placement ) then
            lastBanner.placement.y = lastBanner.tray.y - height/4
         end
      else
         lastBanner.label.y = lastBanner.tray.y - height/2
      end
   end
   function lastBanner.enterFrame( self )
      if( self.toFront )  then
         self:toFront() 
      end
   end
   Runtime:addEventListener( "enterFrame", lastBanner )
   function lastBanner.tray.touch() return true end
   lastBanner.tray:addEventListener( "touch" )
end
--
public.showInterstitial = function( provider, id, onComplete, placement )
   if( lastInterstitial ) then
      Runtime:removeEventListener( "enterFrame", lastInterstitial )
      display.remove(lastInterstitial)
      lastInterstitial = nil
   end
   display.remove( lastInterstitial )   
   lastInterstitial = display.newGroup()
   lastInterstitial.tray = display.newRect( lastInterstitial, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
   lastInterstitial.tray:setFillColor(0.5, 0.5, 0.5)
   local tmp = display.newText( lastInterstitial, "FAKE " .. provider .. " INTERSTITIAL ", display.contentCenterX, display.contentCenterY - 150, native.systemFont, fontSize )
   tmp:setFillColor(0)

   if( id ) then
      local tmp = display.newText( lastInterstitial, "id: " .. tostring(id), display.contentCenterX, display.contentCenterY , native.systemFont, fontSize )
      tmp:setFillColor(0)
      if(tmp.width>(display.actualContentWidth-20) ) then
         local scale = (display.actualContentWidth-20)/tmp.width
         tmp:scale(scale,scale)
      end
   end

   if( placement ) then
      local tmp = display.newText( lastInterstitial, "placement: " .. tostring(placement), display.contentCenterX, display.contentCenterY + 80, native.systemFont, fontSize )
      tmp:setFillColor(0)
      if(tmp.width>(display.actualContentWidth-20) ) then
         local scale = (display.actualContentWidth-20)/tmp.width
         tmp:scale(scale,scale)
      end
   end

   local tmp = display.newText( lastInterstitial, "(DOUBLE-TAP TO CLOSE)", display.contentCenterX, display.contentCenterY - 300, native.systemFontBold, fontSize )
   tmp:setFillColor(0)
   function lastInterstitial.enterFrame( self )
      if( self.toFront )  then
         self:toFront() 
      end
   end
   Runtime:addEventListener( "enterFrame", lastInterstitial )
   --
   lastInterstitial.tray.touch = function() return true end
   lastInterstitial.tray:addEventListener("touch")
   --
   function lastInterstitial.tray.tap( self, event ) 
      if( event.numTaps >= 2 ) then
         self.tap = function() return true end 
         timer.performWithDelay( hideDelay,
            function()
               Runtime:removeEventListener( "enterFrame", lastInterstitial )
               display.remove( lastInterstitial )
               lastInterstitial = nil
               onComplete()
            end )            
      end         
      return true 
   end
   lastInterstitial.tray:addEventListener( "tap" )
end

--
public.showRewarded = function( provider, id, onSuccess, onFailure, placement )
   if( lastRewardedVideo ) then
      Runtime:removeEventListener( "enterFrame", lastRewardedVideo )
      display.remove(lastRewardedVideo)
      lastRewardedVideo = nil
   end
   display.remove( lastRewardedVideo )   
   lastRewardedVideo = display.newGroup()
   lastRewardedVideo.tray = display.newRect( lastRewardedVideo, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
   lastRewardedVideo.tray:setFillColor(0.5, 0.5, 0.5)
   local tmp = display.newText( lastRewardedVideo, "FAKE " .. provider .. " REWARDED VIDEO ", display.contentCenterX, display.contentCenterY - 150, native.systemFont, fontSize )
   tmp:setFillColor(0)
   if( id ) then
      local tmp = display.newText( lastRewardedVideo, "id: " .. tostring(id), display.contentCenterX, display.contentCenterY , native.systemFont, fontSize )
      tmp:setFillColor(0)
      if(tmp.width>(display.actualContentWidth-20) ) then
         local scale = (display.actualContentWidth-20)/tmp.width
         tmp:scale(scale,scale)
      end
   end
   if( placement ) then
      local tmp = display.newText( lastRewardedVideo, "placement: " .. tostring(placement), display.contentCenterX, display.contentCenterY + 80, native.systemFont, fontSize )
      tmp:setFillColor(0)
      if(tmp.width>(display.actualContentWidth-20) ) then
         local scale = (display.actualContentWidth-20)/tmp.width
         tmp:scale(scale,scale)
      end
   end

   local tmp = display.newText( lastRewardedVideo, "(DOUBLE-TAP TO CLOSE)", display.contentCenterX, display.contentCenterY - 300, native.systemFontBold, fontSize )
   tmp:setFillColor(0)
   function lastRewardedVideo.enterFrame( self )
      if( self.toFront )  then
         self:toFront() 
      end
   end
   Runtime:addEventListener( "enterFrame", lastRewardedVideo )
   --
   lastRewardedVideo.tray.touch = function() return true end
   lastRewardedVideo.tray:addEventListener("touch")
   --
   function lastRewardedVideo.tray.tap( self, event ) 
      if( event.numTaps >= 2 ) then
         self.tap = function() return true end
         timer.performWithDelay( hideDelay,
            function()
               Runtime:removeEventListener( "enterFrame", lastRewardedVideo )
               display.remove( lastRewardedVideo )
               lastRewardedVideo = nil
               
               ssk.misc.easyAlert( "Select Rewarded Reponse", "Which rewardeded video response do you want to simulate?",
                  { {"Failure", onFailure }, {"Success", onSuccess }, } )

            end )
      end         
      return true 
   end
   lastRewardedVideo.tray:addEventListener( "tap" )
end

-- Attach to ssk
_G.ssk = _G.ssk or {}
_G.ssk.fakeAdsHelper = public
return public
