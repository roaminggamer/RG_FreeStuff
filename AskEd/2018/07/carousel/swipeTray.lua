-- =============================================================
-- Swipe Tray Module
-- =============================================================
--
-- =============================================================
local swipeTray = {}

local mAbs = math.abs
local getTimer = system.getTimer

local new

swipeTray.new = function( parentGroup, x, y, width, height, params )
	local parentGroup = parentGroup or display.getCurrentStage( )

	local params = params or {}

	local minScale  	= params.minScale or 0.5
	local scaleDist 	= params.scaleDist or width/2
	local centerDelay 	= params.centerDelay or 100
	local centerTime 	= params.centerTime or 500
	local snapDelay 	= params.snapDelay or 100
	local selectedWidth = params.selectedWidth or 30

	
	local tray = display.newContainer( parentGroup, width, height )
	tray.x = x
	tray.y = y
	tray.isValid = true
	tray.curSelection = 1
	local entries = {}
	tray.entries = entries
	local curX = 0

	local swipeObj = display.newImageRect( tray, "images/fillT.png", 25000, 25000 )

	tray.swipeObj = swipeObj

	tray.add = function( self, obj, offset )
		offset = offset or 0
		self:insert(obj)
		if(curX > 0 ) then
			obj.x = curX + offset
			obj._isSelected = false
		else
			obj.x = curX
			obj._isSelected = true
		end
		obj.y = 0

		curX = obj.x + obj.contentWidth

		entries[#tray.entries+1] = obj 
		--swipeObj:toFront()

		if( obj.onSelected ) then 
			obj:onSelected( { time = getTimer(), position = #tray.entries, isSelected = obj._isSelected } ) 
		end
	end

	tray.select = function( self, num, time, delay, easing )
		if( num > #entries ) then return end

		local dx = 0

		for i = 1, #entries do
			local entry = entries[i]	
			if ( i == num ) then
				dx = entry.x
			end
		end

		for i = 1, #entries do
			local entry = entries[i]	
			

			if( time ) then
				transition.to( entry, { delay = delay, x = entry.x - dx, time = time, transition = easing } )				
			else
				entry.x = entry.x - dx
			end

		end
			
	end

	tray.getCurSelection = function( self )
		for i = 1, #entries do
			local entry = entries[i]
			if( entry._isSelected == true ) then
				return i 
			end
		end
		return 0
	end

	tray.enterFrame = function( self )
		if( not self.isValid ) then return end
		if( not entries[1]) then return end
		if( not entries[1].x ) then return end
		for i = 1, #entries do
			local entry = entries[i]
			local ax = mAbs( entry.x )
			local scaleRemainder = 1 - minScale

			if(ax < scaleDist) then
				--print( ax, scaleDist, round(ax/scaleDist,2), round(1 - ax/scaleDist, 2)  )
			end

			if( entry.onSelected and ax <= selectedWidth and entry._isSelected == false ) then
				entry._isSelected = true
				entry:onSelected( { time = getTimer(), position = i, isSelected = true } )
			
			elseif( entry.onSelected and ax > selectedWidth and entry._isSelected == true ) then
				entry._isSelected = false
				entry:onSelected( { time = getTimer(), position = i, isSelected = false } )			
			end

			if( ax == 0 ) then
				--print(1)
				entry.xScale = 1
				entry.yScale = 1
			elseif( ax > scaleDist ) then
				--print(minScale)
				entry.xScale = minScale
				entry.yScale = minScale
			else
				local scale = minScale + (1 - ax/scaleDist) * scaleRemainder
				entry.xScale = scale
				entry.yScale = scale
				--print( round( scale, 2 ) )
			end
		end
	end
	Runtime:addEventListener( "enterFrame", tray )

	swipeObj.touch = function( self, event )
		local phase = event.phase
		local id	= event.id 

		if( phase == "began" ) then
			self.didMove = false
			self.startTime = event.time

			for i = 1, #entries do
				local entry = entries[i]	
				entry.x0 = entry.x
			end

			 display.getCurrentStage():setFocus( self, id )
			 self.isFocus = true

			 Runtime:dispatchEvent( { name = "startedTraySwipe" } )
	
		elseif( self.isFocus == true ) then
			if( phase == "moved" and self.startTime ~= nil) then

				self.didMove = true

				local dx = event.x - event.xStart
				--print(dx)

				for i = 1, #entries do
					local entry = entries[i]	
					entry.x = entry.x0 + dx
				end
			
			else
				display.getCurrentStage():setFocus( self, nil )
			 	self.isFocus = false
				if( self.didMove and self.startTime ~= nil) then

					self.timer = function()
						local ax = 1000000
						local dx = 1000000
						local closestEntry = 1
						
						for i = 1, #entries do
							local entry = entries[i]	

							if(mAbs(entry.x) < ax) then
								closestEntry = i						
								dx = entry.x
								ax = mAbs(dx)
							end
						end

						for i = 1, #entries do
							local entry = entries[i]
							transition.cancel( entry )	
							transition.to( entry, { x = entry.x - dx, time = centerTime, transition = easing.linear })	
						end
					end

					timer.performWithDelay( centerDelay, self )
				
					local dt = event.time - self.startTime
					local moveDist = 1000 * (event.xStart-event.x)/dt
					local moveTime = centerDelay - snapDelay
					moveDist = moveDist * moveTime / 1000

					for i = 1, #entries do
						local entry = entries[i]	
						if( moveTime > 0 ) then
							transition.to( entry, { delay = 0, x = entry.x - moveDist, time = moveTime, transition = easing.linear })						
						end
					end

				end

				for i = 1, #entries do
					local entry = entries[i]	
					entry.x0 = nil				
				end
				self.startTime = nil

				Runtime:dispatchEvent( { name = "endedTraySwipe" } )
			end
		end
		return false
	end
	swipeObj:addEventListener( "touch" )

	swipeObj:toBack()

	tray.destroy = function( self )
		self.isValid = nil
		Runtime:removeEventListener( "enterFrame", self )

		if( self.swipeObj and self.swipeObj.touch ) then
			self.swipeObj:removeEventListener( "touch" )
			self.swipeObj.touch = nil
			self.swipeObj = nil
		end
	end

	return tray
end

return swipeTray