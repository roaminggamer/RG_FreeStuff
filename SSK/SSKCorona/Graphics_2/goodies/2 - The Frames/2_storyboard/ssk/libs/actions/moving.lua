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
-- ==           MOVE TO POINT
-- ===============================================
-- pps => pixels per second
-- ==
--    func() - what it does
-- ==
function action.moveToPoint( obj, x, y, pps, easing )
	local px = x
	local py = y	
	local pps = pps or 0
	pps = pps/1000
	local easing = easing or transition.linear

	-- Instant Move
	if(pps <=0 ) then
		obj.x,obj.y = px,py

	-- Timed Move
	else
		local vecLen,vx,vy = ssk.math2d.tweenDist( obj, {x=px,y=py} ) 
		local moveTime = round(vecLen / pps)
		transition.to( obj, { x = px, y = py, time = moveTime, transition = easing } )
	end
end

-- ===============================================
-- ==           MOVE TO OBJECT
-- ===============================================
-- ==
--    func() - what it does
-- ==
function action.moveToObject( objA, objB, pps, easing )
	action.moveToPoint( objA, objB.x, objB.y, pps, easing )
end

