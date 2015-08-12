-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
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
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================
--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print


local inputs

if( not _G.ssk.inputs ) then
	_G.ssk.inputs = {}
end

inputs = _G.ssk.inputs

-- EFM Convert all of these to use parameters
-- EFM Add skinning

-- =======================
-- ====================== Joystick
-- =======================
-- ==
--    ssk.inputs:createJoystick( x, y, outerRadius, deadZoneRadius, stickRadius, eventName, group ) 0 Creates a simple joystick input device on the screen.
-- ==
function inputs:createJoystick( x, y, outerRadius, deadZoneRadius, stickRadius, eventName, group )

	local joystick  = display.newGroup()

	local eventName = eventName or "joystickEvent"

	if( group ) then
		group:insert(joystick)
	end
	

	local outerRing  = ssk.display.circle( joystick, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 4, 
		  radius = outerRadius, myName = "aJoystick" }, nil, nil ) 
	outerRing.alpha = 0.50
	
	local innerRing  = ssk.display.circle( joystick, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  radius = deadZoneRadius, myName = "aJoystick" }, nil, nil ) 
	innerRing.alpha = 0.50

	local stick  = ssk.display.circle( joystick, x, y,
		{ fill = _GREY_, stroke = _GREY_, strokeWidth = 0, 
		  radius = stickRadius, myName = "aJoystick" }, nil, nil ) 

	local radiusDelta = outerRadius - deadZoneRadius
	
	function joystick:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			stick.x,stick.y = event.x, event.y
		end

		local vx,vy = ssk.math2d.sub(outerRing.x, outerRing.y, event.x, event.y)
		local nx,ny = ssk.math2d.normalize(vx,vy)

		if(vx == 0 ) then
			nx = 0
		else
			nx = round(nx,4)
		end

		if(vy == 0 ) then
			ny = 0
		else
			ny = round(ny,4)	
		end

		local angle 

		if(nx == 0 and ny == 0 ) then
			angle = 0
		else
			angle = ssk.math2d.vector2Angle(vx,vy)
		end

		if(angle < 0) then angle = angle + 360 end

		local vLen  = ssk.math2d.length(vx,vy)
		
		local iLen  = vLen - deadZoneRadius

		local percent = 0

		if(event.phase == "began") then
			if(iLen < 0) then
				percent = 0
			elseif(iLen > radiusDelta) then
				percent = 1
			else
				percent = iLen/radiusDelta
			end

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.x,stick.y = outerRing.x, outerRing.y

				angle = 0
				vx = 0
				vy = 0
				nx = 0
				ny = 0
				percent = 0

			elseif(event.phase == "moved") then
				if(vLen <= outerRadius ) then
					stick.x,stick.y = event.x, event.y
				else
					local dx,dy = ssk.math2d.angle2Vector(angle)
					dx,dy = ssk.math2d.scale(dx,dy,outerRadius)
					stick.x,stick.y = ssk.math2d.add( outerRing.x, outerRing.y, dx,dy)
				end
				if(iLen < 0) then
					percent = 0
				elseif(iLen > radiusDelta) then
					percent = 100
				else
					percent = round(iLen/radiusDelta,4) * 100
				end
			end
		end
		
		dprint(2, round(angle,2), round(nx,2), round(ny,2), round(percent,2))
		if(percent == 0 ) then
			ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "off" })
		else
			ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "on" })
		end
		return true
	end

	outerRing:addEventListener( "touch", joystick )		


	-- ==
	--    joystick:destroy( event ) - Destroy joystick parts and clean up event listeners
	-- ==

	function joystick:destroy( event )
--[[ EFM remove me?
		outerRing:removeEventListener( "touch", joystick )		
		stick:removeSelf()
		innerRing:removeSelf()
		outerRing:removeSelf()
--]]
	end
	return joystick
end

