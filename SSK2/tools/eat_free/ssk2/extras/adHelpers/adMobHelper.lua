-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2020 (All Rights Reserved)
-- =============================================================
--
local listener


-- Be sure to set next variable to false you release your app.
local testMode             = true

-- IDs
local ids = { android = {}, ios = {} }
ids.android.app            = "ANDROID_APP_ID_HERE"
ids.android.banner         = "ANDROID_BANNER_ID_HERE"
ids.android.interstitial   = "ANDROID_INTERSTITIAL_ID_HERE"
ids.ios.app                = "IOS_APP_ID_HERE"
ids.ios.banner             = "IOS_BANNER_ID_HERE"
ids.ios.interstitial       = "IOS_INTERSTITIAL_ID_HERE"

-- The module has a slight initialization delay to make it play nicer
-- with composer.*
local initDelay            = 30

local fakeBannerHeight     = 72

-- Set following to true to enable verbose output from the
-- event listener.
local verbose              = false

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
disableFunction( "setVideoAdVolume" )
disableFunction( "height" )
disableFunction( "isLoaded" )
disableFunction( "showBanner" )
disableFunction( "showInterstitial" )
disableFunction( "hideBanner" )

function public.prepare( enabled, userParams)   
   userParams                 = userParams or {}
   testMode                   = fnn( userParams.testMode, testMode ) 
   videoAdVolume              = fnn( userParams.videoAdVolume, 1.0 ) 
   initDelay                  = fnn( userParams.initDelay, initDelay ) 
   verbose                    = fnn( userParams.verbose, verbose ) 
   enableFakeAds              = fnn( userParams.enableFakeAds, enableFakeAds ) 
   fakeBannerHeight           = fnn( userParams.fakeBannerHeight, fakeBannerHeight ) 
   --
   childSafe                  = fnn( userParams.childSafe, childSafe ) 
   designedForFamilies        = fnn( userParams.designedForFamilies, designedForFamilies ) 
   hasUserConsent             = fnn( userParams.hasUserConsent, hasUserConsent ) 
   --
   ids.android.app            = userParams.androidAppID
   ids.android.banner         = userParams.androidBannerID
   ids.android.interstitial   = userParams.androidInterstitialID
   --
   ids.ios.app                = userParams.iosAppID
   ids.ios.banner             = userParams.iosBannerID
   ids.ios.interstitial       = userParams.iosInterstitialID

   appID         = fnn( userParams.appId, appID ) 
   banner_id         = fnn( userParams.banner_id, appID ) 
   appID         = fnn( userParams.interstitial_id, appID ) 

   --
   if( verbose ) then
      print( "adMobHelper: prepare()")
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
   local temporaryListeners = {}
   local function listener( event )
      if( verbose ) then
         table.dump( event, "adMobHelper: listener()" )         
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
      disableFunction( "setVideoAdVolume" )
      disableFunction( "height" )
      disableFunction( "isLoaded" )
      disableFunction( "showBanner" )
      disableFunction( "showInterstitial" )
      disableFunction( "hideBanner" )
   end
   
   -- If not enabled, disable the module immediately.
   if( not enabled ) then
      public.disableModule()

   -- The module IS enabled, so add REAL functions
   else
      -- Select current ID
      local os = (onAndroid or targetAndroid) and 'android' or 'ios'
      local id = ids[os].app

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
         params.appId            = id
         params.testMode         = testMode
         params.videoAdVolume    = videoAdVolume

         if( verbose ) then
            print( "adMobHelper: doInit()")
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

            end
         end
         public.listen( "init", initListener )

         --
         local admob = require( "plugin.admob" )
         admob.init( listener, params )
      end

      -- =============================================================
      -- Temporary listener helpers.
      -- =============================================================
      function public.listen( name, aListener )
         if( verbose ) then
            print( "adMobHelper: listen( '" .. name ..  "' )" )
         end
         temporaryListeners[name] = aListener
      end
      function public.ignore( name )
         if( verbose ) then
            print( "adMobHelper: ignore( '" .. name ..  "' )" )
         end
         temporaryListeners[name] = nil
      end
      function public.ignoreAll()
         if( verbose ) then
            print( "adMobHelper: ignoreAll( )")
         end
         temporaryListeners = {}
      end

      -- =============================================================
      -- Expose setVideoAdVolume(), height(), isLoaded() and load()
      -- If you need more admob features exposed, 
      -- add your own helpers to expose them.
      -- =============================================================
      function public.setVideoAdVolume( vol )
         if( verbose ) then
            print( "adMobHelper: setVideoAdVolume( '" .. tostring(vol) ..  "' )" )
         end

         if( onSimulator ) then return end
         --
         local admob = require( "plugin.admob" )
         return admob.setVideoAdVolume( vol )
      end

      function public.height( )
         if( onSimulator ) then return fakeBannerHeight end
         --
         local admob = require( "plugin.admob" )
         return admob.height()
      end

      -- EFM make this smarter
      function public.isLoaded( adType )
         if( verbose ) then
            print( "adMobHelper: isLoaded( '" .. tostring(adType) ..  "' )" )
         end
         if( onSimulator ) then return true end
         --
         local admob = require( "plugin.admob" )
         return admob.isLoaded( adType )
      end

      function public.loadBanner( aListener )
         if( verbose ) then
            print( "adMobHelper: loadBanner( "  .. tostring(aListener) ..  " )" )
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
         local admob = require( "plugin.admob" )
         admob.load( "banner", { adUnitId = ids[os].banner, childSafe = childSafe, designedForFamilies = designedForFamilies, hasUserConsent = hasUserConsent }  )      
      end

      function public.loadInterstitial( aListener )
         if( verbose ) then
            print( "adMobHelper: loadInterstitial( "  .. tostring(aListener) ..  " )" )
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
         local admob = require( "plugin.admob" )
         admob.load( "interstitial", { adUnitId = ids[os].interstitial, childSafe = childSafe, designedForFamilies = designedForFamilies, hasUserConsent = hasUserConsent }  )      
      end

      -- =============================================================
      -- Custom Show Functions
      -- =============================================================
      function public.showBanner( position, bgColor )
         if( verbose ) then
            print( "adMobHelper: showBanner( '" .. tostring(position) ..  "' ,"  .. tostring(bgColor) ..  " )" )
         end
         if( onSimulator ) then 
            if( enableFakeAds and ssk.fakeAdsHelper ) then                        
               ssk.fakeAdsHelper.showBanner( "adMob", ids[os].banner, position, nil, fakeBannerHeight )
            end
            return 
         end
         --
         local params = {}
         params.y          = position or "bottom"
         params.bgColor    = bgColor
         --
         local admob = require( "plugin.admob" )
         admob.show( "banner", params  )
      end

      function public.showInterstitial( onClosed )
         if( verbose ) then
            print( "adMobHelper: showInterstitial( " .. tostring(onClosed) ..  " )" )
         end         
         onClosed = onClosed or stub
         --
         if( onSimulator ) then 
            if( enableFakeAds and ssk.fakeAdsHelper ) then 
               ssk.fakeAdsHelper.showInterstitial( "adMob", ids[os].interstitial, onClosed )
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
         local admob = require( "plugin.admob" )
         admob.show( "interstitial" )
      end
 
      -- =============================================================
      -- Hide Banner Helper
      -- =============================================================
      function public.hideBanner()
         if( verbose ) then
            print( "adMobHelper: showBanner( )" )
         end
         if( onSimulator ) then 
            if( enableFakeAds and ssk.fakeAdsHelper ) then 
               ssk.fakeAdsHelper.hideBanner()
            end
            return 
         end
         --
         local admob = require( "plugin.admob" )
         admob.hide( )
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
_G.ssk.adMobHelper = public

return public