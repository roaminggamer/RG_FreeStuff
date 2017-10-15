-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- admob_helpers.lua
-- =============================================================
--[[

   Includes these functions:

   admob_helpers.setID( os, adType, id ) - Set an id manually (do before init if at all).
   admob_helpers.init( [delay] ) - Initialize ads with optional delay.
   admob_helpers.showBanner( [ position [, targetingOptions ] ] ) - Show banner ad.
   admob_helpers.showInterstitial( [ targetingOptions ] ) - Show interstitial ad.
   admob_helpers.hide( ) - Hide any showing adMob ad.
   admob_helpers.loadInterstitial( ) - Load an interstitial ad in preparation to show it.
   admob_helpers.isInterstitialLoaded( ) - Returns 'true' if interstitial is loaded.
   admob_helpers.bannerHeight( ) - Get height of (shown) banner ad.

   admob_helpers.testStatus( phase ) - Returns true if phase has been triggered in listener.
   admob_helpers.clearStatus( phase ) - Clear the flag for the named 'phase'

   admob_helpers.setPhaseCB( phase [, cb [, once ] ] ) - Provide a special callback to execute when the 
      listener event 'phase' occurs.  If once is set to 'true', the callback is called once then cleared.

--]]
-- =============================================================
-- =============================================================
local ads = require( "ads" )

-- ** IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT **
--
-- You must change this to 'false' before submitting your app to the store, but
-- you must leave it as 'true' while testing or you may get your account cancelled.
--
-- ** IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT  IMPORTANT **
local isTestMode = true

local showingBanner = false

local debugLevel = 0
local function dPrint( level, ... )
   if( level <= debugLevel ) then
      print( unpack( arg ) )
   end
end


local admob_helpers = {}

function admob_helpers.setDebugLevel( newLevel )
   debugLevel = newLevel or 0 
end



-- Place to store phase callback records [see: admob_helpers.setPhaseCB()]
--
local phaseCallbacks = {}

-- Special statuses (based on phases and other actions)
--[[
]]
local status  = {}
admob_helpers.status = status
function admob_helpers.testStatus( phase )
   return fnn(status[phase], false)
end
function admob_helpers.clearStatus( phase )
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
      interstitial   = ANDROID_INTERSTITIAL_ID
   },
   ios = 
   { 
      banner         = IOS_BANNER_ID, 
      interstitial   = IOS_INTERSTITIAL_ID
   },
}

-- ==
--    adMob Listener 
-- ==
local function listener( event ) 
   -- Extract base set of useful event details:
   local isError     = (event.isError == nil) and false or event.isError
   local name        = (event.name == nil) and "unknown" or event.name
   local phase       = (event.phase == nil) and "unknown" or event.phase
   local provider    = (event.provider == nil) and "unknown" or event.provider

   dprint( 3, "AdMob Listener Event @ ", system.getTimer )
   dPrint( 3, 'isError: ' .. tostring( isError ) .. '; name == "' .. tostring(name) .. '"; phase == "' .. tostring(phase) .. '"' )

   -- Do something with the above details...
   --
   if( isError ) then
      dPrint( 1,  "AdMob is getting errors.")
      for k,v in pairs( event ) do
         dPrint( 1, k,v)
      end
   
   else
      if( name == "adsRequest" ) then

         -- Tip: These are checked for in the typical order they happen:
         --
         if( phase == "loaded" ) then
            dPrint( 3, "We got an ad!  We should be ready to show it.")
         

         elseif( phase == "shown" ) then
            dPrint( 3, "Ad started showing!")
   
         elseif( phase == "refreshed" ) then
            dPrint( 3, "Ad refreshed!")
   
         end

         status[phase or "error"] = true
         local cb = phaseCallbacks[phase]
         if( cb ) then
            cb.cb(event)
            if(cb.once) then
               phaseCallbacks[phase] = nil
            end
         end

      else        
         dPrint( 1,  "Admob is getting a weird event.name value?! ==> " .. tostring( event.response ) )
         for k,v in pairs( event ) do
            dPrint( 1, k,v)
         end
      end
   end
end

-- =============================================================
-- setID( os, adType, id ) - Set an id for a specific OS and ad type
--
-- os - 'android' or 'ios'
-- adType - 'banner' or 'interstitial'
-- id - Must be a valid ID
--
-- =============================================================
function admob_helpers.setID( os, adType, id )
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
      print("Init phase completed!")
      table.dump(event)
   end

   admob_helpers.setPhaseCB( "init", onInit, true )

]]
--
-- =============================================================
function admob_helpers.setPhaseCB( phase, cb, once )
   once = fnn( once, true )
   phaseCallbacks[phase] = (cb) and { cb = cb, once = once } or nil
end