-- =======================
-- ====================== Virtual Joystick
-- =======================
-- ==
--    ssk.inputs:createVirtualJoystick( x, y, outerRadius, deadZoneRadius, stickRadius, eventName, inputObj, group ) - Creates a simple joystick input device on the screen.  Unlike the one created with createJoystick, the touch input source is an external objects.  
-- ==
function inputs:createVirtualJoystick( x, y, outerRadius, deadZoneRadius, stickRadius, eventName, inputObj, group )

	local virtualJoystick  = display.newGroup()

	local eventName = eventName or "joystickEvent"

	if( not inputObj ) then
		error("inputObj argument required for virtualJoystick")
	end
	
	if( group ) then
		group:insert(virtualJoystick)
	end

	local outerRing  = ssk.display.circle( virtualJoystick, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 4, 
		  radius = outerRadius, myName = "aJoystick" }, nil, nil ) 
	outerRing.alpha = 0.50
	
	local innerRing  = ssk.display.circle( virtualJoystick, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  radius = deadZoneRadius, myName = "aJoystick" }, nil, nil ) 

	local stick  = ssk.display.circle( virtualJoystick, x, y,
		{ fill = _GREY_, stroke = _GREY_, strokeWidth = 0, 
		  radius = stickRadius, myName = "aJoystick" }, nil, nil ) 
	innerRing.alpha = 0.50

	local radiusDelta = outerRadius - deadZoneRadius

	virtualJoystick.isVisible = false

	function virtualJoystick:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true

			local newX,newY = event.x,event.y

			if( (newX + outerRing.width/2) >= w) then
				newX = w - outerRing.width/2
			end

			if( (newX - outerRing.width/2) <= 0 ) then
				newX = outerRing.width/2
			end

			if( (newY + outerRing.height/2) >= h) then
				newY = h - outerRing.height/2
			end

			if( (newY - outerRing.height/2) <= 0) then
				newY = outerRing.height/2
			end

			outerRing.x,outerRing.y = newX, newY
			innerRing.x,innerRing.y = newX, newY
			stick.x,stick.y = event.x,event.y
			virtualJoystick.isVisible = true
		end

		local vx,vy = ssk.math2d.sub(outerRing.x, outerRing.y, event.x, event.y)
		local nx,ny = ssk.math2d.normalize(vx,vy)

		if(vx == 0 ) then
			nx = 0
		else
			nx = round(nx,4)
		end

		if(vy == 0 ) then
			ny = 0
		else
			ny = round(ny,4)	
		end

		local angle 

		if(nx == 0 and ny == 0 ) then
			angle = 0
		else
			angle = ssk.math2d.vector2Angle(vx,vy)
		end
		
		if(angle < 0) then angle = angle + 360 end

		local vLen  = ssk.math2d.length(vx,vy)
		
		local iLen  = vLen - deadZoneRadius

		local percent = 0

		if(event.phase == "began") then
			if(iLen < 0) then
				percent = 0
			elseif(iLen > radiusDelta) then
				percent = 1
			else
				percent = iLen/radiusDelta
			end

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.x,stick.y = outerRing.x, outerRing.y

				angle = 0
				vx = 0
				vy = 0
				nx = 0
				ny = 0
				percent = 0

				virtualJoystick.isVisible = false

			elseif(event.phase == "moved") then
				if(vLen <= outerRadius ) then
					stick.x,stick.y = event.x, event.y
				else
					local dx,dy = ssk.math2d.angle2Vector(angle)
					dx,dy = ssk.math2d.scale(dx,dy,outerRadius)
					stick.x,stick.y = ssk.math2d.add( outerRing.x, outerRing.y, dx,dy)
				end
				if(iLen < 0) then
					percent = 0
				elseif(iLen > radiusDelta) then
					percent = 100
				else
					percent = round(iLen/radiusDelta,4) * 100
				end
			end
		end
		
		dprint(2, round(angle,2), round(nx,2), round(ny,2), round(percent,2))
		if(percent == 0 ) then
			ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "off" })
		else
			ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "on" })
		end
		return true
	end


	inputObj:addEventListener( "touch", virtualJoystick )			

	-- ==
	--    func() - what it does
	-- ==
	function virtualJoystick:destroy( event )
--[[ EFM remove me?
		inputObj:removeEventListener( "touch", virtualJoystick )		
		stick:removeSelf()
		innerRing:removeSelf()
		outerRing:removeSelf()
--]]	
	end
	return virtualJoystick
end

-- =======================
-- ====================== horizSnap
-- =======================
-- ==
--    ssk.inputs:createHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, group ) - Creates a horizontal input bar that snaps back to center when the 'stick' is released.
-- ==
function inputs:createHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, group )

	local horizSnap  = display.newGroup()

	local eventName = eventName or "horizSnapEvent"

	if( group ) then
		group:insert(horizSnap)
	end

	local horizSnapOutline  = ssk.display.rect( horizSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  w = snapWidth, h = snapHeight, myName = "ahorizSnap" }, nil, nil ) 
	horizSnapOutline.alpha = 0.50

	local horizSnapDeadZone  = ssk.display.rect( horizSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   w = deadZoneWidth, h = snapHeight-2, myName = "ahorizSnap" }, nil, nil ) 
	horizSnapDeadZone.alpha = 0.50

	local stick  = ssk.display.rect( horizSnap, x, y,
		{ fill = _DARKGREY_, 
		  w = stickSize, h = snapHeight-2, myName = "ahorizSnap" }, nil, nil ) 
		
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
		

		dprint(2, direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			ssk.gem:post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="on", direction=direction, percent=percent })
		else
			ssk.gem:post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="off", direction=direction, percent=percent })
		end

		return true
	end

	horizSnapOutline:addEventListener( "touch", horizSnap )		


	-- ==
	--    func() - what it does
	-- ==
	function horizSnap:destroy( event )
