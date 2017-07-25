-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- vungle_helpers.lua
-- =============================================================
--[[

   Includes these functions:

   vungle_helpers.setID( os, id ) - Set an id manually (do before init if at all).
   vungle_helpers.init( [delay] ) - Initialize ads with optional delay.
   vungle_helpers.showInterstitial( [ params ] ] ) - Show normal video ad with optional params settings.
   vungle_helpers.showIncentivized( [ params ] ] ) - Show incentivized video ad with optional params settings.
   vungle_helpers.isAdAvailable( ) - Returns 'true' if ad is cached.

   vungle_helpers.testStatus( phase ) - Returns true if phase has been triggered in listener.
   vungle_helpers.clearStatus( phase ) - Clear the flag for the named 'phase'

   vungle_helpers.setPhaseCB( phase [, cb [, once ] ] ) - Provide a special callback to execute when the 
      listener event 'phase' occurs.  If once is set to 'true', the callback is called once then cleared.

--]]
-- =============================================================
-- =============================================================
local ads = require( "ads" )

local debugLevel = 0
local function dPrint( level, ... )
   if( level <= debugLevel ) then
      print( unpack( arg ) )
   end
end


local vungle_helpers = {}

function vungle_helpers.setDebugLevel( newLevel )
   debugLevel = newLevel or 0 
end

-- Place to store phase callback records [see: vungle_helpers.setPhaseCB()]
--
local phaseCallbacks = {}

-- Special statuses (based on phases and other actions)
--[[
]]
local status  = {}
vungle_helpers.status = status
function vungle_helpers.testStatus( phase )
   return fnn(status[phase], false)
end
function vungle_helpers.clearStatus( phase )
   status[phase] = false
end



-- ==
--    Table of ids, separated by OS and type (banner or interstitial)
-- ==
local ids = 
{ 
   android = ANDROID_ID,
   ios = IOS_ID,
}


-- ==
--    Example Vungle Listener 
-- ==
local function listener( event ) 
   -- Extract base set of useful event details:
   local isError     = (event.isError == nil) and false or event.isError
   local name        = (event.name == nil) and "unknown" or event.name
   local eType       = (event.type == nil) and "unknown" or event.type
   local provider    = (event.provider == nil) and "unknown" or event.provider

   dPrint( 3, "Vungle Listener Event @ ", system.getTimer )
   dPrint( 3, 'isError: ' .. tostring( isError ) .. '; name == "' .. tostring(name) .. '"' .. '; evnt type == "' .. tostring(eType) .. '"' )

   -- Do something with the above details...
   --
   if( isError ) then
      dPrint( 1,  "Vungle is getting errors.")
      for k,v in pairs( event ) do
         dPrint( 1, k,v)
      end

   else
      if( name == "adsRequest" ) then

         -- Tip: These are checked for in the typical order they happen:
         --
         if( eType == "cachedAdAvailable" ) then
            dPrint( 3, "We got an ad!  We should be ready to show it.")
        

         elseif( eType == "adStart" ) then
            dPrint( 3, "Ad started playing!")

         elseif( eType == "adView" ) then
            -- 
            -- This is part 1 of what you most care about!
            --
            local isCompletedView   = (event.isCompletedView == nil) and false or event.isCompletedView
            local secondsWatched    = (event.secondsWatched == nil) and 0 or event.secondsWatched
            local totalSeconds      = (event.secondsWatched == nil) and 0 or event.totalAdSeconds
            local percentWatched    = (secondsWatched == 0 or totalSeconds == 0) and 0 or (secondsWatched/totalSeconds)


            if( isCompletedView ) then
               dPrint( 3, "User watched entire video! " .. tostring(isCompletedView) )
            else           
               dPrint( 3, "User watched " .. tostring( 100 * percent ) .. "% of the video.")
            end

            dPrint( 3, "Video was " .. tostring( totalSeconds) .. " seconds long.")


         elseif( eType == "adEnd" ) then
            -- 
            -- This is part 2 of what you most care about!
            --
            local wasCallToActionClicked  = (event.wasCallToActionClicked == nil) and false or event.wasCallToActionClicked

            dPrint( 3, "The ad ended!")

            if( wasCallToActionClicked ) then
               dPrint( 3, "The user clicked the ad, give them a reward here.")
            else

               dPrint( 3, "The user DID NOT click the ad.... no reward for them.")
            end
         end

         status[eType or "error"] = true
         local cb = phaseCallbacks[eType]
         if( cb ) then
            cb.cb(event)
            if(cb.once) then
               phaseCallbacks[eType] = nil
            end
         end

      else
         dPrint( 1,  "Vungle is getting a weird event.name value?! Turn on vungle module's debug output to see more details.")
      end

   end
