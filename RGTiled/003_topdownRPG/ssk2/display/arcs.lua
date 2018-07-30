-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Arc Factories
-- =============================================================
-- Create the display class if it does not yet exist
--
local displayExtended = {}

local mAbs = math.abs
local mCos = math.cos
local mSin = math.sin

function displayExtended.arc( group, x, y, params ) 
	group = group or display.currentStage
	params = params or {}
	local s   			= params.s or 0
	local radius  		= params.radius or 100
	local sweep   		= math.abs(params.sweep or 360)
	local strokeColor = params.strokeColor or { 1, 1, 1, 1 }
	local strokeWidth = params.strokeWidth or 4
	local incr 			= params.incr or 1

	local addVec = ssk.math2d.add;
	local angle2Vector = ssk.math2d.angle2Vector
	local scaleVec = ssk.math2d.scale

	local points = {}
	
	local dA = 0
	while( mAbs(dA) <= sweep ) do
		local vx, vy = angle2Vector( s + dA )
		vx, vy = scaleVec( vx, vy, radius )	
		local px, py = addVec(vx,vy,x,y)	
		
		points[#points+1] = px
		points[#points+1] = py
		dA = dA + incr 
	end

	local theArc = display.newLine( group, unpack(points) )

	theArc:setStrokeColor( unpack( strokeColor ) )
	theArc.strokeWidth = strokeWidth
			
	return theArc
end

-- ==
--    arc(group, x, y, params )
-- ==
function displayExtended.polyArc( group, x, y, params ) 
	group = group or display.currentStage
	params = params or {}
	local s   			= params.s or 0
	local radius  		= params.radius or 100
	local sweep   		= math.abs(params.sweep or 360)
	local fillColor 	= params.fillColor or { 1, 1, 1, 1 }
	local strokeColor = params.strokeColor or { 1, 1, 1, 1 }
	local strokeWidth = params.strokeWidth or 0
	local incr 			= params.incr or 1
	local rot 			= params.rot or 0

	local addVec = ssk.math2d.add;
	local angle2Vector = ssk.math2d.angle2Vector
	local scaleVec = ssk.math2d.scale

	local points = {}
	
	if( mAbs(sweep) < 360 ) then
		points[1] = x
		points[2] = y
	elseif( sweep < 0 ) then
		sweep = -360
	else sweep = 360
	end

	local dA = 0
	while( mAbs(dA) <= sweep ) do
		local vx, vy = angle2Vector( s + dA )
		vx, vy = scaleVec( vx, vy, radius )	
		local px, py = addVec(vx,vy,x,y)	
		
		points[#points+1] = px
		points[#points+1] = py
		dA = dA + incr 
	end

	-- Try to avoid intersection errors
	local minOffset = 0.001
	if( mAbs(points[1] - points[#points-1]) < minOffset and
		 mAbs(points[2] - points[#points]) < minOffset ) then
		table.remove( points, 1 )
		table.remove( points, 1 )
	end

	local theArc = display.newPolygon( group, x, y, points )

	theArc.rotation = rot

	if( theArc.width < radius * 2) then
		local dx = radius * 2 - theArc.width
		theArc.x = theArc.x - dx/2
	end
	if( theArc.height < radius * 2) then
		local dy = radius * 2 - theArc.height
		theArc.y = theArc.y - dy/2
	end

	theArc:setFillColor( unpack( fillColor ) )
	theArc:setStrokeColor( unpack( strokeColor ) )
	theArc.strokeWidth = strokeWidth
			
	return theArc
end

return displayExtended