-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- revmob_helpers.lua
-- =============================================================
--[[

   Includes these functions:

   revmob_helpers.setID( os, adType, id ) - Set an id manually (do before init if at all).
   revmob_helpers.init( [delay [, autoStartOnResume ] ] ) - Initialize ads with optional delay.  
      If second argument is 'true', helper will automatically (re-) start session on each resume.

   revmob_helpers.startSession( ) - Re-connect to RevMob.

   revmob_helpers.loadBanner() - Load banner ad.
   revmob_helpers.loadInterstitial() - Load interstitial ad.
   revmob_helpers.loadVideo() - Load basic video ad.
   revmob_helpers.loadRewardedVideo() - Load rewarded video ad.

   revmob_helpers.showBanner( [ position [, targetingOptions ] ] ) - Show banner ad.
   revmob_helpers.showInterstitial( [ targetingOptions ] ) - Show interstitial ad.
   revmob_helpers.showVideo( [ targetingOptions ] ) - Show basic video ad.
   revmob_helpers.showRewardedVideo( [ targetingOptions ] ) - Show rewarded video ad.

   revmob_helpers.isLoadedBanner() - Returns true if banner ad is loaded.
   revmob_helpers.isLoadedInterstitial() - Returns true if interstitial ad is loaded.
   revmob_helpers.isLoadedVideo() - Returns true if video ad is loaded.
   revmob_helpers.isLoadedRewardedVideo() - Returns true if rewarded video ad is loaded.
   revmob_helpers.hide( ) - Hide any showing revMob ad.

   revmob_helpers.testStatus( phase ) - Returns true if phase has been triggered in listener.
   revmob_helpers.clearStatus( phase ) - Clear the flag for the named 'phase'

   revmob_helpers.setPhaseCB( phase [, cb [, once ] ] ) - Provide a special callback to execute when the 
      listener event 'phase' occurs.  If once is set to 'true', the callback is called once then cleared.

--]]
-- =============================================================
-- =============================================================
local revmob = require( "plugin.revmob" )

local lastID -- Set 'on show' to simplify call to hide

local debugLevel = 0
local function dPrint( level, ... )
   if( level <= debugLevel ) then
      print( unpack( arg ) )
   end
end


local revmob_helpers = {}

function revmob_helpers.setDebugLevel( newLevel )
   debugLevel = newLevel or 0 
end


-- Place to store phase callback records [see: revmob_helpers.setPhaseCB()]
--
local phaseCallbacks = {}

-- Special statuses (based on phases and other actions)
--[[
]]
local status  = {}
revmob_helpers.status = status
function revmob_helpers.testStatus( phase )
   return fnn(status[phase], false)
end
function revmob_helpers.clearStatus( phase )
   status[phase] = false
end

-- ==
--    Table of ids, separated by OS and type (banner or interstitial)
-- ==
local ids = 
{ 
   android = 
   { 
      banner         = ANDROID_BANNER_ID, 
      interstitial   = ANDROID_INTERSTITIAL_ID,
      video          = ANDROID_VIDEO_ID,
      rewarded       = ANDROID_REWARDED_ID
   },
   ios = 
   { 
      banner         = IOS_BANNER_ID, 
      interstitial   = IOS_INTERSTITIAL_ID,
      video          = IOS_VIDEO_ID,
      rewarded       = IOS_REWARDED_ID
   },
}

-- ==
--    RevMob Listener 
-- ==
local function listener( event ) 
   -- Extract base set of useful event details:
   local isError     = (event.isError == nil) and false or event.isError
   local phase       = (event.phase == nil) and "unknown" or event.phase   
   local eType       = (event.type == nil) and "unknown" or event.type   
   local response    = (event.name == nil) and "unknown" or event.response
   local provider    = (event.provider == nil) and "unknown" or event.provider

   dPrint( 3, "RevMob Listener Event @ ", system.getTimer )
   dPrint( 3, 'isError: ' .. tostring( isError ) .. '; phase == "' .. tostring(phase) .. '"; response == "' .. tostring(response) .. '"' )

   -- Do something with the above details...
   --
   if( isError ) then
      dPrint( 1,  "RevMob is getting errors.")
      for k,v in pairs( event ) do
         dPrint( 1, k,v)
      end
   
   else

      -- Note: There may be more phases.
      if( phase == "init" ) then 
      elseif( phase == "sessionStarted" ) then
      elseif( phase == "loaded" ) then
      elseif( phase == "displayed" ) then
      elseif( phase == "failed" ) then
      elseif( phase == "videoPlaybackBegan" ) then
      elseif( phase == "videoCompleted" ) then
      elseif( phase == "rewardedVideoPlaybackBegan" ) then
      elseif( phase == "rewardedVideoCompleted" ) then
      elseif( phase == "hidden" ) then
      else        
         dPrint( 1,  "RevMob is getting a weird event.phase value?! ==> " .. tostring( event.phase ) )
         for k,v in pairs( event ) do
            dPrint( 1, k,v)
         end
      end
      status[phase or "error"] = true
      local cb = phaseCallbacks[phase]
      if( cb ) then
         cb.cb(event)
         if(cb.once) then
            phaseCallbacks[phase] = nil
         end
      end
   end