--[[ EFM remove me?
		horizSnapOutline:removeEventListener( "touch", horizSnap )		
		stick:removeSelf()
		horizSnapDeadZone:removeSelf()
		horizSnapOutline:removeSelf()
--]]
	end
		
	return horizSnap
end

-- =======================
-- ====================== virtualHorizSnap
-- =======================
-- ==
--    ssk.inputs:createVirtualHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, group ) - Creates a horizontal input bar that snaps back to center when the 'stick' is released.
-- ==
function inputs:createVirtualHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, inputObj, group )

	local virtualhorizSnap  = display.newGroup()

	local eventName = eventName or "horizSnapEvent"

	if( not inputObj ) then
		error("inputObj argument required for virtualJoystick")
	end

	if( group ) then
		group:insert(virtualhorizSnap)
	end

	local horizSnapOutline  = ssk.display.rect( virtualhorizSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  w = snapWidth, h = snapHeight, myName = "avirtualhorizSnap" }, nil, nil ) 
	horizSnapOutline.alpha = 0.50

	local horizSnapDeadZone  = ssk.display.rect( virtualhorizSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   w = deadZoneWidth, h = snapHeight-2, myName = "avirtualhorizSnap" }, nil, nil ) 
	horizSnapDeadZone.alpha = 0.50

	local stick  = ssk.display.rect( virtualhorizSnap, x, y,
		{ fill = _DARKGREY_, 
		  w = stickSize, h = snapHeight-2, myName = "avirtualhorizSnap" }, nil, nil ) 

	virtualhorizSnap.isVisible = false
		
	function virtualhorizSnap:touch( event )
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

			virtualhorizSnap.isVisible = true
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

				virtualhorizSnap.isVisible = false

			elseif(event.phase == "moved") then
				stick.x = event.x
				if(percent == 100 and direction == "left" ) then
					stick.x = horizSnapOutline.x - horizSnapOutline.width/2
				elseif(percent == 100 and direction == "right" ) then
					stick.x = horizSnapOutline.x + horizSnapOutline.width/2
				end
			end
		end
		

		dprint(2, direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			ssk.gem:post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="on", direction=direction, percent=percent })
		else
			ssk.gem:post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="off", direction=direction, percent=percent })
		end

		return true
	end

	inputObj:addEventListener( "touch", virtualhorizSnap )		


	-- ==
	--    func() - what it does
	-- ==
	function virtualhorizSnap:destroy( event )
--[[ EFM remove me?
		inputObj:removeEventListener( "touch", virtualhorizSnap )		
		stick:removeSelf()
		horizSnapDeadZone:removeSelf()
		horizSnapOutline:removeSelf()
--]]
	end
		
	return virtualhorizSnap
end

