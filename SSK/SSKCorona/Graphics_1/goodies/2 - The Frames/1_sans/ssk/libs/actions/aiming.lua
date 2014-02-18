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
-- ==           AIM AT OBJECT
-- ===============================================
-- ==
--    func() - what it does
-- ==
function action.aimAtObject( objA, target, period, onLoseCB )

	-- Catch case where aiming object was removed before delayed call occured
	if( not objA.x ) then
		return
	end

	if( not target.x ) then
		if(onLoseCB) then
			onLoseCB( objA, nil, "destroyed" )
		end
		return
	end

	--print(target.x)

	local tweenVec = ssk.math2d.sub( objA, target )
	local vecAngle = ssk.math2d.vector2Angle( tweenVec )
	
	objA.rotation = vecAngle

	local closure = function()
		action.aimAtObject( objA, target, period, onLoseCB )		
	end

	timer.performWithDelay( period, closure )
end

-- ===============================================
-- ==           AIM AT OBJECT MAX DIST
-- ===============================================
-- ==
--    func() - what it does
-- ==
function action.aimAtObjectMaxDist( objA, target, period, maxDist, onLoseCB, reseek )

	-- Catch case where aiming object was removed before delayed call occured
	if( not objA.x ) then
		return
	end

	if( not target.x ) then
		if(onLoseCB) then
			onLoseCB( objA, nil, "destroyed" )
		end
		return
	end

	local tweenVec = ssk.math2d.sub( objA, target )
	local vecAngle = ssk.math2d.vector2Angle( tweenVec )
	local vecLen,vx,vy = ssk.math2d.tweenDist( objA, target )
	--print("vecLen == " .. vecLen, tostring(reseek)) 

	local closure = function()
		action.aimAtObjectMaxDist( objA, target, period, maxDist, onLoseCB, reseek )
	end

	if(vecLen >= maxDist) then
		if(onLoseCB) then
			onLoseCB( objA, target, "distance" )
		end

		if(reseek) then 
			timer.performWithDelay( period, closure )			
		end
		return
	end

	objA.rotation = vecAngle

	timer.performWithDelay( period, closure )
end