end

-- =============================================================
-- setID( os, adType, id ) - Set an id for a specific OS and ad type
--
-- os - 'android' or 'ios'
-- adType - 'banner', 'interstitial', 'video', 'rewarded'
-- id - Must be a valid ID
--
-- =============================================================
function revmob_helpers.setID( os, adType, id )
   ids[os][adType] = id
end

-- =============================================================
-- setPhaseCB( phase [, cb [, once]] ) - Set up custom callback/listener
--    to call when the named 'phase' occurs.
--
--         phase - String containing name of phase this callback goes with.
--    cb ('nil') - Callback (listener) function (see below for example.)
-- once ('true') - If 'true', callback is called once, then cleared automatically.
--
--  Example callback definition:
--
--[[

    local function onInit( event )
      dPrint( 3, "Init phase completed!")
      table.dump(event)
   end

   revmob_helpers.setPhaseCB( "init", onInit, true )

]]
--
-- =============================================================
function revmob_helpers.setPhaseCB( phase, cb, once )
   once = fnn( once, true )
   phaseCallbacks[phase] = (cb) and { cb = cb, once = once } or nil
end

-- =============================================================
-- init( [ delay, autoStartOnResume ] ] ) - Initilize revMob ad network.
--   If delay is specified, wait 'delay' ms then initialize.
--   If second argument is 'true', the helper will automtically call
--   revmob_helpers.startSession() after each suspend/resume.
--
-- https://docs.coronalabs.com/daily/plugin/revmob/init.html
-- =============================================================
function revmob_helpers.init( delay, autoStartOnResume )

   autoStartOnResume = fnn( autoStartOnResume, true )

   -- Set default delay if not provided
   delay = delay or 0 
   
   -- A function that we may call immediately or with a delay
   -- to do the initialization work.
   local function doInit()

      -- If on Android,
      if( onAndroid ) then
         
         -- and a rewarded ID was provided, then init with it
         if( ids.android.rewarded ) then
            revmob.init( listener, { appId = ids.android.rewarded } )

         -- or a video ID was provided, then init with it
         elseif( ids.android.video ) then
            revmob.init( listener, { appId = ids.android.video } )

         -- or a interstial ID was provided, then init with it
         elseif( ids.android.interstitial ) then
            revmob.init( listener, { appId = ids.android.interstitial } )

         -- or a banner id was supplied and init with it
         elseif( ids.android.banner ) then
            revmob.init( listener, { appId = ids.android.banner } )

         end

      -- else if on iOS,
      elseif( oniOS ) then 

         -- and a rewarded ID was provided, then init with it
         if( ids.ios.rewarded ) then
            revmob.init( listener, { appId = ids.ios.rewarded } )

         -- or a video ID was provided, then init with it
         elseif( ids.ios.video ) then
            revmob.init( listener, { appId = ids.ios.video } )

         -- or a interstial ID was provided, then init with it
         elseif( ids.ios.interstitial ) then
            revmob.init( listener, { appId = ids.ios.interstitial } )

         -- or a banner id was supplied and init with it
         elseif( ids.ios.banner ) then
            revmob.init( listener, { appId = ids.ios.banner } )

         end
      end

   end

   -- Auto (re-) start on resume?
   --
   if( autoStartOnResume == true ) then
      local function onSystemEvent( event )
         if ( event.type == "applicationResume" ) then      
            revmob_helpers.startSession()
         end
      end
      Runtime:addEventListener( "system", onSystemEvent )
   end

   -- Initialize immediately or wait a little while?
   --
   if( delay < 1 ) then
      doInit()
   else
      timer.performWithDelay( delay, doInit )
   end

end

-- =============================================================
-- startSession() -- (Re-) start vungle session.
--
-- https://docs.coronalabs.com/daily/plugin/revmob/startSession.html
-- =============================================================
function revmob_helpers.startSession(  )
   revmob.startSession()
end

