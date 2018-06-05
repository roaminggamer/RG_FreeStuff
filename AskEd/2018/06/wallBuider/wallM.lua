
local segLength 	= 127
local segWidth 	= 19
local debugEn 		= true

local wallM = {}

function wallM.new( group, x, y, angle, length, fill, allowEndGap )
	group  	= group or display.currentStage
	angle  	= angle or 0
	length 	= length or 260
	fill   	= fill or {1,1,1}
	--
	if( length < segLength ) then return nil, nil, nil end
	--
	local parts = {}
	--

	--
	local numSegments = math.floor( length/segLength )
	local remaining = length - (numSegments * segLength)
	--
	local numGaps = (allowEndGap==true) and numSegments or numSegments-1
	local gapLen = 0
	if( numGaps > 0 ) then 
		gapLen = remaining/numGaps
	end
	--
	print( numSegments, remaining, numGaps, gapLen )
	--
	local vec = ssk.math2d.angle2Vector( angle, true )
	vec = ssk.math2d.scale( vec, segLength + gapLen )
	table.dump(vec)
	--
	
	for i = 1, numSegments do
		print( i, x, y )
		local seg = display.newRect( group, x, y, segLength, segWidth )
		seg.anchorX = 0
		seg.anchorY = 0
		seg.rotation = angle - 90
		seg:setFillColor( unpack(fill))
		--
		parts[#parts+1] = seg
		--
		if( debugEn ) then
			local tmp = display.newCircle( group, x, y, 5 )
			tmp:setFillColor(unpack(_R_))
			tmp.alpha = 0.75
		end
		--
		x = x + vec.x
		y = y + vec.y
	end
	return parts, x, y
end

return wallM