-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Input Objects Factory
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
-- =============================================================

local inputs = {}

-- =======================
-- ====================== horizSnap
-- =======================
-- ==
--    ssk.inputs:createHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, group ) - Creates a horizontal input bar that snaps back to center when the 'stick' is released.
-- ==
function inputs:createHorizontalSnap( group, x, y, params) 
	params = params or {}
	group = group or display.currentStage
	x = x or centerX
	y = y or centerY
	
	local snapHeight 		= params.snapHeight or 40
	local snapWidth 		= params.snapWidth or 120
	local deadZoneWidth 	= params.deadZoneWidth or 20
	local stickSize 		= params.stickSize or 20
	local eventName 		= params.eventName or "onHorizSnap"

	local horizSnap  = display.newGroup()

	if( group ) then
		group:insert(horizSnap)
	end

	local horizSnapOutline  = ssk.display.rect( horizSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  w = snapWidth, h = snapHeight, myName = "ahorizSnap", isHitTestable = true }, nil, nil ) 
	horizSnapOutline.alpha = 0.50

	local horizSnapDeadZone  = ssk.display.rect( horizSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   w = deadZoneWidth, h = snapHeight-2, myName = "ahorizSnap" }, nil, nil ) 
	horizSnapDeadZone.alpha = 0.50

	local stick  = ssk.display.rect( horizSnap, x, y,
		{ fill = _DARKGREY_, 
		  w = stickSize, h = snapHeight-2, myName = "ahorizSnap" }, nil, nil ) 

	horizSnap.outline = horizSnapOutline
	horizSnap.deadZone = horizSnapDeadZone
	horizSnap.stick = stick
		
	function horizSnap:touch( event )
		local target  = event.target
		local eventID = event.id

		local vx = event.x - horizSnapOutline.x 
		local direction = "left"

		if(vx > 0) then
			direction = "right"
		end

		local magnitude = math.abs(vx)
		local maxMag = snapWidth/2
		local minMag = deadZoneWidth/2

		local percent = 0

		if(magnitude < minMag) then
			percent = 0
		elseif(magnitude > maxMag) then
			percent = 100
		else
			percent = round(magnitude/(maxMag-minMag),2) * 100
		end

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			stick.x = event.x

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.x = horizSnapOutline.x
				
				vx=0
				percent=0
				direction = "center"


			elseif(event.phase == "moved") then
				stick.x = event.x
				if(percent == 100 and direction == "left" ) then
					stick.x = horizSnapOutline.x - horizSnapOutline.width/2
				elseif(percent == 100 and direction == "right" ) then
					stick.x = horizSnapOutline.x + horizSnapOutline.width/2
				end
			end
		end
		

		--print( direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="on", direction=direction, percent=percent, snap = horizSnap })
		else
			post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="off", direction=direction, percent=percent, snap = horizSnap })
		end

		return true
	end

	horizSnapOutline:addEventListener( "touch", horizSnap )		

		
	return horizSnap
end

-- =======================
-- ====================== horizSnap
-- =======================
-- ==
--    ssk.inputs:createVirtualHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, group ) - Creates a horizontal input bar that snaps back to center when the 'stick' is released.
-- ==
function inputs:createVirtualHorizontalSnap( group, x, y, params) 
	params = params or {}
	group = group or display.currentStage
	x = x or centerX
	y = y or centerY
	
	local snapHeight 		= params.snapHeight or 40
	local snapWidth 		= params.snapWidth or 120
	local deadZoneWidth 	= params.deadZoneWidth or 20
	local stickSize 		= params.stickSize or 20
	local eventName 		= params.eventName or "onHorizSnap"
	local inputObj 			= params.inputObj

	local horizSnap  = display.newGroup()

	if( not inputObj ) then
		error("inputObj argument required for virtualJoystick")
	end

	if( group ) then
		group:insert(horizSnap)
	end

	local horizSnapOutline  = ssk.display.rect( horizSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  w = snapWidth, h = snapHeight, myName = "ahorizSnap", isHitTestable = true }, nil, nil ) 
	horizSnapOutline.alpha = 0.50

	local horizSnapDeadZone  = ssk.display.rect( horizSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   w = deadZoneWidth, h = snapHeight-2, myName = "ahorizSnap" }, nil, nil ) 
	horizSnapDeadZone.alpha = 0.50

	local stick  = ssk.display.rect( horizSnap, x, y,
		{ fill = _DARKGREY_, 
		  w = stickSize, h = snapHeight-2, myName = "ahorizSnap" }, nil, nil ) 

	horizSnap.isVisible = false

	horizSnap.outline = horizSnapOutline
	horizSnap.deadZone = horizSnapDeadZone
	horizSnap.stick = stick

		
	function horizSnap:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			
			local newX,newY = event.x,event.y

			if( (newX + horizSnapOutline.width/2) >= w) then
				newX = w - horizSnapOutline.width/2
			end

			if( (newX - horizSnapOutline.width/2) <= 0 ) then
				newX = horizSnapOutline.width/2
			end

			if( (newY + horizSnapOutline.height/2) >= h) then
				newY = h - horizSnapOutline.height/2
			end

			if( (newY - horizSnapOutline.height/2) <= 0) then
				newY = horizSnapOutline.height/2
			end

			horizSnapOutline.x,horizSnapOutline.y = newX, newY
			horizSnapDeadZone.x,horizSnapDeadZone.y = newX, newY
			stick.x,stick.y = event.x,newY

			horizSnap.isVisible = true
		end

		local vx = event.x - horizSnapOutline.x 
		local direction = "left"

		if(vx > 0) then
			direction = "right"
		end

		local magnitude = math.abs(vx)
		local maxMag = snapWidth/2
		local minMag = deadZoneWidth/2

		local percent = 0

		if(magnitude < minMag) then
			percent = 0
		elseif(magnitude > maxMag) then
			percent = 100
		else
			percent = round(magnitude/(maxMag-minMag),2) * 100
		end

		if(event.phase == "began") then

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.x = horizSnapOutline.x				
				vx=0
				percent=0
				direction = "center"

				horizSnap.isVisible = false

			elseif(event.phase == "moved") then
				stick.x = event.x
				if(percent == 100 and direction == "left" ) then
					stick.x = horizSnapOutline.x - horizSnapOutline.width/2
				elseif(percent == 100 and direction == "right" ) then
					stick.x = horizSnapOutline.x + horizSnapOutline.width/2
				end
			end
		end
		

		--print( direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="on", direction=direction, percent=percent, snap = horizSnap })
		else
			post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="off", direction=direction, percent=percent, snap = horizSnap })
		end

		return true
	end

	inputObj:addEventListener( "touch", horizSnap )		

	return horizSnap
end

return inputs