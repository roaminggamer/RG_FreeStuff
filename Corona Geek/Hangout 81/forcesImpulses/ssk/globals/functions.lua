-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Various Global Functions
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- =============================================================
local socket = require "socket"

-- ==
--    noErrorAlerts(  ) - Turns off those annoying error popups! :)
-- ==
function _G.noErrorAlerts()
	Runtime:hideErrorAlerts( )
end


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
--    isDisplayObject( obj ) - Check if an object is valid and has NOT had removeSelf() called yet.
--    obj - The object to test.
-- == 
function _G.isDisplayObject( obj )
	if( obj and obj.removeSelf and type(obj.removeSelf) == "function") then return true end
	return false
end

--==
--   safeRemove( obj ) - (More) safely remove a displayObject.
--   obj - Object to remove.
-- ==
function _G.safeRemove( obj )
	display.remove( obj )
end

-- ==
--    randomColor() - Returns a table containing a random color code from the set allColors defined in ssk/globals.lua.
-- ==
function _G.randomColor( )
	local curColor = allColors[math.random(1, #allColors)]
	while(curColor == lastColor) do
		curColor = allColors[math.random(1, #allColors)]
	end

	lastColor = curColor
	return curColor
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


-- ==
--    comma_value(val, n) - Converts a number to a comma separated string. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to convert to comma separated string.
-- ==
function _G.comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end


_G.isConnectedToWWW = function( url )
   local url = url or "www.google.com" 
   local hostFound = true
   local con = socket.tcp()
   con:settimeout( 2 ) -- Timeout connection attempt after 2 seconds
             
   -- Check if socket connection is open
   if con:connect(url, 80) == nil then 
      hostFound = false
   end

   return hostFound
end


local pairs = _G.pairs
_G.listen = function( name, listener ) Runtime:addEventListener( name, listener ) end
_G.ignore = function( name, listener ) Runtime:removeEventListener( name, listener ) end
_G.post = function( name, params, debuglvl )
   local params = params or {}
   local event = { name = name }
   for k,v in pairs( params ) do
      event[k] = v
   end
   if( debuglvl and debuglvl >= 2 ) then table.dump(event) end
   Runtime:dispatchEvent( event )
   if( debuglvl and debuglvl >= 1 ) then print("post( '" .. name .. "' )" ) end   
end



-- ==
--    func() - what it does
-- ==
function _G.secondsToTimer( seconds )
  local seconds = seconds or 0
  seconds = tonumber(seconds)
  local minutes = math.floor(seconds/60)
  local remainingSeconds = seconds - (minutes * 60)

  local timerVal = "" 

  if(remainingSeconds < 10) then
    timerVal =  minutes .. ":" .. "0" .. remainingSeconds
  else
    timerVal = minutes .. ":"  .. remainingSeconds
  end

  return timerVal
end

-- ==
--    func() - what it does
-- ==
local mFloor = math.floor
function _G.secondsToTimer2( seconds )
  local seconds = seconds or 0
  seconds = tonumber(seconds)
  local nHours = string.format("%02.f", mFloor(seconds/3600));
  local nMins = string.format("%02.f", mFloor(seconds/60 - (nHours*60)));
  local nSecs = string.format("%02.f", mFloor(seconds - nHours*3600 - nMins *60));
  return nHours..":"..nMins.."."..nSecs
end

-- ==
--    func() - what it does
-- ==
function _G.secondsToTimer3( seconds )
  local seconds = seconds or 0
  local nDays = 0
  seconds = tonumber(seconds)
  local nHours = string.format("%02.f", mFloor(seconds/3600));
  local nMins = string.format("%02.f", mFloor(seconds/60 - (nHours*60)));
  local nSecs = string.format("%02.f", mFloor(seconds - nHours*3600 - nMins *60));

  nHours = tonumber(nHours)
  nMins = tonumber(nMins)
  
  while (nHours >= 24) do
    nDays = nDays + 1
    nHours = nHours - 24
  end

  return nDays,nHours,nMins,nSecs 
end

-- ==
--    ternary() - Acts like C-style var = (text) ? true-val : false-val; statement
-- ==
function _G.ternary( test, a, b  )
  if(test) then
    return a
  else
    return b 
  end  
end

function _G.isInBounds( obj, obj2 )
  if(not obj2) then return false end

  local bounds = obj2.contentBounds
  if( obj.x > bounds.xMax ) then return false end
  if( obj.x < bounds.xMin ) then return false end
  if( obj.y > bounds.yMax ) then return false end
  if( obj.y < bounds.yMin ) then return false end
  return true
end

-- ==
--    Sergey Stuff - Nice bits from Sergey's code: https://gist.github.com/Lerg
-- ==
--    nextFrame( func ) - Execute func in new frame.
function _G.nextFrame( func,delay )
    local delay = delay or 1
    timer.performWithDelay(delay, func )
end
function _G.datetime()
    local t = os.date('*t')
    return t.year .. '-' .. t.month .. '-' .. t.day .. ' ' .. t.hour .. ':' .. t.min .. ':' .. t.sec
end
function _G.parseDatetime(datetime)
    local pattern = '(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)'
    local year, month, day, hour, minute, seconds = datetime:match(pattern)
    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)
    return {year = year, month = month, day = day, hour = hour, min = minute, sec = seconds}
end
function _G.HSVtoRGB(h, s, v)
    local r,g,b
    local i
    local f,p,q,t

    if s == 0 then
        r = v
        g = v
        b = v
        return r, g, b
    end

    h =   h / 60;
    i  = math.floor(h);
    f = h - i;
    p = v *  (1 - s);
    q = v * (1 - s * f);
    t = v * (1 - s * (1 - f));
    if i == 0 then
        r = v
        g = t
        b = p
    elseif i == 1 then
        r = q
        g = v
        b = p
    elseif i == 2 then
        r = p
        g = v
        b = t
    elseif i == 3 then
        r = p
        g = q
        b = v
    elseif i == 4 then
        r = t
        g = p
        b = v
    elseif i == 5 then
        r = v
        g = p
        b = q
    end
    return r, g, b
end

_G.removeListeners = function( obj )
  if(obj) then
    obj._functionListeners = nil --this will remove all functions listeners
    obj._tableListeners = nil --this will remove all table listeners
  else
    _G.Runtime._functionListeners = nil --this will remove all functions listeners
    _G.Runtime._tableListeners = nil --this will remove all table listeners
  end
end