-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
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


-- Create the display class if it does not yet exist
--
local displayExtended = {}

local mCos = math.cos
local mSin = math.sin

-- ==
--    arc(group, x, y, params ) - TBD
-- ==
function displayExtended.arc(group, x, y, params ) -- modification of original code by: rmbsoft (Corona Forums Member)
	local group = group or display.currentStage
	local theArc = display.newGroup()

	local params = params or {}

	local aw  = params.w or 100
	local ah  = params.h or 80
	local s   = params.s or 0
	local e   = params.e or 360
	local rot = params.rot or 0
	local strokeColor = params.strokeColor or { 1, 1, 1, 1 }
	local strokeWidth = params.strokeWidth or 4
	local incr = params.incr or 0.02

	local xc,yc,xt,yt = 0,0,0,0
	s,e = math.rad(s),math.rad(e)
	aw,ah = aw/2,ah/2
	local l = display.newLine(0,0,0,0)
	l:setStrokeColor( unpack( strokeColor ) )
	l.strokeWidth = strokeWidth
                
	theArc:insert( l )
		
	for t=s,e,incr do 
		local cx,cy = xc + aw*mCos(t), yc - ah*mSin(t)
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
--    arc(group, x, y, params ) - TBD
-- ==
function displayExtended.polyArc(group, x, y, params ) -- modification of original code by: rmbsoft (Corona Forums Member)
	local group = group or display.currentStage

	local params = params or {}

	local aw  = params.w or 100
	local ah  = params.h or 80
	local s   = params.s or 0
	local e   = params.e or 360
	local rot = params.rot or 0
	local fillColor = params.fillColor or { 1, 1, 1, 1 }
	local strokeColor = params.strokeColor or { 1, 1, 1, 1 }
	local strokeWidth = params.strokeWidth or 4
	local incr = params.incr or 0.02


	local points = {}

	local xc,yc,xt,yt = 0,0,0,0
	s,e = math.rad(s),math.rad(e)
	aw,ah = aw/2,ah/2
		
	for t=s,e,incr do 
		local cx,cy = xc + aw*mCos(t), yc - ah*mSin(t)
		points[#points+1] = cx
		points[#points+1] = cy
		--print(cx,cy)
	end

	-- EFM half-ellipses don't look quite right

	--points[#points-1] = points[1] + aw/2
	--points[#points] = points[2] + ah

	print(#points)

	local theArc = display.newPolygon( group, aw/2, ah/2, points )

	theArc.x = x
	theArc.y = y
	theArc.rotation = rot

	theArc:setFillColor( unpack( fillColor ) )
	theArc:setStrokeColor( unpack( strokeColor ) )
	theArc.strokeWidth = strokeWidth
			
	return theArc
end


        

return displayExtended