end

-- =============================================================
-- setID( os, id ) - Set an id for a specific OS.
--
-- os - 'android' or 'ios'
-- id - Must be a valid ID
--
-- =============================================================
function vungle_helpers.setID( os, id )
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

   vungle_helpers.setPhaseCB( "init", onInit, true )

]]
--
-- =============================================================
function vungle_helpers.setPhaseCB( phase, cb, once )
   once = fnn( once, true )
   phaseCallbacks[phase] = (cb) and { cb = cb, once = once } or nil
end

-- =============================================================
-- init( [ delay ] ) - Initilize adMob ad network.
--                     If delay is specified, wait 'delay' ms then
--                     initialize.
--
-- https://docs.coronalabs.com/daily/plugin/vungle/init.html
-- =============================================================
function vungle_helpers.init( delay )
   -- Set default delay if not provided
   delay = delay or 0 
   
   -- A function that we may call immediately or with a delay
   -- to do the initialization work.
   local function doInit()

      -- Android
      --
      if( onAndroid and  ids.android ) then
            ads.init( "vungle", ids.android, listener )

      -- iOS (Apple)
      --
      elseif( oniOS and ids.ios ) then         
            ads.init( "vungle", ids.ios, listener )

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
-- showInterstitial( [ params ]) -- Show normal video ad with optional params settings.
--
-- params - Optional parameterized table of options (type)[default):
--          > isAnimated (bool)[true], 
--          > isAutoRotation (bool)[true],
--          > orientations - I am not clear on this setting,
--          > isBackButtonEnabled (bool)[Android only: true],
--          > isSoundEnabled(bool)[true],
--          > username(string)(nil) - Only applies to "incentivized ads"
--
-- https://docs.coronalabs.com/daily/plugin/vungle/show.html
-- =============================================================
function vungle_helpers.showInterstitial( params )
   params = params or {}

   -- Set provider to vungle
   ads:setCurrentProvider("vungle")

   ads.show( "interstitial", params )
end

-- =============================================================
-- showIncentivized( [ params ]) -- Show normal video ad with optional params settings.
--
-- params - Optional parameterized table of options (type)[default):
--          > isAnimated (bool)[true], 
--          > isAutoRotation (bool)[true],
--          > orientations - I am not clear on this setting,
--          > isBackButtonEnabled (bool)[Android only: true],
--          > isSoundEnabled(bool)[true],
--          > username(string)(nil) - Only applies to "incentivized ads"
--
-- https://docs.coronalabs.com/daily/plugin/vungle/show.html
-- =============================================================
function vungle_helpers.showIncentivized( params )
   params = params or {}

   -- Set provider to vungle
   ads:setCurrentProvider("vungle")

   ads.show( "incentivized", params )
end

-- =============================================================
-- isAdAvailable() -- Returns true if ad is cached.
--
-- https://docs.coronalabs.com/daily/plugin/vungle/isAdAvailable.html
-- =============================================================
function vungle_helpers.isAdAvailable( )

   -- Set provider to vungle
   ads:setCurrentProvider("vungle")

   return ( ads.isAdAvailable() )
end


return vungle_helpers