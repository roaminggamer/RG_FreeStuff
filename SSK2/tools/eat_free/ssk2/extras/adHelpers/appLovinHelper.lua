-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2020 (All Rights Reserved)
-- =============================================================
--
local listener


-- Be sure to set next variable to false you release your app.
local testMode             = true

-- ID
local sdkKey               = "APPLOVIN_SDK_KEY"

-- The module has a slight initialization delay to make it play nicer
-- with composer.*
local initDelay            = 30

local fakeBannerWidth      = 640
local fakeBannerHeight     = 100

-- Set following to true to enable verbose output from the
-- event listener.
local verbose              = false

-- 
local hasUserConsent       = false

-- Various content and data gathering controls
local childSafe            = false
local designedForFamilies  = false
local hasUserConsent       = false

-- Empty function
local stub = function() end

local public = {}
-- Used to stub out a function on the module, effectively 
-- disabling it.
local function disableFunction( name ) public[name] = stub end

-- Most functions start off stubbed out for that rare case where
-- the module is 'used' before prepare was called.
--
-- This should only ever happen while you are editting and then 
-- only if you start the 'home' scene immediately.
disableFunction( "listen" )
disableFunction( "ignore" )
disableFunction( "ignoreAll" )
disableFunction( "loadBanner" )
disableFunction( "loadInterstitial" )
disableFunction( "loadRewarded" )
disableFunction( "showBanner" )
disableFunction( "showInterstitial" )
disableFunction( "showRewarded" )
disableFunction( "hideBanner" )

