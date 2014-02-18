-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Game Logic Modules
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

--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

local action

if( not _G.ssk.action ) then
	_G.ssk.action = {}
end

action = _G.ssk.action

local fnn = fnn
local angle2Vector = ssk.math2d.angle2Vector
local vector2Angle = ssk.math2d.vector2Angle
local scaleVector  = ssk.math2d.scale

-- ===============================================
-- ==           SEEK OBJECT
-- ===============================================
-- seekTest: Test one object to see if it matches the search criteria
-- Note: Passing nil for 'maxDist' and 'maxAngle' will automatically
-- return true or any 'objB'. i.e. With no dist or angle test, the object
-- is always 'found'
-- ==
--    func() - what it does
-- ==
function action.seekTest(objA, objB, maxDist, maxAngle )

	local vx,vy,nx,ny,vecLen,vecAngle,tweenAngle = ssk.math2d.tweenData( objA, objB )

	if(maxDist) then
		if(vecLen >= maxDist) then
			return false
		end
	end

	if( maxAngle ) then
		if(tweenAngle >= 360) then
			tweenAngle = tweenAngle - 360
		end
		tweenAngle = math.abs( tweenAngle )
	end

	return true
end

-- ==
--    func() - what it does
-- ==
function action.seekObject( objA, targetTable, maxDist, maxAngle)
	local seekPeriod = seekPeriod or 100
	-- Note: No search order is guaranteed, but this works for all tables of
	-- targets, regardless of index scheme
	for k,v in pairs(targetTable) do
		if( action.seekTest( objA, v, maxDist, maxAngle ) )then
			return v
		end
	end
	return nil
end