-- =======================
-- ====================== vertSnap
-- =======================
-- ==
--    ssk.inputs:createVerticalSnap( x, y, snapWidth, snapHeight, deadZoneWidth, stickSize, eventName, group ) - Creates a vertical input bar that snaps back to center when the 'stick' is released.
-- ==
function inputs:createVerticalSnap( x, y, snapWidth, snapHeight, deadZoneHeight, stickSize, eventName, group )

	local vertSnap  = display.newGroup()

	local eventName = eventName or "vertSnapEvent"

	if( group ) then
		group:insert(vertSnap)
	end

	local vertSnapOutline  = ssk.display.rect( vertSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  w = snapWidth, h = snapHeight, myName = "avertSnap" }, nil, nil ) 
	vertSnapOutline.alpha = 0.50

	local vertSnapDeadZone  = ssk.display.rect( vertSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   w = snapWidth-2, h = deadZoneHeight, myName = "avertSnap" }, nil, nil ) 
	vertSnapDeadZone.alpha = 0.50

	local stick  = ssk.display.rect( vertSnap, x, y,
		{ fill = _DARKGREY_, 
		  w = snapWidth, h = stickSize, myName = "avertSnap" }, nil, nil ) 

	function vertSnap:touch( event )
		local target  = event.target
		local eventID = event.id

		local vy = event.y - vertSnapOutline.y 
		local direction = "up"

		if(vy > 0) then
			direction = "down"
		end

		local magnitude = math.abs(vy)
		local maxMag = snapHeight/2
		local minMag = deadZoneHeight/2

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
			stick.y = event.y

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.y = vertSnapOutline.y
				
				vy=0
				percent=0
				direction = "center"


			elseif(event.phase == "moved") then
				stick.y = event.y
				if(percent == 100 and direction == "up" ) then
					stick.y = vertSnapOutline.y - vertSnapOutline.height/2
				elseif(percent == 100 and direction == "down" ) then
					stick.y = vertSnapOutline.y + vertSnapOutline.height/2
				end
			end
		end
		

		dprint(2, direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			ssk.gem:post(eventName, {phase = event.phase, vx=0, vy=vy, nx=0, ny=0, state="on", direction=direction, percent=percent })
		else
			ssk.gem:post(eventName, {phase = event.phase, vx=0, vy=vy, nx=0, ny=0, state="off", direction=direction, percent=percent })
		end

		return true
	end

	vertSnapOutline:addEventListener( "touch", vertSnap )		


	-- ==
	--    func() - what it does
	-- ==
	function vertSnap:destroy( event )
--[[ EFM remove me?
		vertSnapOutline:removeEventListener( "touch", vertSnap )		
		stick:removeSelf()
		vertSnapDeadZone:removeSelf()
		vertSnapOutline:removeSelf()
--]]
	end

	return vertSnap
end


-- =======================
-- ====================== virtualVertSnap
-- =======================

-- ==
--    ssk.inputs:createVirtualVerticalSnap() - reates a vertical input bar that snaps back to center when the 'stick' is released.
-- ==
function inputs:createVirtualVerticalSnap( x, y, snapWidth, snapHeight, deadZoneHeight, stickSize, eventName, inputObj, group )

	local virtualVertSnap  = display.newGroup()

	local eventName = eventName or "vertSnapEvent"

	if( not inputObj ) then
		error("inputObj argument required for virtualJoystick")
	end

	if( group ) then
		group:insert(virtualVertSnap)
	end

	local vertSnapOutline  = ssk.display.rect( virtualVertSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  w = snapWidth, h = snapHeight, myName = "avertSnap" }, nil, nil ) 
	vertSnapOutline.alpha = 0.50

	local vertSnapDeadZone  = ssk.display.rect( virtualVertSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   w = snapWidth-2, h = deadZoneHeight, myName = "avertSnap" }, nil, nil ) 
	vertSnapDeadZone.alpha = 0.50

	local stick  = ssk.display.rect( virtualVertSnap, x, y,
		{ fill = _DARKGREY_, 
		  w = snapWidth, h = stickSize, myName = "avertSnap" }, nil, nil ) 

	virtualVertSnap.isVisible = false

	function virtualVertSnap:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			
			local newX,newY = event.x,event.y

			if( (newX + vertSnapOutline.width/2) >= w) then
				newX = w - vertSnapOutline.width/2
			end

			if( (newX - vertSnapOutline.width/2) <= 0 ) then
				newX = vertSnapOutline.width/2
			end

			if( (newY + vertSnapOutline.height/2) >= h) then
				newY = h - vertSnapOutline.height/2
			end

			if( (newY - vertSnapOutline.height/2) <= 0) then
				newY = vertSnapOutline.height/2
			end

			vertSnapOutline.x,vertSnapOutline.y = newX, newY
			vertSnapDeadZone.x,vertSnapDeadZone.y = newX, newY
			stick.x,stick.y = newX, event.y

			virtualVertSnap.isVisible = true
		end

		local vy = event.y - vertSnapOutline.y 
		local direction = "up"

		if(vy > 0) then
			direction = "down"
		end

		local magnitude = math.abs(vy)
		local maxMag = snapHeight/2
		local minMag = deadZoneHeight/2

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
				stick.y = vertSnapOutline.y

				vy=0
				percent=0
				direction = "center"

				virtualVertSnap.isVisible = false

			elseif(event.phase == "moved") then
				stick.y = event.y
				if(percent == 100 and direction == "up" ) then
					stick.y = vertSnapOutline.y - vertSnapOutline.height/2
				elseif(percent == 100 and direction == "down" ) then
					stick.y = vertSnapOutline.y + vertSnapOutline.height/2
				end
			end
		end		

		dprint(2, direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			ssk.gem:post(eventName, {phase = event.phase, vx=0, vy=vy, nx=0, ny=0, state="on", direction=direction, percent=percent })
		else
			ssk.gem:post(eventName, {phase = event.phase, vx=0, vy=vy, nx=0, ny=0, state="off", direction=direction, percent=percent })
		end

		return true
	end

	inputObj:addEventListener( "touch", virtualVertSnap )		

	-- ==
	--    func() - what it does
	-- ==
	function virtualVertSnap:destroy( event )
--[[ EFM remove me?
		inputObj:removeEventListener( "touch", virtualVertSnap )		
		stick:removeSelf()
		vertSnapDeadZone:removeSelf()
		vertSnapOutline:removeSelf()
--]]
	end

	return virtualVertSnap
end

