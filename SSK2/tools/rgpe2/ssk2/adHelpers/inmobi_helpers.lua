-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- inmobi_helpers.lua
-- =============================================================
--[[

   Includes these functions:

   inmobi_helpers.setID( os, adType, id ) - Set an id manually (do before init if at all).
   inmobi_helpers.init( [ delay [, logLevel ] ] ) - Initialize ads with optional delay.  

   inmobi_helpers.loadBanner( params ) - Load banner ad.
   inmobi_helpers.loadInterstitial( params ) - Load interstitial ad.

   inmobi_helpers.showBanner( [ position [, targetingOptions ] ] ) - Show banner ad.
   inmobi_helpers.showInterstitial( [ targetingOptions ] ) - Show interstitial ad.

   inmobi_helpers.isLoadedBanner() - Returns true if banner ad is loaded.
   inmobi_helpers.isLoadedInterstitial() - Returns true if interstitial ad is loaded.

   inmobi_helpers.hide( ) - Hide any showing revMob ad.

   inmobi_helpers.testStatus( phase ) - Returns true if phase has been triggered in listener.
   inmobi_helpers.clearStatus( phase ) - Clear the flag for the named 'phase'

   inmobi_helpers.setPhaseCB( phase [, cb [, once ] ] ) - Provide a special callback to execute when the 
      listener event 'phase' occurs.  If once is set to 'true', the callback is called once then cleared.

--]]
-- =============================================================
-- =============================================================
local inMobi = require( "plugin.inMobi" )

local lastID -- Set 'on show' to simplify call to hide

local debugLevel = 0
local function dPrint( level, ... )
   if( level <= debugLevel ) then
      print( unpack( arg ) )
   end
end

local inmobi_helpers = {}

function inmobi_helpers.setDebugLevel( newLevel )
   debugLevel = newLevel or 0 
end


-- Place to store phase callback records [see: inmobi_helpers.setPhaseCB()]
--
local phaseCallbacks = {}

-- Special statuses (based on phases and other actions)
--[[
]]
local status  = {}
inmobi_helpers.status = status
function inmobi_helpers.testStatus( phase )
   return fnn(status[phase], false)
end
function inmobi_helpers.clearStatus( phase )
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
   },
   ios = 
   { 
      banner         = IOS_BANNER_ID, 
      interstitial   = IOS_INTERSTITIAL_ID,
   },
}

-- ==
--    inMobi Listener 
-- ==
local function listener( event ) 
   -- Extract base set of useful event details:
   local isError     = (event.isError == nil) and false or event.isError
   local phase       = (event.phase == nil) and "unknown" or event.phase   
   local eType       = (event.type == nil) and "unknown" or event.type   
   local response    = (event.name == nil) and "unknown" or event.response

   dPrint( 3, "inMobi Listener Event @ ", system.getTimer )
   dPrint( 3, 'isError: ' .. tostring( isError ) .. '; phase == "' .. tostring(phase) .. '"; response == "' .. tostring(response) .. '"' )

   -- Do something with the above details...
   --
   if( isError ) then
      dPrint( 1,  "inMobi is getting errors.")
      for k,v in pairs( event ) do
         dPrint( 1, k,v)
      end
   
   else
      -- Note: There may be more phases.
      if( phase == "init" ) then
      elseif( phase == "loaded" ) then
      elseif( phase == "failed" ) then
      elseif( phase == "displayed" ) then
      elseif( phase == "closed" ) then
      else        
         dPrint( 1,  "inMobi is getting a weird event.phase value?! ==> " .. tostring( event.phase ) )
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
-- adType - 'banner', 'interstitial'
-- id - Must be a valid ID
--
-- =============================================================
function inmobi_helpers.setID( os, adType, id )
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
      dPrint( 3, ("Init phase completed!")
      table.dump(event)
   end

   inmobi_helpers.setPhaseCB( "init", onInit, true )

]]
--
-- =============================================================
function inmobi_helpers.setPhaseCB( phase, cb, once )
   once = fnn( once, true )
   phaseCallbacks[phase] = (cb) and { cb = cb, once = once } or nil
end


