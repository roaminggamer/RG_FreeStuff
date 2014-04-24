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

