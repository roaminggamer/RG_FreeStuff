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
local socket    = require "socket"
local getTimer  = system.getTimer
local strGSub   = string.gsub
local strSub    = string.sub
local strFormat = string.format
local mFloor = math.floor

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
--  _G.listen = function( name, listener ) Runtime:addEventListener( name, listener ) end
_G.listen = function( name, listener ) 
  if( type(listener) == "function" ) then
    Runtime:addEventListener( name, listener ) 
  else
    local listener2
    listener2 = function( event )
      if( not listener or listener.removeSelf == nil ) then
        Runtime:removeEventListener( name, listener2 )
        return
      else
        listener[name]( listener, event )        
      end
    end
    Runtime:addEventListener( name, listener2 )
  end
end

_G.ignore = function( name, listener ) Runtime:removeEventListener( name, listener ) end
_G.post = function( name, params, debuglvl )
   local params = params or {}
   local event = { name = name }
   for k,v in pairs( params ) do
      event[k] = v
   end
   if( not event.time ) then event.time = getTimer() end
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

-- ==
--    rgba2(  ) - converts table to rgba Graphics 2.0 value
-- ==
function _G.rgba2( colors )
  local colors2 = {}
  colors[4] = colors[4] or 255
  colors2[1] = colors[1]/255
  colors2[2] = colors[2]/255
  colors2[3] = colors[3]/255
  colors2[4] = colors[4]/255
  return colors2
end

-- ==
--    hexcolor(  ) - converts hex color codes to rgba Graphics 2.0 value
-- ==
function _G.hexcolor( code )
  code = code and string.gsub( code , "#", "") or "FFFFFFFF"
  code = string.gsub( code , " ", "")
  local colors = {1,1,1,1}
  while code:len() < 8 do
    code = code .. "F"
  end
  local r = tonumber("0X" ..strSub( code, 1, 2 ))
  local g = tonumber("0X" ..strSub( code, 3, 4 ))
  local b = tonumber("0X" ..strSub( code, 5, 6 ))
  local a = tonumber("0X" ..strSub( code, 7, 8 ))
  local colors = { r/255, g/255, b/255, a/255  }
  return colors
end

function _G.easyUnderline( obj, color, strokeWidth, extraWidth, yOffset )
    color = color or { 1,1,1,1 }
    strokeWidth = strokeWidth or 1
    extraWidth = extraWidth or 0
    yOffset = yOffset or 0
    local lineWidth = obj.contentWidth + extraWidth
    local x = obj.x - lineWidth/2
    local y = obj.y + obj.contentHeight/2 + strokeWidth + yOffset
    local line = display.newLine( obj.parent, x, y, x + lineWidth, y )
    line:setStrokeColor( unpack(color) )
end

function _G.catchAllTouches( obj )
  obj.touch = function() return true end
  obj:addEventListener( "touch" )
end

function _G.removeCatchAllTouches( obj )  
  obj:removeEventListener( "touch" )
  obj.touch = nil
end


local mRand = math.random
local keySrc = "abcdefghijklmnopqrstuvwxyaABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
--local keySrc = "abcdefghijklmnopqrstuvwxyaABCDEFGHIJKLMNOPQRSTUVWXYZ"
local keyTbl = {}
for i = 1, #keySrc do
  keyTbl[i] = keySrc:sub(i,i)
end
--table.dump(keyTbl)

_G.getUID = function( rlen )
  local tmp = ""
  local max = #keyTbl
  for i = 1, rlen do
    tmp = tmp .. keyTbl[mRand(1,max)]
  end
  return tmp
end


_G.normRot = function( obj )
  while( obj.rotation >= 360 ) do obj.rotation = obj.rotation - 360 end
  while( obj.rotation < 0 ) do obj.rotation = obj.rotation + 360 end
end

_G.normRot2 = function( rotation )
  while( rotation >= 360 ) do rotation = rotation - 360 end
  while( rotation < 0 ) do rotation = rotation + 360 end
  return rotation
end


-- ==
--    pushDisplayDefault() / popDisplayDefault()- 
-- ==
local defaultValues = {}
function _G.pushDisplayDefault( defaultName, newValue )
  if( not defaultValues[defaultName] ) then defaultValues[defaultName] = {} end
  local values = defaultValues[defaultName]
  values[#values+1] = display.getDefault( defaultName )
  display.setDefault( defaultName, newValue )
end

function _G.popDisplayDefault( defaultName )
  if( not defaultValues[defaultName] ) then defaultValues[defaultName] = {} end
  local values = defaultValues[defaultName]
  if(#values == 0) then return end

  local tmp = values[#values]
  values[#values] = nil
  display.setDefault( defaultName, tmp )
end