function public.prepare( enabled, userParams)   
   userParams                 = userParams or {}
   testMode                   = fnn( userParams.testMode, testMode ) 
   initDelay                  = fnn( userParams.initDelay, initDelay ) 
   verbose                    = fnn( userParams.verbose, verbose ) 
   enableFakeAds              = fnn( userParams.enableFakeAds, enableFakeAds ) 
   fakeBannerWidth            = fnn( userParams.fakeBannerWidth, fakeBannerWidth ) 
   fakeBannerHeight           = fnn( userParams.fakeBannerHeight, fakeBannerHeight ) 
   --
   hasUserConsent             = fnn( userParams.hasUserConsent, hasUserConsent )
   --
   sdkKey                     = fnn( userParams.sdkKey, sdkKey )
   --
   if( verbose ) then
      print( "appLovinHelper: prepare()")
      table.dump( userParams )
   end

   -- This function can only be called once, so stub it out.
   disableFunction( "prepare" )

   --
   -- This module utilizes the concept of 'temporary' listeners.
   -- These listeners can be added and removed by name.
   -- Any temporary listeners that are currently in our list are 
   -- called (randomly) if an ad event comes in.
   -- 
   -- event.phase - String value indicating the phase of the adsRequest event. Possible values include:
   -- "init" — Indicates that the AppLovin plugin was initialized successfully.
   -- "failed" — Indicates that an ad failed to load. For this phase, event.isError will be true. Additionally, event.type and event.response can provide additional context.
   -- "loaded" — Indicates that an ad loaded successfully. For this phase, event.type can provide additional context.
   -- "displayed" — Indicates that an ad was displayed. For this phase, event.type can provide additional context.
   -- "hidden" — Indicates that an interstitial ad was closed/hidden. For this phase, event.type can provide additional context.
   -- "playbackBegan" — Indicates that a video ad has started playback. For this phase, event.type can provide additional context.
   -- "playbackEnded" — Indicates that a video ad has ended playback. For this phase, event.type and event.data can provide additional context.
   -- "clicked" — Indicates that an ad was clicked/tapped. For this phase, event.type can provide additional context.
   -- "declinedToView" — Applies only to rewarded video ads. Indicates that the user chose "no" when prompted to view the ad. For this phase, event.type can provide additional context.
   -- "validationSucceeded" — Applies only to rewarded video ads. Indicates that the user viewed the ad and that their reward was approved by the AppLovin server. For this phase, event.type and event.data can provide additional context.
   -- "validationExceededQuota" — Applies only to rewarded video ads. Indicates that the AppLovin server was contacted, but the user has already received the maximum amount of rewarded video offers allowed in a given day, defined by "frequency capping" in the AppLovin developer portal. For this phase, event.type and event.data can provide additional context.
   -- "validationRejected" — Applies only to rewarded video ads. Indicates that the AppLovin server rejected the reward request. For this phase, event.type and event.data can provide additional context.
   -- "validationFailed" — Applies only to rewarded video ads. Indicates that the AppLovin server could not be contacted. For this phase, event.type and event.data can provide additional context.
   --   
   -- event.type - Indicates the type of ad the event refers to. Possible values are "banner", "interstitial" or "rewardedVideo".
   --
   -- event.data - For the phase of "validationSucceeded", this table will contain the key-value pairs associated with the reward of the rewarded video (if enabled):
   -- event.data.currency — The currency name, configured in the AppLovin developer portal.
   -- event.data.amount — The reward amount, configured in the AppLovin developer portal.
   -- For the phase of "playbackEnded", this table will contain the key-value pairs associated with the video:
   -- event.data.percentPlayed — The percentage of the video that the user has watched.
   -- event.data.fullyWatched — This will be true if the Applovin SDK considers that the user has fully watched the video (may be less than 100%).   
   --
   local temporaryListeners = {}
   local function listener( event )
      if( verbose ) then
         table.dump( event, "appLovinHelper: listener()" )         
      end
      --
      for key, aListener in pairs( temporaryListeners ) do
         aListener( event )
      end
   end   

   -- It is possible to disable the module now, or
   -- in the future, so make this a helper function.
   --
   -- This helper assigns an empty function to all module function
   -- to stub them out.
   public.disableModule = function( doCleaning )
      if( doCleaning ) then
         temporaryListeners = {}
      end
      disableFunction( "disableModule" )
      disableFunction( "listen" )
      disableFunction( "ignore" )
      disableFunction( "ignoreAll" )
      disableFunction( "loadBanner" )
      disableFunction( "loadInterstitial" )
      disableFunction( "loadRewarded" )
      disableFunction( "showBanner" )
      disableFunction( "showInterstitial" )
      disableFunction( "showRewarded" )
      disableFunction( "hideBanner" )
   end
   
   -- If not enabled, disable the module immediately.
   if( not enabled ) then
      public.disableModule()

   -- The module IS enabled, so add REAL functions
   else
      -- Select current ID
      local os = (onAndroid or targetAndroid) and 'android' or 'ios'

      -- =============================================================
      -- Helper To Call init() - Not called till end of preparation.
      --
      -- Tip: You may want to modify this code to configure extra
      -- features, but most of them are configured at the top of the
      -- file.
      --
      -- =============================================================
      local function doInit()
         local params = {}         
         params.sdkKey           = sdkKey
         params.testMode         = testMode
         params.verboseLogging   = verbose

         if( verbose ) then
            print( "appLovinHelper: doInit()")
            table.dump(params)
         end

         -- DO NOT EDIT THIS UNLESS YOU ARE AN EXPERT:
         local function clear()
            public.ignore( "init" )
         end
         local function initListener( event )
            local isError  = event.isError
            local phase    = event.phase
            --
            if( phase == "init" ) then
               clear()

               -- If the init failed we may as well just disable
               -- the module.
               if( isError ) then
                  public.disableModule(true)
                  return
               end
               
               local applovin = require( "plugin.applovin" )
               applovin.setHasUserConsent( hasUserConsent )
            end
         end
         public.listen( "init", initListener )

         --
         local applovin = require( "plugin.applovin" )
         applovin.init( listener, params )
      end

      -- =============================================================
      -- Temporary listener helpers.
      -- =============================================================
      function public.listen( name, aListener )
         if( verbose ) then
            print( "appLovinHelper: listen( '" .. name ..  "' )" )
         end
         temporaryListeners[name] = aListener
      end
      function public.ignore( name )
         if( verbose ) then
            print( "appLovinHelper: ignore( '" .. name ..  "' )" )
         end
         temporaryListeners[name] = nil
      end
      function public.ignoreAll()
         if( verbose ) then
            print( "appLovinHelper: ignoreAll( )")
         end
         temporaryListeners = {}
      end

      -- =============================================================
      -- Expose setVideoAdVolume(), height(), isLoaded() and load()
      -- If you need more applovin features exposed, 
      -- add your own helpers to expose them.
      -- =============================================================
      -- EFM make this smarter
      function public.isLoaded( adType )
         adType = (adType == "rewarded" ) and "rewardedVideo" or adType
         if( verbose ) then
            print( "appLovinHelper: isLoaded( '" .. tostring(adType) ..  "' )" )
         end
         if( onSimulator ) then return true end
         --
         local applovin = require( "plugin.applovin" )
         return applovin.isLoaded( adType )
      end

      function public.loadBanner( bannerSize, aListener )
         if( type(bannerSize) == 'function' ) then
            aListener = bannerSize 
            bannerSize = nil
         end
         if( verbose ) then
            print( "appLovinHelper: loadBanner( "  .. tostring(bannerSize) .. "," ..  tostring(aListener) ..  " )" )
         end
         --
         if( onSimulator ) then
            if( enableFakeAds and ssk.fakeAdsHelper ) then
               if( bannerSize == "standard" ) then
                  fakeBannerWidth  = 320 * 2
                  fakeBannerHeight = 50 * 2
                  bannerSize = nil
               elseif( bannerSize == "leader" ) then
                  fakeBannerWidth  = 768 * 2
                  fakeBannerHeight = 90 * 2
               elseif( bannerSize == "mrec" ) then
                  fakeBannerWidth  = 320 * 2
                  fakeBannerHeight = 250 * 2
               end
            end 
            if( aListener ) then
               aListener()
            end
            return 
         end
         --
         if( aListener ) then
            public.listen( "loaded", aListener )
         end
         --
         local applovin = require( "plugin.applovin" )
         if( bannerSize ) then
            applovin.load( "banner", { bannerSize = bannerSize } )            
         else
            applovin.load( "banner" )            
         end
      end

      function public.loadInterstitial( aListener )
         if( verbose ) then
            print( "appLovinHelper: loadInterstitial( "  .. tostring(aListener) ..  " )" )
         end
         --
         if( onSimulator ) then 
            if( aListener ) then
               aListener()
            end
            return 
         end
         --
         if( aListener ) then
            public.listen( "loaded", aListener )
         end
         --
         local applovin = require( "plugin.applovin" )
         applovin.load( "interstitial" )
      end

      function public.loadRewarded( aListener )
         if( verbose ) then
            print( "appLovinHelper: loadRewarded( "  .. tostring(aListener) ..  " )" )
         end
         --
         if( onSimulator ) then 
            if( aListener ) then
               aListener()
            end
            return 
         end
         --
         if( aListener ) then
            public.listen( "loaded", aListener )
         end
         --
         local applovin = require( "plugin.applovin" )
         applovin.load( "rewardedVideo" )
      end

      -- =============================================================
      -- Custom Show Functions
      -- =============================================================
      function public.showBanner( position, placement )
         if( verbose ) then
            print( "appLovinHelper: showBanner( '" .. tostring(position) .. "', " .. tostring(placement) ..  " )" )
         end
         if( onSimulator ) then 
            if( enableFakeAds and ssk.fakeAdsHelper ) then
               ssk.fakeAdsHelper.showBanner( "appLovin", sdkKey, position, placement, fakeBannerHeight, fakeBannerWidth )
            end
            return 
         end
         --
         local params = {}
         params.y          = position or "top" -- top, center, bottom
         params.placement  = placement 
         --
         local applovin = require( "plugin.applovin" )
         applovin.show( "banner", params  )
      end

      function public.showInterstitial( placement, onClosed )
         if( type(placement) == 'function' ) then
            onClosed = placement 
            placement = nil
         end

         if( verbose ) then
            print( "appLovinHelper: showInterstitial( " .. tostring(onClosed) .. ", " .. tostring(placement) ..  " )" )
         end         
         onClosed = onClosed or stub
         --
         if( onSimulator ) then 
            if( enableFakeAds and ssk.fakeAdsHelper ) then 
               ssk.fakeAdsHelper.showInterstitial( "appLovin", sdkKey, onClosed, placement )
            else
               onClosed()
            end
            return 
         end
         --
         local function clear()
            public.ignore( "closed" )
         end
         local function interstitialListener( event )         
            local isError  = event.isError
            local phase    = event.phase
            --
            if( isError ) then
               clear()
               return
            end
            --
            if( phase == "closed"  ) then
               clear()
               onClosed()
            end
         end
         public.listen( "closed", interstitialListener )
         --
         local params = {}
         params.placement  = placement 
         --
         local applovin = require( "plugin.applovin" )
         applovin.show( "interstitial", params )
      end

      function public.showRewarded( placement )
         if( verbose ) then
            print( "appLovinHelper: showInterstitial( " .. tostring(placement) ..  " )" )
         end
         --
         if( onSimulator ) then 
            if( enableFakeAds and ssk.fakeAdsHelper ) then 
               ssk.fakeAdsHelper.showRewarded( "appLovin", sdkKey, nil, placement )
            end
            return 
         end
         --
         local function clear()
            public.ignore( "closed" )
         end
         local function interstitialListener( event )         
            local isError  = event.isError
            local phase    = event.phase
            --
            if( isError ) then
               clear()
               return
            end
            --
            if( phase == "closed"  ) then
               clear()
            end
         end
         public.listen( "closed", interstitialListener )
         --
         local params = {}
         params.placement  = placement 
         --
         local applovin = require( "plugin.applovin" )
         applovin.show( "rewardedVideo", params )
      end
 
      -- =============================================================
      -- Hide Banner Helper
      -- =============================================================
      function public.hideBanner()
         if( verbose ) then
            print( "appLovinHelper: showBanner( )" )
         end
         if( onSimulator ) then 
            if( enableFakeAds and ssk.fakeAdsHelper ) then 
               ssk.fakeAdsHelper.hideBanner()
            end
            return 
         end
         --
         local applovin = require( "plugin.applovin" )
         applovin.hide( "banner"  )
      end
      
      -- =============================================================
      -- Initialize ads as last step of 'preparing' the module
      -- =============================================================
      if( onDevice ) then
         timer.performWithDelay( initDelay, doInit )
      end
   end
end

-- Attach to ssk
_G.ssk = _G.ssk or {}
_G.ssk.appLovinHelper = public

return public