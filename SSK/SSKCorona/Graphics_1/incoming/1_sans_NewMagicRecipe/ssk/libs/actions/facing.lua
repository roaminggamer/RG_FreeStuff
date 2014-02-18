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

-- ================================================================
-- ================================================================
-- ==						FACING
-- ================================================================
-- ================================================================

-- ===============================================
-- ==           FACE POINT
-- ===============================================
-- dps => degrees per second
-- ==
--    func() - what it does
-- ==
function action.facePoint( obj, x, y, dps, easing )
	local px = x
	local py = y	
	local dps = dps or 0
	dps = dps/1000
	local easing = easing or transition.linear

	local tweenAngle, vecAngle = ssk.math2d.tweenAngle( obj, {x=px,y=py} )

	-- Instant Turn
	if(dps <=0 ) then
		obj.rotation = vecAngle

	-- Timed Turn
	else
		if(tweenAngle >= 180) then
			vecAngle = vecAngle - 360
			tweenAngle  = vecAngle - obj.rotation
		elseif(tweenAngle <= -180) then
			vecAngle = vecAngle + 360
			tweenAngle  = vecAngle - obj.rotation
		end	

		local rotateTime = math.abs(round(tweenAngle / dps))

		transition.to( obj, { rotation = vecAngle, time = rotateTime, transition = easing } )
	end
end
-- ===============================================
-- ==           FACE OBJECT
-- ===============================================
-- ==
--    func() - what it does
-- ==
function action.faceObject( objA, objB, dps, easing )
	action.facePoint( objA, objB.x, objB.y, dps, easing )
end

