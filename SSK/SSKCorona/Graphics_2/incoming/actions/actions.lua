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
-- ==           FOLLOW PATH
-- ===============================================
-- dps => degrees per second
function action.pathFollowingattach( obj, points, pathSmoothing, easing )
	obj.myPath = table.deepCopy( points )
	setmetatable(obj.myPath, getmetatable(points) )
end

function action.pathFollowingstart( obj )
end

function action.pathFollowingpause( obj )
end

function action.pathFollowingreset( obj )
end

function action.pathFollowingstop( obj )
end

function action.pathFollowingdetach( obj )
end


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


-- ================================================================
-- ================================================================
-- ==						MOVING
-- ================================================================
-- ================================================================

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



-- ================================================================
-- ================================================================
-- ==						SEEKING & AIMING
-- ================================================================
-- ================================================================

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
