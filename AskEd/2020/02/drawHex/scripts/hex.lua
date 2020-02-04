-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- hex.lua - Common Settings Module
-- =============================================================
-- http://www.quarkphysics.ca/scripsi/hexgrid/
-- =============================================================
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale


local offset_xy = function ( t )
	local sort = table.sort
	local coordinatesX, coordinatesY = {}, {}
	local minX, maxX, minY, maxY
	local function compare( a, b )
		return a > b
	end
	for i = 1, #t*0.5 do
		coordinatesY[i] = t[i*2]
	end
	for i = 1, #t*0.5 do
		coordinatesX[i] = t[i*2-1]
	end
	sort( coordinatesX, compare )
	maxX = coordinatesX[1]
	minX = coordinatesX[#coordinatesX]
	sort( coordinatesY, compare )
	maxY = coordinatesY[1]
	minY = coordinatesY[#coordinatesY]
	local offset_x = (minX+maxX)*0.5
	local offset_y = (minY+maxY)*0.5
	return offset_x, offset_y
end

local hexM = {}

function hexM.drawGridGroup( group, x, y, params )
	group = group or display.currentStage
	params = params or {}
	params.orientation = params.orientation or 1
	params.edgeLen = params.edgeLen or 40
	--
	local edgeLen = params.edgeLen
	--
	local gridGroup = display.newGroup()
	group:insert( gridGroup )
	--
	local pieces = {}
	--
	local cols = params.cols or 3
	local rows = params.rows or 3
	-- 
	local startX = params.centerGrid and 0 or x
	local startY = params.centerGrid and 0 or y
	local curX = startX
	local curY = startY
	local hexWidth
	local hexHeight
	--
	if( params.orientation == 1 ) then -- POINTY
		for row = 1, rows do
			for col = 1, cols do
				local hex = hexM.draw( gridGroup, curX, curY, params )
				pieces[#pieces+1] = hex
				hex.row = row
				hex.col = col
				hexWidth = hexWidth or hex.contentWidth
				hexHeight = hexHeight or hex.contentHeight
				curX = curX + hexWidth
			end
			local ox = (row % 2 == 0) and 0 or hexWidth/2
			curX = startX + ox
			curY = curY + (edgeLen/2 + hexHeight/2)--hexHeight
		end
	else  -- FLAT
		for row = 1, rows do
			for col = 1, cols do
				local oy = 0
				if( col > 1 ) then
					oy = (col % 2 == 0 ) and hexHeight/2  or 0
				end
				local hex = hexM.draw( gridGroup, curX, curY+oy, params )
				pieces[#pieces+1] = hex
				hex.row = row
				hex.col = col
				hexWidth = hexWidth or hex.contentWidth
				hexHeight = hexHeight or hex.contentHeight
				curX = curX + (hexWidth/2 + edgeLen/2)
			end
			curX = startX
			curY = curY + hexHeight
		end
	end
	gridGroup.pieces = pieces
	----[[
	-- MOVE PIECES & GRID
	if( params.centerGrid ) then
		local gw = gridGroup.contentWidth 
		local gh = gridGroup.contentHeight
		local ox
		if( params.orientation == 1 ) then
			ox = - gw/2 + hexWidth/2
			oy = - gh/2 + hexHeight/2
		else
			ox = - gw/2 + edgeLen
			oy = - gh/2 + hexHeight/2
		end
		for i = 1, #pieces do
			local piece = pieces[i]
			piece.x = piece.x + ox
			piece.y = piece.y + oy
		end
		gridGroup.x = x
		gridGroup.y = y
	end
	--]]
	--[[
	-- MOVE GRID ONLY
	if( params.centerGrid ) then
		local gw = gridGroup.contentWidth 
		local gh = gridGroup.contentHeight
		if( params.orientation == 1 ) then
			gridGroup.x = x - gw/2 + hexWidth/2
			gridGroup.y = y - gh/2 + hexHeight/2
		else
			gridGroup.x = x - gw/2 + edgeLen
			gridGroup.y = y - gh/2 + hexHeight/2
		end
	end
	--]]

	if( params.debugEn ) then
		for i = 1, #pieces do
			local text = pieces[i].row .. ", " .. pieces[i].col
			pieces[i].label = display.newText( gridGroup, text, pieces[i].x, pieces[i].y, nil, 12 )
		end
	end
	return gridGroup
end

function hexM.draw( group, x, y, params )
	group = group or display.currentStage
	params = params or {}
	--
	local edgeLen 		= params.edgeLen or 40
	local fill 			= params.fill
	local stroke 		= params.stroke
	local strokeWidth = params.strokeWidth or 0
	-- ORIENTATION: http://www.quarkphysics.ca/scripsi/hexgrid/
	local orientation = params.orientation or 1 -- 1: pointy, 2: flat 
	--
	local points
	--
	if( orientation == 1 ) then
		points = { { x = 0, y = 0 } }
		for i = 2, 6 do
			local lastPoint = points[i-1]
			local point = angle2Vector( 60 * ( i -1 ), true )
			point = scaleVec( point, edgeLen )
			point = addVec( point, lastPoint )
			point.x = round( point.x, 2)
			point.y = round( point.y, 2)
			points[#points+1] = point
		end
	elseif( orientation == 2 ) then
		local offsetV = edgeLen/math.cos( math.rad(30) )
		local offsetH = math.sqrt( offsetV ^ 2 + edgeLen ^ 2)
		offsetV = round(offsetV)
		offsetH = round(offsetH)
		print(offsetV, offsetH)
		points = {  { x = -offsetH - edgeLen/2, y = 0 }	}
		local angle = 30
		for i = 2, 6 do
			local lastPoint = points[i-1]			
			if( i > 2 ) then
				angle = angle + 60				
			end
			--
			local point = angle2Vector( angle, true )			
			point = scaleVec( point, edgeLen )
			point = addVec( point, lastPoint )
			point.x = round( point.x, 2)
			point.y = round( point.y, 2)
			points[#points+1] = point
		end
	end
	--
	local vertices = {}
	--
	for i = 1, #points do
		vertices[#vertices+1] = points[i].x
		vertices[#vertices+1] = points[i].y
	end
	--
	local hex = display.newPolygon( group, x, y, vertices )
	--
	if( fill ) then 
		if( fill.type == "color" ) then
			hex:setFillColor( unpack( fill.color ) )
		else
			hex.fill = fill
		end
	end
	--
	if( stroke ) then
		if( stroke.type == "color" ) then
			hex:setStrokeColor( stroke.color )
		else
			hex.stroke = stroke
		end				
	end
	--
	hex.strokeWidth = strokeWidth	

	return hex
end

return hexM
