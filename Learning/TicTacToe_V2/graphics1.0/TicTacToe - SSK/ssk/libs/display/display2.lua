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

local displayBuilders

if( not _G.ssk.display ) then
	_G.ssk.display = {}
end

displayBuilders = _G.ssk.display

-- ==
--    func() - what it does
-- ==
function displayBuilders.arrowhead( group, x, y, width, height, visualParams )
	local group      = group or display.currentStage
	local width      = width or 40
	local height     = height or 40
	local halfWidth  = width/2
	local halfHeight = height/2

	local visualParams = visualParams
	if( not visualParams ) then visualParams = {} end

	local head = display.newLine( x,            y + halfHeight, 
	                              x - halfWidth, y + halfHeight )

	head:append( x            , y - halfHeight, 
                 x + halfWidth, y + halfHeight,
				 x,            y + halfHeight )
	
	head.w = visualParams.w or 1
	
	if(visualParams.color) then
		head:setColor( unpack(visualParams.color))
	end

	if( visualParams.referencePoint ) then
		head:setReferencePoint( visualParams.referencePoint )
	end

	if(visualParams.rotation) then
		head.x = 0
		head.y = 0
		head.rotation = visualParams.rotation
		head.x, head.y = x,y
	end

	group:insert( head )

	return head
end

-- ==
--    func() - what it does
-- ==
function displayBuilders.arrow( group, startX, startY, endX, endY, visualParams )
	local group = group or display.currentStage
	local arrow = display.newGroup()

	local visualParams = visualParams
	if( not visualParams ) then visualParams = {} end

	group:insert(arrow)

	local vx,vy  = ssk.math2d.sub(startX, startY, endX, endY)

	local vLen  = ssk.math2d.length(vx,vy) 

	local nx,ny = ssk.math2d.normalize(vx,vy)

	local cx,cy = ssk.math2d.scale(nx,ny, vLen/2)
	cx,cy = ssk.math2d.add(startX, startY, cx, cy)
	
	local rotation = ssk.math2d.vector2Angle(vx,vy)	
	
	local arrowLine = display.newLine( startX, startY, endX, endY )
	
	local width = visualParams.w or 1
	local color = visualParams.color  or _WHITE_
	local headHeight = visualParams.headHeight  or 10
	local headWidth = visualParams.headWidth  or 10	

	arrowLine:setColor( unpack(color))

	arrowLine.width = width

	local arrowhead = displayBuilders.arrowhead( arrow, 0, 0, headHeight, headHeight, 
	                                         {color = color, 
											 rotation = rotation, 
											 width = width })

    -- remember, rotate then translate for correct result!
	arrowhead.x = endX 
	arrowhead.y = endY 

	arrow.head = arrowhead
	
	arrow.angle = rotation

	arrow.vx = vx
	arrow.vy = vy

	arrow.cx = cx
	arrow.cy = cy

	arrow:insert( arrowLine )

	return arrow
end

-- ==
--    func() - what it does
-- ==
function displayBuilders.arrow2( group, startX, startY, angle, length, visualParams)
	local group = group or display.currentStage

	local visualParams = visualParams
	if( not visualParams ) then visualParams = {} end

	local endX, endY = ssk.math2d.angle2Vector( angle )
	endX, endY = ssk.math2d.scale( endX, endY, length )
	endX, endY = ssk.math2d.add(startX, startY, endX, endY)

	return displayBuilders.arrow( group, startX, startY, endX, endY, visualParams )

end

-- ==
--    func() - what it does
-- ==
function displayBuilders.line( group, startX, startY, endX, endY, visualParams )
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
	
	local width = visualParams.w or 1 
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
		aDash.width = width
		aDash:setColor( unpack(color) )

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
				aDash.width = width
				aDash:setColor( unpack(color) )
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
				local aDash = displayBuilders.arrow( group, curX, curY, newX,newY, visualParams )
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
function displayBuilders.line2( group, startX, startY, angle, length, visualParams )
	local group = group or display.currentStage
	local endX, endY = ssk.math2d.angle2Vector( angle )
	endX, endY = ssk.math2d.scale( endX, endY, length )
	endX, endY = ssk.math2d.add(startX, startY, endX, endY)
	return displayBuilders.line( group, startX, startY, endX, endY, visualParams )
end


--EFM add ability to append new segments
--EFM add arrowcapped style (single end arrowhead)
-- ==
--    func() - what it does
-- ==
function displayBuilders.segmentedLine( group, points, visualParams )
	local group = group or display.currentStage
	local theLine = display.newGroup()
	group:insert( theLine )

	local visualParams = visualParams
	if( not visualParams ) then visualParams = {} end

	local width = visualParams.w or 1 
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
			tmpLine.width = width
			tmpLine:setColor( unpack(color) )
		end


	elseif(theLine.style == "dashed") then 
	
		local tmpLine = nil
		for i = 2, #points do
			if( i % 2 == 0) then
				local a = points:get(i-1)
				local b = points:get(i)
				tmpLine = display.newLine( a.x, a.y, b.x, b.y )

				theLine:insert(tmpLine)
				tmpLine.width = width
				tmpLine:setColor( unpack(color) )
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
			local tmpArrowHead = displayBuilders.arrowhead( theLine, a.x, a.y, size, size, visualParams )
		end
	end


	return theLine
end


local mCos = math.cos
local mSin = math.sin

-- ==
--    func() - what it does
-- ==
function displayBuilders.arc(group, x,y,w,h,s,e,rot) -- modification of original code by: rmbsoft (Corona Forums Member)
	local group = group or display.currentStage
	local theArc = display.newGroup()

	local xc,yc,xt,yt = 0,0,0,0
	s,e = s or 0, e or 360
	s,e = math.rad(s),math.rad(e)
	w,h = w/2,h/2
	local l = display.newLine(0,0,0,0)
	if(rot == 0) then
		l:setColor(255, 0, 0)
	else
		l:setColor(0, 255, 0)
	end
	l.width = 4
                
	theArc:insert( l )
		
	for t=s,e,0.02 do 
		local cx,cy = xc + w*mCos(t), yc - h*mSin(t)
		l:append(cx,cy) 
	end

	group:insert( theArc )

	-- Center, Rotate, then translate		
	theArc.x,theArc.y = 0,0
	theArc.rotation = rot
	theArc.x,theArc.y = x,y
			
	return theArc
end
        
-- ==
--    func() - what it does
-- ==
function displayBuilders.ellipse(group, x, y, w, h, rot) -- modification of original code by: rmbsoft (Corona Forums Member)
	local group = group or display.currentStage
	return displayBuilders.arc(group, x, y, w, h, nil, nil, rot)
end

