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

-- Create the inputs class if it does not yet exist
--
local inputs
if( not _G.ssk.inputs ) then
	_G.ssk.inputs = {}
end
inputs = _G.ssk.inputs

-- EFM Convert all of these to use parameters
-- EFM Add skinning

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

