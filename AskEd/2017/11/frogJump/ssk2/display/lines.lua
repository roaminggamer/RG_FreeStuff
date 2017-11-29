-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Line Factories
-- =============================================================
local mDeg  = math.deg
local mRad  = math.rad
local mCos  = math.cos
local mSin  = math.sin
local mAcos = math.acos
local mAsin = math.asin
local mSqrt = math.sqrt
local mCeil = math.ceil
local mFloor = math.floor
local mAtan2 = math.atan2
local mPi = math.pi


local function add( x1, y1, x2, y2, alt)
	if(alt) then
		return { x = x2+x1, y = y2+y1 }
	end
	return x2+x1, y2+y1
end


local function sub( x1, y1, x2, y2, alt)
	if(alt) then
		return { x = x2-x1, y = y2-y1 }
	end
	return x2-x1, y2-y1
end

local function  len( x, y)
	return mSqrt( x * x + y * y )
end

local function  norm( x, y, alt )
	local vLen = len( x, y )
	if(alt) then
		return { x = x/vLen, y = y/vLen }
	end
	return x/vLen, y/vLen
end

local function a2v( angle, alt)
	local screenAngle = mRad(-(angle+90))
	local x = mCos(screenAngle) 
	local y = mSin(screenAngle) 

	if(alt) then
		return { x = -x, y = y }
	end
	return -x,y
end

local function v2a( x, y )
	return mCeil(mAtan2( y, x ) * 180 / mPi) + 90	
end

local function scale( x, y, mag, alt)
	if(alt) then
		return { x = x*mag, y = y*mag }
	end
	return x*mag,y*mag
end



-- Create the display class if it does not yet exist
--
local displayExtended = {}

function displayExtended.line( group, startX, startY, endX, endY, visualParams )
	group = group or display.currentStage

	local visualParams = visualParams
	if( not visualParams ) then visualParams = {} end

	local theLine = display.newGroup()
	group:insert( theLine )

	local vx,vy    = sub(startX, startY, endX, endY)
	local vLen     = len(vx,vy)
	local nx,ny    = norm(vx,vy)
	local cx,cy    = scale(nx,ny, vLen/2)
	      cx,cy    = add(startX, startY, cx, cy)
	local rotation = v2a(vx,vy)	

	theLine.vx = vx
	theLine.vy = vy
	theLine.cx = cx
	theLine.cy = cy
	theLine.angle = rotation
	
	local width = visualParams.w or visualParams.strokeWidth or 1 
	local color = visualParams.color or visualParams.fill or {1,1,1,1}
	local radius = visualParams.radius or 1
	local strokeColor = visualParams.stroke or {1,1,1,1}
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
		local dash_dx,dash_dy = norm(vx, vy)
		local gap_dx,gap_dy   = dash_dx,dash_dy
	
		dash_dx,dash_dy       = scale(dash_dx,dash_dy, dashLen)
		gap_dx,gap_dy         = scale(gap_dx,gap_dy, gapLen)

		local lineLen = 0
		local curX, curY = startX,startY
		local newX, newY = 0,0
		
		while( lineLen < vLen ) do
			-- Attempt to draw a dash
			lineLen = lineLen + dashLen
			if( lineLen < vLen ) then
				newX,newY = add( curX, curY, dash_dx, dash_dy )
				local aDash = display.newLine( curX, curY, newX, newY )
				theLine:insert(aDash)
				aDash.strokeWidth = width
				aDash:setStrokeColor( unpack(color) )
				curX,curY = newX,newY
			end
			-- Add a gap
			lineLen = lineLen + gapLen
			curX,curY = add( curX, curY, gap_dx, gap_dy )
		end

	elseif(theLine.style == "dotted") then
		local dot_dx,dot_dy = norm(vx, vy)
		local gap_dx,gap_dy   = dot_dx,dot_dy
	
		local lineLen = 0
		local curX, curY = startX,startY
		local newX, newY = 0,0

		if(radius<1) then radius = 1 end

		dot_dx,dot_dy       = scale(dot_dx,dot_dy, radius*2)
		gap_dx,gap_dy         = scale(gap_dx,gap_dy, gapLen)

		while( lineLen < vLen ) do
			-- Attempt to draw a dot
			lineLen = lineLen + radius*2
			if( lineLen < vLen ) then
				newX,newY = add( curX, curY, dot_dx, dot_dy )
				local adot = display.newCircle( theLine, curX, curY, radius )
				adot:setFillColor( unpack(color) )
				adot:setStrokeColor( unpack(strokeColor) ) 
				adot.strokeWidth = width
				curX,curY = newX,newY
			end
			-- Add a gap
			lineLen = lineLen + gapLen
			curX,curY = add( curX, curY, gap_dx, gap_dy )
		end

	elseif(theLine.style == "arrows") then
		local dash_dx,dash_dy = norm(vx, vy)
		local gap_dx,gap_dy   = dash_dx,dash_dy
	
		dash_dx,dash_dy       = scale(dash_dx,dash_dy, dashLen)
		gap_dx,gap_dy         = scale(gap_dx,gap_dy, gapLen)

		local lineLen = 0
		local curX, curY = startX,startY
		local newX, newY = 0,0

		while( lineLen < vLen ) do
			-- Attempt to draw a dash
			lineLen = lineLen + dashLen
			if( lineLen < vLen ) then
				newX,newY = add( curX, curY, dash_dx, dash_dy )
				local aDash = displayExtended.arrow( group, curX, curY, newX,newY, visualParams )
				theLine:insert(aDash)
			
				curX,curY = newX,newY

			end

			-- Add a gap
			lineLen = lineLen + gapLen
			curX,curY = add( curX, curY, gap_dx, gap_dy )
		end
	end

	return theLine
