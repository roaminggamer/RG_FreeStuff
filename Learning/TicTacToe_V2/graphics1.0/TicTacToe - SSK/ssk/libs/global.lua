-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
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
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================

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
	if( obj and obj.removeSelf and type(obj.removeSelf) == "function") then 
		obj:removeSelf()
		setmetatable( obj, nil )  -- This happens automatically on the next simcycle/frame, but let's force it now
		obj.removeSelf = nil
	end
end

-- ==
--    randomColor() - Returns a table containing a random color code from the set allColors defined in ssk/globals.lua.
-- ==
function _G.randomColor( )
	local curColor = allColors[random(1, #allColors)]
	while(curColor == lastColor) do
		curColor = allColors[random(1, #allColors)]
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


