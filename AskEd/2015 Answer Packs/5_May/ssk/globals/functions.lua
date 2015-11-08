-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
--                License
-- =============================================================
--[[
  > SSK is free to use.
  > SSK is free to edit.
  > SSK is free to use in a free or commercial game.
  > SSK is free to use in a free or commercial non-game app.
  > SSK is free to use without crediting the author (credits are still appreciated).
  > SSK is free to use without crediting the project (credits are still appreciated).
  > SSK is NOT free to sell for anything.
  > SSK is NOT free to credit yourself with.
]]
-- =============================================================
local socket    = require "socket"
local getTimer  = system.getTimer
local strGSub   = string.gsub
local strSub    = string.sub
local strFormat = string.format
local mFloor    = math.floor
local isValid; timer.performWithDelay(1, function() isValid  = display.isValid end )
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
local type = type
function _G.isDisplayObject( obj )
	return ( obj and obj.removeSelf and type(obj.removeSelf) == "function")
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
--    ternary() - Acts like C-style var = (text) ? true-val : false-val; statement
-- ==
function _G.ternary( test, a, b  )
  if(test) then
    return a
  else
    return b 
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
_G.autoIgnore = function( name, obj ) 
    if( not isValid( obj ) ) then
      ignore( name, obj )
      obj[name] = nil
      return true
    end
    return false 
end

_G.post = function( name, params, debuglvl )
   params = params or {}
   local event = { name = name }
   for k,v in pairs( params ) do event[k] = v end
   if( not event.time ) then event.time = getTimer() end
   if( debuglvl and debuglvl >= 2 ) then table.dump(event) end
   Runtime:dispatchEvent( event )
   if( debuglvl and debuglvl >= 1 ) then print("post( '" .. name .. "' )" ) end   
end
-- Handy listener clearer
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
--    rgba2(  ) - Converts Graphics 1.0 color table to a valid Graphics 2.0 color table.
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