end
displayExtended.newLine = displayExtended.line

function displayExtended.line2( group, startX, startY, angle, length, visualParams )
	group = group or display.currentStage
	local endX, endY = a2v( angle )
	endX, endY = scale( endX, endY, length )
	endX, endY = add(startX, startY, endX, endY)
	return displayExtended.line( group, startX, startY, endX, endY, visualParams )
end
displayExtended.newAngleLine = displayExtended.line2


function displayExtended.newPointsLine( group, points, visualParams )
	group = group or display.currentStage
	local theLine = display.newGroup()
	group:insert( theLine )

	local visualParams = visualParams
	if( not visualParams ) then visualParams = {} end

	local width = visualParams.w or visualParams.strokeWidth or 1 
	local color = visualParams.color or visualParams.fill or {1,1,1,1}
	local radius = visualParams.radius or 1
	local strokeColor = visualParams.stroke or {1,1,1,1}

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
			tmpDot.strokeWidth = width
		end


	elseif(theLine.style == "arrowheads") then  --NOTE BUG arrowheads are offset! 
		local size = visualParams.size or visualParams.headSize or 10

		visualParams.rotation = 0

		for i = 1, #points do			
			local a = points:get(i)

			if(#points >= i+1) then
				local b = points:get(i+1)

				local nVec = sub(a.x, a.y, b.x, b.y, true)
				nVec = norm( nVec.x, nVec.y, true )
				local angle = v2a(nVec.x, nVec.y)
				visualParams.rotation = angle
			end
			
			local tmpArrowHead = displayExtended.arrowhead( theLine, a.x, a.y, size, size, visualParams )
		end
	end
	return theLine
end

function displayExtended.arrowhead( group, x, y, width, height, visualParams )
   group      = group or display.currentStage
	width      = width or 40
	height     = height or 40
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
	
	if(visualParams.fill) then
		head:setStrokeColor( unpack(visualParams.fill))
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

function displayExtended.arrow( group, startX, startY, endX, endY, visualParams )
	group = group or display.currentStage
	local arrow = display.newGroup()

	local visualParams = visualParams
	if( not visualParams ) then visualParams = {} end

	group:insert(arrow)

	local vx,vy  = sub(startX, startY, endX, endY)

	local vLen  = len(vx,vy) 

	local nx,ny = norm(vx,vy)

	local cx,cy = scale(nx,ny, vLen/2)
	cx,cy = add(startX, startY, cx, cy)
	
	local rotation = v2a(vx,vy)	
	
	local arrowLine = display.newLine( startX, startY, endX, endY )
	
	local width = visualParams.w or 1
	local color = visualParams.color or visualParams.fill or {1,1,1,1}
	local headHeight = visualParams.headHeight or visualParams.headSize or 10
	local headWidth = visualParams.headWidth or visualParams.headSize or 10

	arrowLine:setStrokeColor( unpack(color) )

	arrowLine.strokeWidth = width

	local arrowhead = displayExtended.arrowhead( arrow, 0, 0, headHeight, headHeight, 
	                                         {color = color, 
											 rotation = rotation, 
											 width = width })

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

function displayExtended.arrow2( group, startX, startY, angle, length, visualParams)
	group = group or display.currentStage

	local visualParams = visualParams
	if( not visualParams ) then visualParams = {} end

	local endX, endY = a2v( angle )
	endX, endY = scale( endX, endY, length )
	endX, endY = add(startX, startY, endX, endY)

	return displayExtended.arrow( group, startX, startY, endX, endY, visualParams )

end



return displayExtended