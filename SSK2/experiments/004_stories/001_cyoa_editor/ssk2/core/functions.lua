-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Global Functions
-- =============================================================
--   Last Updated: 29 NOV 2016
-- Last Validated: 29 NOV 2016
-- =============================================================

local getTimer  = system.getTimer
local strGSub   = string.gsub
local strSub    = string.sub
local strFormat = string.format
local mFloor    = math.floor
local mRand     = math.random

-- ==
--    fnn( ... ) - Return first argument from list that is not nil.
--    ... - Any number of any type of arguments.
-- ==
function _G.ssk.core.fnn( ... ) 
	for i = 1, #arg do
		local theArg = arg[i]
		if(theArg ~= nil) then return theArg end
	end
	return nil
end

-- ==
--    round(val, n) - Rounds a number to the nearest decimal places. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to round.
--    n - Number of decimal places to round to.
-- ==
function _G.ssk.core.round(val, n)
   if (n) then
      return math.floor( (val * 10^n) + 0.5) / (10^n)
   else
      return math.floor(val+0.5)
   end
end

-- nextFrame( func ) - Execute func in new frame. 
-- From Sergey's code: https://gist.github.com/Lerg
--
function _G.ssk.core.nextFrame( func, delay )
   delay = delay or 1
   timer.performWithDelay(delay, func )
end

-- Shorthand for Runtime:*() functions
--
local pairs = _G.pairs
_G.ssk.core.listen = function( name, listener ) Runtime:addEventListener( name, listener ) end
_G.ssk.core.ignore = function( name, listener ) Runtime:removeEventListener( name, listener ) end
_G.ssk.core.ignoreList = function( list, obj )
   if( not obj ) then return end
   for i = 1, #list do
      local name = list[i]
      if(obj[name]) then 
         ignore( name, obj ) 
         obj[name] = nil
      end
  end
end
_G.ssk.core.autoIgnore = function( name, obj ) 
   if( not display.isValid( obj ) ) then
      ignore( name, obj )
      obj[name] = nil
      return true
   end
   return false 
end

_G.ssk.core.post = function( name, params, debuglvl )
   params = params or {}
   local event = { name = name }
   for k,v in pairs( params ) do event[k] = v end
   if( not event.time ) then event.time = getTimer() end
   if( debuglvl and debuglvl >= 2 ) then table.dump(event) end
   Runtime:dispatchEvent( event )
   if( debuglvl and debuglvl >= 1 ) then print("post( '" .. name .. "' )" ) end   
end

-- Handy listener clearer (NOTE not fully verified)
_G.ssk.core.removeListeners = function( obj )
   if(obj) then
      obj._functionListeners = nil --this will remove all functions listeners
      obj._tableListeners = nil --this will remove all table listeners
   else
      _G._functionListeners = nil --this will remove all functions listeners
      _G._tableListeners = nil --this will remove all table listeners
   end
end