-- =============================================================
-- init( [ delay [, logLevel ] ] ) - Initilize revMob ad network.
--   If delay is specified, wait 'delay' ms then initialize.
--  
--  logLevel - "debug" or "error"   
--
-- https://docs.coronalabs.com/daily/plugin/inmobi/init.html
-- =============================================================
function inmobi_helpers.init( delay, logLevel )
   -- Set default delay if not provided
   delay = delay or 0 
   
   -- A function that we may call immediately or with a delay
   -- to do the initialization work.
   local function doInit()

      -- If on Android,
      if( onAndroid ) then
         
         -- and a interstial ID was provided, then init with it
         if( ids.android.interstitial ) then
            inMobi.init( listener, { accountId = ids.android.interstitial, logLevel = logLevel } )

         -- or a banner id was supplied and init with it
         elseif( ids.android.banner ) then
            inMobi.init( listener, { accountId = ids.android.banner, logLevel = logLevel } )

         end

      -- else if on iOS,
      elseif( oniOS ) then 

         -- and a interstial ID was provided, then init with it
         if( ids.ios.interstitial ) then
            inMobi.init( listener, { accountId = ids.ios.interstitial, logLevel = logLevel } )

         -- or a banner id was supplied and init with it
         elseif( ids.ios.banner ) then
            inMobi.init( listener, { accountId = ids.ios.banner, logLevel = logLevel } )

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
-- loadBanner( params ) -- Load a banner if we can.
-- loadInterstitial( params ) -- Load an interstitial if we can.
--
-- https://docs.coronalabs.com/daily/plugin/inmobi/load.html
-- =============================================================
function inmobi_helpers.loadBanner( params )
   params = params or {}
   if( onAndroid ) then
      inMobi.load( "banner", ids.android.banner, params )
   elseif( oniOS ) then
      inMobi.load( "banner", ids.ios.banner, params )
   end
end
function inmobi_helpers.loadInterstitial( params )
   params = params or {}
   if( onAndroid ) then
      inMobi.load( "interstitial", ids.android.interstitial, params )
   elseif( oniOS ) then
      inMobi.load( "interstitial", ids.ios.interstitial, params )
   end
end

-- =============================================================
-- showBanner( [ position ] ) -- Show a banner if we can.
-- position "top", "bottom, "center" (default: "top" )
--
-- showInterstitial() -- Show an interstitial if we can.
--
-- https://docs.coronalabs.com/daily/plugin/inmobi/show.html
-- =============================================================
function inmobi_helpers.showBanner( position )
   position = position or "top"
   if( onAndroid ) then
      inMobi.show( ids.android.banner, { yAlign = position } )
      lastID = ids.android.banner
   elseif( oniOS ) then
      inMobi.show( ids.ios.banner, { yAlign = position } )
      lastID = ids.ios.banner
   end
end
function inmobi_helpers.showInterstitial()
   if( onAndroid ) then
      inMobi.show( ids.android.interstitial )
      lastID = ids.android.interstitial
   elseif( oniOS ) then
      inMobi.show( ids.ios.interstitial )
      lastID = ids.ios.interstitial
   end
end


-- =============================================================
-- isLoadedBanner() - Returns true if banner ad is loaded.
-- isLoadedInterstitial() - Returns true if interstitial ad is loaded.
--
-- https://docs.coronalabs.com/daily/plugin/inmobi/isLoaded.html
-- =============================================================
function inmobi_helpers.isLoadedBanner()
   if( onAndroid ) then
      return inMobi.isLoaded( ids.android.banner )
   elseif( oniOS ) then
      return inMobi.isLoaded( ids.ios.banner )
   end
   return false
end
function inmobi_helpers.isLoadedInterstitial()
   if( onAndroid ) then
      return inMobi.isLoaded( ids.android.interstitial )
   elseif( oniOS ) then
      return inMobi.isLoaded( ids.ios.interstitial )
   end
   return false
end

-- =============================================================
-- hide() -- Hide (last shown) inMobi ad.
--
-- https://docs.coronalabs.com/daily/plugin/inMobi/hide.html
-- =============================================================
function inmobi_helpers.hide( )
   if( lastID ) then
      inMobi.hide( lastID )
      lastID = nil
   end
end


return inmobi_helpers