-- =============================================================
-- init( [ delay ] ) - Initilize adMob ad network.
--                     If delay is specified, wait 'delay' ms then
--                     initialize.
--
-- https://docs.coronalabs.com/daily/plugin/ads-admob-v2/index.html
-- =============================================================
function admob_helpers.init( delay )
   -- Set default delay if not provided
   delay = delay or 0 
   
   -- A function that we may call immediately or with a delay
   -- to do the initialization work.
   local function doInit()

      -- If on Android,
      if( onAndroid ) then
         
         -- and a interstial ID was provided, then init with it
         if( ids.android.interstitial ) then
            ads.init( "admob", ids.android.interstitial, listener )            

         -- otherwise see if a banner id was supplied and init with it
         elseif( ids.android.banner ) then
            ads.init( "admob", ids.android.banner, listener )

         end

      -- else if on iOS,
      elseif( oniOS ) then 

         -- and a interstial ID was provided, then init with it
         if( ids.ios.interstitial ) then
            ads.init( "admob", ids.ios.interstitial, listener )            

         -- otherwise see if a banner id was supplied and init with it
         elseif( ids.ios.banner )  then
            ads.init( "admob", ids.ios.banner, listener )
         end
      end

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
-- showBanner() -- Show a banner if we can.
--
-- https://docs.coronalabs.com/daily/plugin/ads-admob-v2/show.html
-- =============================================================
function admob_helpers.showBanner( position, targetingOptions )
   if( showingBanner ) then return end

   -- Set default position if not provided
   position = position or "top"

   -- Set targetingOptions to blank table if not provided
   targetingOptions = targetingOptions or {}

   -- Set provider to admob
   ads:setCurrentProvider("admob")

   -- Configure the banner ad parameters
   local xPos, yPos = display.screenOriginX, display.contentCenterY - display.actualContentHeight/2
   local params
   if( type(position) == "string" ) then
      if( position == "top" ) then
         xPos, yPos = display.screenOriginX, display.contentCenterY - display.actualContentHeight/2
      else
         xPos, yPos = display.screenOriginX, display.contentCenterY + display.actualContentHeight/2
      end
   else
      xPos = position.xPos
      yPos = position.yPos
   end


   if( onAndroid ) then
      params = 
      { 
         x = xPos, 
         y = yPos, 
         appId = ids.android.banner, 
         targetingOptions = targetingOptions, 
         testMode = isTestMode 
      }

   elseif( oniOS ) then 
      params = 
      { 
         x = xPos, 
         y = yPos, 
         appId = ids.ios.banner, 
         targetingOptions = targetingOptions, 
         testMode = isTestMode 
      }
   end

   showingBanner = true

   ads.show( "banner", params )
end

-- =============================================================
-- showInterstitial() -- Show an interstitial if we can.
--
-- https://docs.coronalabs.com/daily/plugin/ads-admob-v2/show.html
-- =============================================================
function admob_helpers.showInterstitial( targetingOptions )

   -- Set targetingOptions to blank table if not provided
   targetingOptions = targetingOptions or {}

   -- Set provider to admob
   ads:setCurrentProvider("admob")

   -- Configure the interstitial ad parameters
   local params

   if( onAndroid ) then
      params = 
      { 
         appId = ids.android.interstitial, 
         targetingOptions = targetingOptions, 
         testMode = isTestMode 
      }

   elseif( oniOS ) then 
      params = 
      { 
         appId = ids.ios.interstitial, 
         targetingOptions = targetingOptions, 
         testMode = isTestMode 
      }
   end

   ads.show( "interstitial", params )
end


-- =============================================================
-- loadInterstitial() -- Show an interstitial if we can.
--
-- https://docs.coronalabs.com/daily/plugin/ads-admob-v2/load.html
-- =============================================================
function admob_helpers.loadInterstitial( )
   -- Set provider to admob
   ads:setCurrentProvider("admob")

   -- Configure the interstitial ad parameters
   local params

   if( onAndroid ) then
      params = 
      { 
         appId = ids.android.interstitial, 
         testMode = isTestMode 
      }

   elseif( oniOS ) then 
      params = 
      { 
         appId = ids.ios.interstitial, 
         testMode = isTestMode 
      }
   end

   ads.load( "interstitial", params )
end


-- =============================================================
-- isInterstitialLoaded() -- Checks if an interstitial is loaded
--
-- https://docs.coronalabs.com/daily/plugin/ads-admob-v2/isLoaded.html
-- =============================================================
function admob_helpers.isInterstitialLoaded( )
   -- Set provider to admob
   ads:setCurrentProvider("admob")

   return ads.isLoaded( "interstitial" ) 
end


-- =============================================================
-- bannerHeight() -- Returns height of (shown) banner ad.
--
-- https://docs.coronalabs.com/daily/plugin/ads-admob-v2/height.html
-- =============================================================
function admob_helpers.bannerHeight( )
   -- Set provider to admob
   ads:setCurrentProvider("admob")

   return ads.height()
end


-- =============================================================
-- hide() -- Hide ads.
--
-- https://docs.coronalabs.com/daily/plugin/ads-admob-v2/index.html
-- =============================================================
function admob_helpers.hide( )
   -- Set provider to admob
   ads:setCurrentProvider("admob")

   showingBanner = false

   return ads.hide()
end



return admob_helpers