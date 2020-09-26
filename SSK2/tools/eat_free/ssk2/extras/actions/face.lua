-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Actions Library - Facing Functions
-- =============================================================
local function face( obj, params )
	local target = params.target or obj._target 
	local angle  = params.angle
	local doPause = params.pause

	-- Once started, face must be called every frame, but
	-- you can pause the face action any time, to avoid 
	-- the subsequent heavy calculations.
	--
	if(doPause) then 
		obj.__last_face_time = system.getTimer()
		return
	end

	-- Face target 'immediately'
	if( params.rate == nil ) then
		if( angle == nil ) then
			local vec = {}
			vec.x = target.x - obj.x
			vec.y = target.y - obj.y
			angle = math.ceil(math.atan2( (vec.y), (vec.x) ) * 180 / math.pi) + 90
		end
		obj.rotation = angle
	
	-- Face target at rate (degrees per second)
	else
		local curTime = system.getTimer()
		if( not obj.__last_face_time ) then
			obj.__last_face_time = curTime
		end
		local dt = curTime - obj.__last_face_time
		obj.__last_face_time = curTime
		
		local dps = params.rate or 180
		local rate = params.rate * dt / 1000	

		local vec = {}
		if( target ) then
			vec.x = target.x - obj.x
			vec.y = target.y - obj.y
		else
			vec.x = 0
			vec.y = 0
		end			

		local targetAngle = angle or math.ceil(math.atan2( (vec.y), (vec.x) ) * 180 / math.pi) + 90

		local deltaAngle = math.floor((targetAngle - obj.rotation) + 0.5)
		deltaAngle =  (deltaAngle + 180) % 360 - 180

		if( math.abs( deltaAngle ) <= rate ) then
			obj.rotation = targetAngle
		elseif( deltaAngle > 0 ) then
			obj.rotation = obj.rotation + rate
		else
			obj.rotation = obj.rotation - rate
		end

		if( obj.rotation < 0 ) then obj.rotation = obj.rotation + 360 end
		if( obj.rotation >= 360 ) then obj.rotation = obj.rotation - 360 end		
	end
end

_G.ssk.actions = _G.ssk.actions or {}
_G.ssk.actions.face = face
