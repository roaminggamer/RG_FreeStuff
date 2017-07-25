-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- applovin_helpers.lua
-- =============================================================
--[[

   Note: The applovin_helpers module is a very thin layer on top of the normal applovin plugin, 
         but still nice as it is a ready-made place to organize your own code.

   Includes these functions:

   applovin_helpers.setID( os, id ) - Set an id manually (do before init if at all).
   applovin_helpers.init( [delay] ) - Initialize ads with optional delay.
   applovin_helpers.load( [ isIncentivized ] ] ) - Load a new [incentivized] ad.
   applovin_helpers.isLoaded( [ isIncentivized ] ] ) - Check if an [incentivized] ad is loaded.
   applovin_helpers.show( [ isIncentivized ] ] ) - Show an [incentivized] ad.
   applovin_helpers.setUserDetails( params ] ) - Set user details to be passed to Applovin for server-side callbacks.

   applovin_helpers.testStatus( phase ) - Returns true if phase has been triggered in listener.
   applovin_helpers.clearStatus( phase ) - Clear the flag for the named 'phase'

   applovin_helpers.setPhaseCB( phase [, cb [, once ] ] ) - Provide a special callback to execute when the 
      listener event 'phase' occurs.  If once is set to 'true', the callback is called once then cleared.

--]]
-- =============================================================
-- =============================================================
local applovin = require( "plugin.applovin" )

local debugLevel = 0
local function dPrint( level, ... )
   if( level <= debugLevel ) then
      print( unpack( arg ) )
   end
end


local applovin_helpers = {}

function applovin_helpers.setDebugLevel( newLevel )
   debugLevel = newLevel or 0 
end



-- Place to store phase callback records [see: applovin_helpers.setPhaseCB()]
--
local phaseCallbacks = {}

-- Special statuses (based on phases and other actions)
--[[
]]
local status  = {}
applovin_helpers.status = status
function applovin_helpers.testStatus( phase )
   return fnn(status[phase], false)
end
function applovin_helpers.clearStatus( phase )
   status[phase] = false
end

-- ==
--    Table of ids, separated by OS and type (banner or interstitial)
-- ==
local ids = 
{ 
   android   = ANDROID_ID,
   ios       = IOS_ID,
   apple_tv  = APPLE_TV_ID
}

-- ==
--    Applovin Listener 
-- ==
local function listener( event ) 
   -- Extract base set of useful event details:
   local isError  = (event.isError == nil) and false or event.isError
   local phase    = (event.phase == nil) and "unknown" or event.phase

   dPrint( 3, "Applovin Listener Event @ ", system.getTimer )
   dPrint( 3, 'isError: ' .. tostring( isError ) .. '; phase == "' .. tostring(phase) .. '"' )

   -- Do something with the above details...
   --
   if( isError ) then
      dPrint( 1,  "Applovin is getting errors.")
      for k,v in pairs( event ) do
         dPrint( 1, k,v)
      end

   -- This is all known Applovin listener phases (as of 04 SEP 2016)   
   elseif( phase == "init" ) then
   elseif( phase == "failed" ) then
   elseif( phase == "loaded" ) then
   elseif( phase == "displayed" ) then
   elseif( phase == "hidden" ) then
   elseif( phase == "playbackBegan" ) then
   elseif( phase == "playbackEnded" ) then
   elseif( phase == "clicked" ) then
   elseif( phase == "declinedToView" ) then
   elseif( phase == "validationSucceeded" ) then
   elseif( phase == "validationExceededQuota" ) then
   elseif( phase == "validationRejected" ) then
   elseif( phase == "validationFailed" ) then

   else        
      dPrint( 1,  "Applovin is getting a weird event.phase value?! ==> " .. tostring( event.response ) )
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

-- =============================================================
-- setID( os, id ) - Set the Applovin SDK Key for specific OS.
--
-- os - 'android', 'ios', or 'apple_tv'
-- id - Must be a valid SDK Key
--
-- =============================================================
function applovin_helpers.setID( os, id )
   ids[os] = id
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

   applovin_helpers.setPhaseCB( "init", onInit, true )

]]
--
-- =============================================================
function applovin_helpers.setPhaseCB( phase, cb, once )
   once = fnn( once, true )
   phaseCallbacks[phase] = (cb) and { cb = cb, once = once } or nil
end

-- =============================================================
-- init( [ delay ] ) - Initilize Applovin ad network.
--                     If delay is specified, wait 'delay' ms then
--                     initialize.
--
-- https://docs.coronalabs.com/daily/plugin/applovin/init.html
-- =============================================================
function applovin_helpers.init( delay )
   -- Set default delay if not provided
   delay = delay or 0 
   
   -- A function that we may call immediately or with a delay
   -- to do the initialization work.
   local function doInit()
      -- If on Android,
      
      if( onAndroid and ids.android ) then
            applovin.init( listener, { sdkKey = ids.android } )

      elseif( oniOS and ids.ios ) then
         applovin.init( listener, { sdkKey = ids.ios } )

      elseif( onAppleTV and ids.apple_tv ) then
         applovin.init( listener, { sdkKey = ids.apple_tv } )
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
-- load() -- Load a new [incentivized] ad.
--
-- https://docs.coronalabs.com/daily/plugin/applovin/load.html
-- =============================================================
function applovin_helpers.load( isIncetivized )
   applovin.load( isIncetivized )
end


-- =============================================================
-- isLoaded() -- Checks if an [incentivized] ad is loaded
--
-- https://docs.coronalabs.com/daily/plugin/ads-Applovin-v2/isLoaded.html
-- =============================================================
function applovin_helpers.isLoaded( isIncetivized )
   return applovin.isLoaded( isIncetivized )
end

-- =============================================================
-- show() -- Shows an [incentivized] ad.
--
-- https://docs.coronalabs.com/daily/plugin/applovin/show.html
-- =============================================================
function applovin_helpers.show( isIncetivized )
   return applovin.show( isIncetivized )
end


-- =============================================================
-- setUserDetails() -- Set user details to be passed to Applovin for server-side callbacks.
--
-- https://docs.coronalabs.com/daily/plugin/applovin/setUserDetails.html
-- =============================================================
function applovin_helpers.setUserDetails( params )
   return applovin.setUserDetails( params )
end




return applovin_helpers