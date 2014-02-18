-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Prototyping Objects
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

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

-- Create the display class if it does not yet exist
--
local displayExtended
if( not _G.ssk.display ) then
	_G.ssk.display = {}
end
displayExtended = _G.ssk.display

-- ==
--    func() - what it does
-- ==
function displayExtended.line( group, startX, startY, endX, endY, visualParams )
	local group = group or display.currentStage

	local visualParams = visualParams
	if( not visualParams ) then visualParams = {} end

	local theLine = display.newGroup()
	group:insert( theLine )

	local vx,vy    = ssk.math2d.sub(startX, startY, endX, endY)
	local vLen     = ssk.math2d.length(vx,vy)
	local nx,ny    = ssk.math2d.normalize(vx,vy)
	local cx,cy    = ssk.math2d.scale(nx,ny, vLen/2)
	      cx,cy    = ssk.math2d.add(startX, startY, cx, cy)
	local rotation = ssk.math2d.vector2Angle(vx,vy)	

	theLine.vx = vx
	theLine.vy = vy
	theLine.cx = cx
	theLine.cy = cy
	theLine.angle = rotation
	
	local width = visualParams.w or visualParams.strokeWidth or 1 
	local color = visualParams.color or _WHITE_
	local radius = visualParams.radius or 1
	local strokeColor = visualParams.stroke or _WHITE_
	local strokeWidth = visualParams.strokeWidth or 0
	local dashLen = visualParams.dashLen or 1
	local gapLen = visualParams.gapLen or 0
	
	if(not visualParams.radius and visualParams.w) then
		radius = visualParams.w/2 or 1
	end

	theLine.style = visualParams.style or "solid"

	if(theLine.style == "solid") then
		local aDash = display.newLine( startX, startY, endX, endY )
		theLine:insert(aDash)
		aDash.strokeWidth = width
		aDash:setStrokeColor( unpack(color) )

	elseif(theLine.style == "dashed") then
		local dash_dx,dash_dy = ssk.math2d.normalize(vx, vy)
		local gap_dx,gap_dy   = dash_dx,dash_dy
	
		dash_dx,dash_dy       = ssk.math2d.scale(dash_dx,dash_dy, dashLen)
		gap_dx,gap_dy         = ssk.math2d.scale(gap_dx,gap_dy, gapLen)

		local lineLen = 0
		local curX, curY = startX,startY
		local newX, newY = 0,0
		
		while( lineLen < vLen ) do
			-- Attempt to draw a dash
			lineLen = lineLen + dashLen
			if( lineLen < vLen ) then
				newX,newY = ssk.math2d.add( curX, curY, dash_dx, dash_dy )
				local aDash = display.newLine( curX, curY, newX, newY )
				theLine:insert(aDash)
				aDash.strokeWidth = width
				aDash:setStrokeColor( unpack(color) )
				curX,curY = newX,newY
			end
			-- Add a gap
			lineLen = lineLen + gapLen
			curX,curY = ssk.math2d.add( curX, curY, gap_dx, gap_dy )
		end

	elseif(theLine.style == "dotted") then
		local dot_dx,dot_dy = ssk.math2d.normalize(vx, vy)
		local gap_dx,gap_dy   = dot_dx,dot_dy
	
		local lineLen = 0
		local curX, curY = startX,startY
		local newX, newY = 0,0

		if(radius<1) then radius = 1 end

		dot_dx,dot_dy       = ssk.math2d.scale(dot_dx,dot_dy, radius*2)
		gap_dx,gap_dy         = ssk.math2d.scale(gap_dx,gap_dy, gapLen)

		while( lineLen < vLen ) do
			-- Attempt to draw a dot
			lineLen = lineLen + radius*2
			if( lineLen < vLen ) then
				newX,newY = ssk.math2d.add( curX, curY, dot_dx, dot_dy )
				local adot = display.newCircle( theLine, curX, curY, radius )
				adot:setFillColor( unpack(color) )
				adot:setStrokeColor( unpack(strokeColor) ) 
				adot.strokeWidth = strokeWidth
				curX,curY = newX,newY
			end
			-- Add a gap
			lineLen = lineLen + gapLen
			curX,curY = ssk.math2d.add( curX, curY, gap_dx, gap_dy )
		end

	elseif(theLine.style == "arrows") then
		local dash_dx,dash_dy = ssk.math2d.normalize(vx, vy)
		local gap_dx,gap_dy   = dash_dx,dash_dy
	
		dash_dx,dash_dy       = ssk.math2d.scale(dash_dx,dash_dy, dashLen)
		gap_dx,gap_dy         = ssk.math2d.scale(gap_dx,gap_dy, gapLen)

		local lineLen = 0
		local curX, curY = startX,startY
		local newX, newY = 0,0

		while( lineLen < vLen ) do
			-- Attempt to draw a dash
			lineLen = lineLen + dashLen
			if( lineLen < vLen ) then
				newX,newY = ssk.math2d.add( curX, curY, dash_dx, dash_dy )
				local aDash = displayExtended.arrow( group, curX, curY, newX,newY, visualParams )
				theLine:insert(aDash)
			
				curX,curY = newX,newY

			end

			-- Add a gap
			lineLen = lineLen + gapLen
			curX,curY = ssk.math2d.add( curX, curY, gap_dx, gap_dy )
		end
	end

	return theLine
