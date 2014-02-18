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
function displayExtended.arrowhead( group, x, y, width, height, visualParams )
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
		head:setStrokeColor( unpack(visualParams.color))
	end

--EFM G2	if( visualParams.referencePoint ) then
--EFM G2		head:setReferencePoint( visualParams.referencePoint )
--EFM G2	end

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
function displayExtended.arrow( group, startX, startY, endX, endY, visualParams )
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

	arrowLine:setStrokeColor( unpack(color))

	arrowLine.strokeWidth = width

	local arrowhead = displayExtended.arrowhead( arrow, 0, 0, headHeight, headHeight, 
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
function displayExtended.arrow2( group, startX, startY, angle, length, visualParams)
	local group = group or display.currentStage

	local visualParams = visualParams
	if( not visualParams ) then visualParams = {} end

	local endX, endY = ssk.math2d.angle2Vector( angle )
	endX, endY = ssk.math2d.scale( endX, endY, length )
	endX, endY = ssk.math2d.add(startX, startY, endX, endY)

	return displayExtended.arrow( group, startX, startY, endX, endY, visualParams )

end