-- =============================================================
-- loadBanner() -- Load a banner if we can.
-- loadInterstitial() -- Load an interstitial if we can.
-- loadVideo() -- Load a video if we can.
-- loadRewardedVideo() -- Load a rewarded video if we can.
--
-- https://docs.coronalabs.com/daily/plugin/revmob/load.html
-- =============================================================
function revmob_helpers.loadBanner()
   if( onAndroid ) then
      revmob.load( "banner", ids.android.banner )
   elseif( oniOS ) then
      revmob.load( "banner", ids.ios.banner )
   end
end
function revmob_helpers.loadInterstitial()
   if( onAndroid ) then
      revmob.load( "interstitial", ids.android.interstitial )
   elseif( oniOS ) then
      revmob.load( "interstitial", ids.ios.interstitial )
   end
end
function revmob_helpers.loadVideo()
   if( onAndroid ) then
      revmob.load( "video", ids.android.video )
   elseif( oniOS ) then
      revmob.load( "video", ids.ios.video )
   end
end
function revmob_helpers.loadRewardedVideo()
   if( onAndroid ) then
      revmob.load( "rewardedVideo", ids.android.rewarded )
   elseif( oniOS ) then
      revmob.load( "rewardedVideo", ids.ios.rewarded )
   end
end

-- =============================================================
-- showBanner( [ position ] ) -- Show a banner if we can.
-- position "top", "bottom, "center" (default: "top" )
--
-- showInterstitial() -- Show an interstitial if we can.
-- showVideo() -- Show a video if we can.
-- showRewardedVideo() -- Show a rewarded video if we can.
--
-- https://docs.coronalabs.com/daily/plugin/revmob/show.html
-- =============================================================
function revmob_helpers.showBanner( position )
   position = position or "top"
   if( onAndroid ) then
      revmob.show( ids.android.banner, { yAlign = position } )
      lastID = ids.android.banner
   elseif( oniOS ) then
      revmob.show( ids.ios.banner, { yAlign = position } )
      lastID = ids.ios.banner
   end
end
function revmob_helpers.showInterstitial()
   if( onAndroid ) then
      revmob.show( ids.android.interstitial )
      lastID = ids.android.interstitial
   elseif( oniOS ) then
      revmob.show( ids.ios.interstitial )
      lastID = ids.ios.interstitial
   end
end
function revmob_helpers.showVideo()
   if( onAndroid ) then
      revmob.show( ids.android.video )
      lastID = ids.android.video
   elseif( oniOS ) then
      revmob.show( ids.ios.video )
      lastID = ids.ios.video
   end
end
function revmob_helpers.showRewardedVideo()
   if( onAndroid ) then
      revmob.show( ids.android.rewarded )
      lastID = ids.android.rewarded
   elseif( oniOS ) then
      revmob.show( ids.ios.rewarded )
      lastID = idsids.ios.rewarded
   end
end


-- =============================================================
-- isLoadedBanner() - Returns true if banner ad is loaded.
-- isLoadedInterstitial() - Returns true if interstitial ad is loaded.
-- isLoadedVideo() - Returns true if video ad is loaded.
-- isLoadedRewardedVideo() - Returns true if rewarded video ad is loaded.
--
-- https://docs.coronalabs.com/daily/plugin/revmob/isLoaded.html
-- =============================================================
function revmob_helpers.isLoadedBanner()
   if( onAndroid ) then
      return revmob.isLoaded( ids.android.banner )
   elseif( oniOS ) then
      return revmob.isLoaded( ids.ios.banner )
   end
   return false
end
function revmob_helpers.isLoadedInterstitial()
   if( onAndroid ) then
      return revmob.isLoaded( ids.android.interstitial )
   elseif( oniOS ) then
      return revmob.isLoaded( ids.ios.interstitial )
   end
   return false
end
function revmob_helpers.isLoadedVideo()
   if( onAndroid ) then
      return revmob.isLoaded( ids.android.video )
   elseif( oniOS ) then
      return revmob.isLoaded( ids.ios.video )
   end
   return false
end
function revmob_helpers.isLoadedRewardedVideo()
   if( onAndroid ) then
      return revmob.isLoaded( ids.android.rewarded )
   elseif( oniOS ) then
      return revmob.isLoaded( ids.ios.rewarded )
   end
   return false
end

-- =============================================================
-- hide() -- Hide (last shown) revmob ad.
--
-- https://docs.coronalabs.com/daily/plugin/revmob/hide.html
-- =============================================================
function revmob_helpers.hide( )
   if( lastID ) then
      revmob.hide( lastID )
      lastID = nil
   end
end


return revmob_helpers