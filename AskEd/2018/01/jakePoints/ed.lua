
local p1, p2

local function calculatePoints( )

	local vec = ssk.math2d.diff( p1, p2 )

	local angle = ssk.math2d.vector2Angle(vec)
	local len = ssk.math2d.length( vec )

	print( angle, len )

	local angleBetween_p3_p4 = 30

	local p3 = ssk.math2d.angle2Vector( angle - angleBetween_p3_p4/2, true )
	p3 = ssk.math2d.scale( p3, len )

	local p4 = ssk.math2d.angle2Vector( angle + angleBetween_p3_p4/2, true )
	p4 = ssk.math2d.scale( p4, len )	

	p3 = ssk.math2d.add(p1, p3)
	p4 = ssk.math2d.add(p1, p4)

	return p3, p4
end

local function onTouch( event )
	if( event.phase ~= "ended" ) then return false  end
	if( not p1 ) then
		p1 = display.newCircle( event.x, event.y, 10 )
		p1:setFillColor( 1, 0 , 0 )
		return true
	end

	if( not p2 ) then
		p2 = display.newCircle( event.x, event.y, 10 )
		p2:setFillColor( 0, 1 , 0 )
		local line = display.newLine( p1.x, p1.y, p2.x, p2.y )
		line.strokeWidth = 4 
		line:toBack()
		return true
	end

	p3, p4 = calculatePoints()

	local tmp = display.newCircle( p3.x, p3.y, 10 )
	tmp:setFillColor( 1, 1, 0 )
	local line = display.newLine( p1.x, p1.y, p3.x, p3.y )
	line.strokeWidth = 2
	line:toBack()


	local tmp = display.newCircle( p4.x, p4.y, 10 )
	tmp:setFillColor( 0, 1, 1 )
	local line = display.newLine( p1.x, p1.y, p4.x, p4.y )
	line.strokeWidth = 2
	line:toBack()

	ignore("touch",onTouch)

end; listen( "touch", onTouch )