end

-- ==
--    func() - what it does
-- ==
function displayExtended.line2( group, startX, startY, angle, length, visualParams )
	local group = group or display.currentStage
	local endX, endY = ssk.math2d.angle2Vector( angle )
	endX, endY = ssk.math2d.scale( endX, endY, length )
	endX, endY = ssk.math2d.add(startX, startY, endX, endY)
	return displayExtended.line( group, startX, startY, endX, endY, visualParams )
end


--EFM add ability to append new segments
--EFM add arrowcapped style (single end arrowhead)
-- ==
--    func() - what it does
-- ==
function displayExtended.segmentedLine( group, points, visualParams )
	local group = group or display.currentStage
	local theLine = display.newGroup()
	group:insert( theLine )

	local visualParams = visualParams
	if( not visualParams ) then visualParams = {} end

	local width = visualParams.w or visualParams.strokeWidth or 1 
	local color = visualParams.color or _WHITE_
	local radius = visualParams.radius or 1
	local strokeColor = visualParams.stroke or _WHITE_
	local strokeWidth = visualParams.strokeWidth or 0

	if(not visualParams.radius and visualParams.w) then
		radius = visualParams.w/2 or 1
	end

	theLine.style = visualParams.style or "solid"

	if(theLine.style == "solid") then
	
		if( #points > 1 ) then
			local tmpLine = nil
			for i = 2, #points do
				if( i == 2) then
					local a = points:get(1)
					local b = points:get(2)
					tmpLine = display.newLine( a.x, a.y, b.x, b.y )
				else
					local a = points:get(i)
					tmpLine:append( a.x, a.y )
				end
			end
			theLine:insert(tmpLine)
			tmpLine.strokeWidth = width
			tmpLine:setStrokeColor( unpack(color) )
		end


	elseif(theLine.style == "dashed") then 
	
		local tmpLine = nil
		for i = 2, #points do
			if( i % 2 == 0) then
				local a = points:get(i-1)
				local b = points:get(i)
				tmpLine = display.newLine( a.x, a.y, b.x, b.y )

				theLine:insert(tmpLine)
				tmpLine.strokeWidth = width
				tmpLine:setStrokeColor( unpack(color) )
			end
		end

	elseif(theLine.style == "dotted") then

		for i = 1, #points do
			local a = points:get(i)
			local tmpDot = display.newCircle( theLine, a.x, a.y, radius )

			tmpDot:setFillColor( unpack(color) )
			tmpDot:setStrokeColor( unpack(strokeColor) ) 
			tmpDot.strokeWidth = strokeWidth
		end


	elseif(theLine.style == "arrowheads") then  --EFM BUG arrowheads are offset! 
		local size = visualParams.size or 10

		visualParams.rotation = 0

		for i = 1, #points do			
			local a = points:get(i)

			if(#points >= i+1) then
				local b = points:get(i+1)

				local nVec = ssk.math2d.sub(a,b)
				nVec = ssk.math2d.normalize( nVec )
				local angle = ssk.math2d.vector2Angle(nVec)
				visualParams.rotation = angle
			end
			
			--visualParams.referencePoint = display.BottomCenterReferencePoint --EFM
			local tmpArrowHead = displayExtended.arrowhead( theLine, a.x, a.y, size, size, visualParams )
		end
	end


	return theLine
end

