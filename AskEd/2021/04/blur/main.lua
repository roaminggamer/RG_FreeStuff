io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2

-- =====================================================
-- IMAGE RECT
-- =====================================================
local function drawRect( group, color, size, do_snap ) 
	local snapshot

	if( do_snap ) then
		snapshot = display.newSnapshot( size + 10, size + 10 )
		group:insert(snapshot)
	end
	
	local ex = display.newImageRect( "fillW.png", size, size )
	ex:setFillColor(unpack(color))
	if( do_snap ) then
		snapshot.group:insert( ex )
	else
		group:insert(ex)
	end

	if( do_snap)  then
		snapshot:invalidate()               -- Invalidate snapshot
		snapshot.fill.effect = "filter.blur"
		-- snapshot.fill.effect = "filter.blurGaussian"
		-- snapshot.fill.effect.horizontal.blurSize = 10
		-- snapshot.fill.effect.horizontal.sigma = 90
		-- snapshot.fill.effect.vertical.blurSize = 10
		-- snapshot.fill.effect.vertical.sigma = 90
   end
end

local function rectBlurTest( x, y, color1, color2 )

	local group = display.newGroup( )
	drawRect(group, color1, 68, true)
	drawRect(group, color2, 60, false)
	group.x = x
	group.y = y
end

rectBlurTest( cx - 100, cy - 200, {1,0,0}, {1,0,0} )
rectBlurTest( cx + 100, cy - 200, {1,.5, 0}, {1,0,0} )


-- =====================================================
-- Circle
-- =====================================================
local function drawCircle( group, color, size, do_snap ) 
	local snapshot

	if( do_snap ) then
		snapshot = display.newSnapshot( size + 10, size + 10 )
		group:insert(snapshot)
	end
	
	local ex = display.newCircle(  0, 0, size/2 )
	ex:setFillColor(unpack(color))
	if( do_snap ) then
		snapshot.group:insert( ex )
	else
		group:insert(ex)
	end

	if( do_snap)  then
		snapshot:invalidate()               -- Invalidate snapshot
		snapshot.fill.effect = "filter.blur"
		-- snapshot.fill.effect = "filter.blurGaussian"
		-- snapshot.fill.effect.horizontal.blurSize = 10
		-- snapshot.fill.effect.horizontal.sigma = 90
		-- snapshot.fill.effect.vertical.blurSize = 10
		-- snapshot.fill.effect.vertical.sigma = 90
   end
end

local function circleBlurTest( x, y, color1, color2 )

	local group = display.newGroup( )
	drawCircle(group, color1, 72, true)
	drawCircle(group, color2, 60, false)
	group.x = x
	group.y = y
end

circleBlurTest( cx - 100, cy, {1,1,0}, {1,1,0} )
circleBlurTest( cx + 100, cy, {1,1, 0.5}, {1,1,0} )



-- =====================================================
-- Circle
-- =====================================================
local function drawLine( group, color, size, do_snap ) 
	local snapshot

	if( do_snap ) then
		snapshot = display.newSnapshot( 100, 100 )
		group:insert(snapshot)
	end
	
	local ex = display.newLine(  -40, 0, 40, 0 )
	ex:setStrokeColor(unpack(color))
	ex.strokeWidth = size
	if( do_snap ) then
		snapshot.group:insert( ex )
	else
		group:insert(ex)
	end

	if( do_snap)  then
		snapshot:invalidate()               -- Invalidate snapshot
		snapshot.fill.effect = "filter.blur"
		-- snapshot.fill.effect = "filter.blurGaussian"
		-- snapshot.fill.effect.horizontal.blurSize = 10
		-- snapshot.fill.effect.horizontal.sigma = 90
		-- snapshot.fill.effect.vertical.blurSize = 10
		-- snapshot.fill.effect.vertical.sigma = 90
   end
end

local function lineBlurTest( x, y, color1, color2 )

	local group = display.newGroup( )
	drawLine(group, color1, 6, true)
	drawLine(group, color2, 4, false)
	group.x = x
	group.y = y
end

lineBlurTest( cx - 100, cy + 200, {0,1,0}, {0,1,0} )
lineBlurTest( cx + 100, cy + 200, {0.5,1, 0.5}, {0,1,0} )

