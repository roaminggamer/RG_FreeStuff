-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Miscellaneous Utilities
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

local misc

if( not _G.ssk.misc ) then
	_G.ssk.misc = {}
end

misc = _G.ssk.misc

-- ==
--    func() - what it does
-- ==
function misc.ternary( test, a, b  )
	return test and a or b
end

-- ==
--    func() - what it does
-- ==
function misc.convertSecondsToTimer( seconds )
	local seconds = tonumber(seconds)
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
-- EFM: Remove me when dependencies are removed in behavior(s) that use this
-- ==
function misc.processEvent( obj, event, doDeltas, doTouchVec, doTouchAngle )

	local doDeltas     = doDeltas or false
	local doTouchAngle = doTouchAngle or false
	local doTouchVec   = doTouchVec or doTouchAngle or false

	if(event.phase == "began") then	
		obj.isActive = true

		obj.startX, obj.startY = event.xStart, event.yStart
		obj.lastX, obj.lastY   = obj.curX, obj.curY
		obj.curX, obj.curY     = event.x, event.y

		obj.startTime          = event.time
		obj.activeTime         = 0
		obj.lastInputTime      = event.time
		obj.inputTime          = event.time
		obj.deltaTime          = 0

		-- Calculate deltas between last input and current input
		if(doDeltas) then
			obj.deltaX,obj.deltaY = 0,0
			obj.deltaLen          = 0
		end

		-- Calculate touch vector:  startXY ------> curXY
		if(doTouchVec) then
			obj.touchVecX,obj.touchVecY = 0,0
			obj.touchVecLen             = 0
		end

		-- Calculate angle of touch vector:  startXY ------> curXY
		if(doTouchAngle) then
			obj.touchAngle = 0
		end		

	elseif(event.phase == "moved" or event.phase == "ended" or event.phase == "cancelled") then	
		obj.startX, obj.startY = event.xStart, event.yStart
		obj.lastX, obj.lastY   = obj.curX, obj.curY
		obj.curX, obj.curY     = event.x, event.y

		obj.activeTime         = event.time - obj.startTime
		obj.lastInputTime      = obj.inputTime
		obj.inputTime          = event.time
		obj.deltaTime          = obj.inputTime - obj.lastInputTime

		-- Calculate deltas between last input and current input
		if(doDeltas) then
			obj.deltaX,obj.deltaY = ssk.math2d.sub(obj.lastX, obj.lastY, obj.curX, obj.curY )
			obj.deltaLen          = ssk.math2d.length(obj.deltaX,obj.deltaY)
		end

		-- Calculate touch vector:  startXY ------> curXY
		if(doTouchVec) then
			obj.touchVecX,obj.touchVecY = ssk.math2d.sub(obj.startX, obj.startY, obj.curX, obj.curY )
			obj.touchVecLen             = ssk.math2d.length(obj.touchVecX,obj.touchVecY)
		end

		-- Calculate angle of touch vector:  startXY ------> curXY
		if(doTouchAngle) then
			local nx,ny    = ssk.math2d.normalize(obj.touchVecX,obj.touchVecY) -- EFM necessary?
			obj.touchAngle = ssk.math2d.vector2Angle(nx,ny)
		end
	end
end
