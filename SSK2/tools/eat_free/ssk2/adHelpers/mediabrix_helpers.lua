-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- mediabrix_helpers.lua
-- =============================================================
--[[

   Includes these functions:

   mediabrix_helpers.setID( os, id ) - Set an id manually (do before init if at all).
   mediabrix_helpers.init( [ delay ] ] ) - Initialize ads with optional delay.  

   mediabrix_helpers.load( params ) - Load an new ad for specific placementID.
   mediabrix_helpers.show( placementID ] ) - Show ad for specific placementID.
   mediabrix_helpers.isLoaded() - Returns true if ad is loaded for specific placementID.

   mediabrix_helpers.testStatus( phase ) - Returns true if phase has been triggered in listener.
   mediabrix_helpers.clearStatus( phase ) - Clear the flag for the named 'phase'

   mediabrix_helpers.setPhaseCB( phase [, cb [, once ] ] ) - Provide a special callback to execute when the 
      listener event 'phase' occurs.  If once is set to 'true', the callback is called once then cleared.

--]]
-- =============================================================
-- =============================================================
local mediaBrix = require( "plugin.mediaBrix" )

local lastID -- Set 'on show' to simplify call to hide

local debugLevel = 0
local function dPrint( level, ... )
   if( level <= debugLevel ) then
      print( unpack( arg ) )
   end
end


local mediabrix_helpers = {}

function mediabrix_helpers.setDebugLevel( newLevel )
   debugLevel = newLevel or 0 
end


-- Place to store phase callback records [see: mediabrix_helpers.setPhaseCB()]
--
local phaseCallbacks = {}

-- Special statuses (based on phases and other actions)
--[[
]]
local status  = {}
mediabrix_helpers.status = status
function mediabrix_helpers.testStatus( phase )
   return fnn(status[phase], false)
end
function mediabrix_helpers.clearStatus( phase )
   status[phase] = false
end

-- ==
--    Table of ids, separated by OS and type (banner or interstitial)
-- ==
local ids = 
{ 
   android = ANDROID_ID,
   ios     = IOS_ID
}

-- ==
--    mediaBrix Listener 
-- ==
local function listener( event ) 
   -- Extract base set of useful event details:
   local isError     = (event.isError == nil) and false or event.isError
   local phase       = (event.phase == nil) and "unknown" or event.phase   
   local eType       = (event.type == nil) and "unknown" or event.type   
   local response    = (event.name == nil) and "unknown" or event.response

   dPrint( 3, "mediaBrix Listener Event @ ", system.getTimer )
   dPrint( 3, 'isError: ' .. tostring( isError ) .. '; phase == "' .. tostring(phase) .. '"; response == "' .. tostring(response) .. '"' )

   -- Do something with the above details...
   --
   if( isError ) then
      dPrint( 1,  "mediaBrix is getting errors.")
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
         dPrint( 1, "mediaBrix is getting a weird event.phase value?! ==> " .. tostring( event.phase ) )
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
-- setID( os, id ) - Set an id for a specific OS 
--
-- os - 'android' or 'ios'
-- id - Must be a valid ID
--
-- =============================================================
function mediabrix_helpers.setID( os, id )
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
      dPrint( 3, ("Init phase completed!")
      table.dump(event)
   end

   mediabrix_helpers.setPhaseCB( "init", onInit, true )

]]
--
-- =============================================================
function mediabrix_helpers.setPhaseCB( phase, cb, once )
   once = fnn( once, true )
   phaseCallbacks[phase] = (cb) and { cb = cb, once = once } or nil
end

-- =============================================================
-- init( [ delay ] ) - Initilize revMob ad network.
--   If delay is specified, wait 'delay' ms then initialize.
--
-- https://docs.coronalabs.com/daily/plugin/mediaBrix/init.html
-- =============================================================
function mediabrix_helpers.init( delay )
   -- Set default delay if not provided
   delay = delay or 0 
   
   -- A function that we may call immediately or with a delay
   -- to do the initialization work.
   local function doInit()

      -- If on Android,
      if( onAndroid and ids.android ) then
         mediaBrix.init( listener, { appId = ids.android } )

      -- else if on iOS,
      elseif( oniOS and ids.ios ) then
         mediaBrix.init( listener, { appId = ids.ios } )

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
-- load( placementID ) -- Load an ad for a specific placementID.
--
-- https://docs.coronalabs.com/daily/plugin/mediaBrix/load.html
-- =============================================================
function mediabrix_helpers.load( placementID )
   mediaBrix.load( placementID )
end

-- =============================================================
-- show( placementID ) -- Show an ad for a specific placementID.
--
-- https://docs.coronalabs.com/daily/plugin/mediaBrix/show.html
-- =============================================================
function mediabrix_helpers.show( placementID )
   mediaBrix.show( placementID )
end

-- =============================================================
-- isLoaded( placementID ) -- Returns true if an ad for a specific placementID is loaded.
--
-- https://docs.coronalabs.com/daily/plugin/mediaBrix/isLoaded.html
-- =============================================================
function mediabrix_helpers.isLoaded( placementID )
   return mediaBrix.isLoaded( placementID ) or false
end


return mediabrix_helpers