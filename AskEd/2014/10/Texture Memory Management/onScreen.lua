-- Tip: You can make these two functions more sophisticated by checking 
-- to see if the object and its parent(s) are visible or alpha'd out
-- If they are not visible or if alpha == 0, you can simply de-fill the object.
--

local onScreen = {}

--
-- Check Every Frame -- Uses 'enterFrame' Runtime event
--
onScreen.frameFiller = function( obj, fill, fill2, buffer, baseDirectory1, baseDirectory2 )

	-- Set some reasonable defaults
	--
	baseDirectory1 = baseDirectory1 or system.ResourceDirectory
	baseDirectory2 = baseDirectory2 or system.ResourceDirectory

	-- Set the buffer or calculate a resonable one
	local ld = display.contentHeight
	if( display.contentWidth > ld ) then
		ld = display.contentWidth
	end
	buffer = (buffer or ld/2)

	-- Start off assuming object is NOT filled
	obj._filled = false 

	local enterFrame
	enterFrame = function()
		if( obj == nil or obj.removeSelf == nil or obj.parent == nil ) then
			Runtime:removeEventListener( "enterFrame", enterFrame )
			return 
		end

		local xMax = w + unusedWidth/2 + buffer
		local xMin = -unusedWidth/2 - buffer
		local yMax = h + unusedWidth/2 + buffer
		local yMin = -unusedWidth/2 - buffer
		local x,y = obj.parent:localToContent( obj.x, obj.y )
		local onScreen = true 

		if( x > xMax ) then onScreen = false end
		if( x < xMin ) then onScreen = false end
		if( y > yMax ) then onScreen = false end
		if( y < yMin ) then onScreen = false end

		if( onScreen ) then
			if( obj._filled ) then return end
			obj._filled = true
			obj.fill = { type = "image",  baseDir = baseDirectory1, filename = fill }
		else
			if( not obj._filled ) then return end
			obj._filled = false
			obj.fill = { type = "image",  baseDir = baseDirectory2, filename = fill2 }
		end

	end
	Runtime:addEventListener("enterFrame",enterFrame)
end


--
-- Check Every So Often -- Uses timer (performWithDelay) event
--
onScreen.delayedFiller = function( obj, fill, fill2, buffer, period, baseDirectory1, baseDirectory2 )

	-- Set some reasonable defaults
	--
	baseDirectory1 = baseDirectory1 or system.ResourceDirectory
	baseDirectory2 = baseDirectory2 or system.ResourceDirectory

	-- Set the buffer or calculate a resonable one
	local ld = display.contentHeight
	if( display.contentWidth > ld ) then
		ld = display.contentWidth
	end
	buffer = (buffer or ld/2)

	-- Start off assuming object is NOT filled
	obj._filled = false 

	local onTimer
	local timerHandle
	onTimer = function()
		if( obj == nil or obj.removeSelf == nil or obj.parent == nil ) then
			timer.cancel( timerHandle )
			return 
		end

		local xMax = w + unusedWidth/2 + buffer
		local xMin = -unusedWidth/2 - buffer
		local yMax = h + unusedWidth/2 + buffer
		local yMin = -unusedWidth/2 - buffer
		local x,y = obj.parent:localToContent( obj.x, obj.y )
		local onScreen = true 

		if( x > xMax ) then onScreen = false end
		if( x < xMin ) then onScreen = false end
		if( y > yMax ) then onScreen = false end
		if( y < yMin ) then onScreen = false end

		if( onScreen ) then
			if( obj._filled ) then return end
			obj._filled = true
			obj.fill = { type = "image",  baseDir = baseDirectory1, filename = fill }
		else
			if( not obj._filled ) then return end
			obj._filled = false
			obj.fill = { type = "image",  baseDir = baseDirectory2, filename = fill2 }
		end

	end
	timerHandle = timer.performWithDelay( period, onTimer, -1 )
end


return onScreen