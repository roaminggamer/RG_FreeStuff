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
	if( obj and obj.removeSelf and type(obj.removeSelf) == "function") then 
		obj:removeSelf()
		-- If this function is called on joints, type(obj) returns "userdata"
		-- Userdata don't have metatables :)
		if(type(obj) == "table") then
			setmetatable( obj, nil )  -- This happens automatically on the next simcycle/frame, but let's force it now
		end
		obj.removeSelf = nil
	end
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


--EFM G2
--[[
-- ==
-- Shortened versions of obj:setReferencePoint()
-- srpC( obj ) == obj:setReferencePoint( display.CenterReferencePoint)
-- srpTL( obj ) == obj:setReferencePoint( display.TopLeftReferencePoint)
-- srpTC( obj ) == obj:setReferencePoint( display.TopCenterReferencePoint)
-- srpTR( obj ) == obj:setReferencePoint( display.TopRightReferencePoint)
-- srpCR( obj ) == obj:setReferencePoint( display.CenterRightReferencePoint)
-- srpBR( obj ) == obj:setReferencePoint( display.BottomRightReferencePoint)
-- srpBC( obj ) == obj:setReferencePoint( display.BottomCenterReferencePoint)
-- srpBL( obj ) == obj:setReferencePoint( display.BottomLeftReferencePoint)
-- srpCL( obj ) == obj:setReferencePoint( display.CenterLeftReferencePoint)
-- ==
function _G.srpC( obj ) obj:setReferencePoint( display.CenterReferencePoint) end
function _G.srpTL( obj ) obj:setReferencePoint( display.TopLeftReferencePoint) end
function _G.srpTC( obj ) obj:setReferencePoint( display.TopCenterReferencePoint) end
function _G.srpTR( obj ) obj:setReferencePoint( display.TopRightReferencePoint) end
function _G.srpCR( obj ) obj:setReferencePoint( display.CenterRightReferencePoint) end
function _G.srpBR( obj ) obj:setReferencePoint( display.BottomRightReferencePoint) end
function _G.srpBC( obj ) obj:setReferencePoint( display.BottomCenterReferencePoint) end
function _G.srpBL( obj ) obj:setReferencePoint( display.BottomLeftReferencePoint) end
function _G.srpCL( obj ) obj:setReferencePoint( display.CenterLeftReferencePoint) end

--]] --EFM G2