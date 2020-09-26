-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Global Functions
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
function _G.fnn( ... ) 
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
function _G.round(val, n)
   if (n) then
      return math.floor( (val * 10^n) + 0.5) / (10^n)
   else
      return math.floor(val+0.5)
   end
end

-- nextFrame( func ) - Execute func in new frame. 
-- From Sergey's code: https://gist.github.com/Lerg
--
function _G.nextFrame( func, delay )
   delay = delay or 1
   timer.performWithDelay(delay, func )
end

-- Shorthand for Runtime:*() functions
--
local pairs = _G.pairs
_G.listen = function( name, listener ) Runtime:addEventListener( name, listener ) end
_G.ignore = function( name, listener ) Runtime:removeEventListener( name, listener ) end
_G.ignoreList = function( list, obj )
   if( not obj ) then return end
   for i = 1, #list do
      local name = list[i]
      if(obj[name]) then 
         ignore( name, obj ) 
         obj[name] = nil
      end
  end
end
_G.autoIgnore = function( name, obj ) 
   if( not display.isValid( obj ) ) then
      ignore( name, obj )
      obj[name] = nil
      return true
   end
   return false 
end

_G.post = function( name, params, debuglvl )
   params = params or {}
   local event = {}
   for k,v in pairs( params ) do event[k] = v end
   if( not event.time ) then event.time = getTimer() end
   event.name = name
   if( debuglvl and debuglvl >= 2 ) then table.dump(event) end
   Runtime:dispatchEvent( event )
   if( debuglvl and debuglvl >= 1 ) then print("post( '" .. name .. "' )" ) end   
end

-- Handy listener clearer (NOTE not fully verified)
_G.removeListeners = function( obj )
   if(obj) then
      obj._functionListeners = nil --this will remove all functions listeners
      obj._tableListeners = nil --this will remove all table listeners
   else
      _G._functionListeners = nil --this will remove all functions listeners
      _G._tableListeners = nil --this will remove all table listeners
   end
end


--
-- unrequire( path ) - Basic un-require.  
--
function _G.unrequire(path)
    package.loaded[path] = nil
    rawset(_G, path, nil)
    return true
end

--
-- Debugging code taken and modified from: 
-- https://forums.coronalabs.com/topic/5595-atrace-better-than-print-for-debugging/
--
--
--
-- trace: pass a message and how deep you want to print the stack
--
function _G.trace( msg, depth )
   if( not debug or not debug.traceback ) then return end
   depth = depth or 1

   if( type(msg) == "function" ) then
      local funcInfo = debug.getinfo(msg)
      msg = "function " ..  funcInfo.source .. ":[" .. funcInfo.linedefined .. ", " .. funcInfo.lastlinedefined .. "]"
   end

   local curTime = system.getTimer()
   local ms = curTime % 1000
   local secs = math.floor(curTime / 1000)
   local mins = math.floor(secs / 60)
   local hours = math.floor(mins / 60)
   secs = secs % 60
   mins = mins % 60
   hours = hours % 24
   local sysTime = string.format("(%02d:%02d:%02d:%03d)", hours, mins, secs, ms)
   print( " = > trace " .. sysTime .. msg )
   local info = debug.traceback():split("\n")
   local count = 1
   for i, v in ipairs( info ) do
     count = count + 1
     if( count > 3 and count < (3+depth+1) ) then
         print(tostring(v))
     end

   end
   print()
end
--     USAGE SAMPLES:
--[[

local test = 10

if( test == 1 ) then
   local bob = 10
   _G.trace(bob)

elseif( test == 2 ) then
    _G.bill = "Rock!"
    _G.trace(bill)

elseif( test == 3 ) then
   local settings = { age = 10, name == "sue", coins = 100 }
   _G.trace( 'settings ' .. table.xinspect(settings) )

elseif( test == 4 ) then
   -- Recursion would kill normal print_r, but with xinspect we still get partial result
   local settings = { age = 10, name == "sue", coins = 100 }
   settings.settings = settings
   _G.trace( 'settings ' .. table.xinspect(settings) )

elseif( test == 5 ) then
   local function funcA()
      _G.trace('inside funcA')
   end
   funcA()

elseif( test == 6 ) then
   local function funcA()
      _G.trace('inside funcA')
      local function funcB()
         _G.trace('inside funcB',2)
         --_G.trace('inside funcB',100)
      end
      funcB()
   end
   funcA()

elseif( test == 7 ) then
   local function funcA()
      _G.trace('inside funcA')
   end

   local funcInVar = funcA
   funcInVar()

elseif( test == 8 ) then
   local function funcA()
   end
   local funcInVar = funcA
   _G.trace(funcInVar)

elseif( test == 9 ) then
   local function funcA()
      _G.trace('inside funcA')
   end
   local function funcB()
      _G.trace('inside funcB')
   end

   local funcTable = {}
   funcTable[1] = funcA
   funcTable[2] = funcB
   funcTable[2]()


elseif( test == 10 ) then
   local function funcA()
      _G.trace('inside funcA')
   end
   local function funcB()
      _G.trace('inside funcB')
   end

   local funcTable = {}
   funcTable[1] = funcA
   funcTable[2] = funcB
   
   for k,v in pairs(funcTable) do
      --v()
      _G.trace('Definition location of function: ')
      _G.trace(v)

   end


elseif( test == 11 ) then
   local function funcA()
      _G.trace('inside funcA')
   end
   local function funcB()
      _G.trace('inside funcB')
   end

   local funcTable = {}
   funcTable.fa = funcA
   funcTable.fb = funcB
   funcTable.fa()
   funcTable["fa"]()

end
--]]