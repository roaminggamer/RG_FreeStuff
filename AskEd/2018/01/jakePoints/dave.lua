
local p1, p2

local function calculatePoints( )

	local p1x, p1y = p1.x, p1.y
	local p2x, p2y = p1.x, p1.y
	local theta = math.pi/8
	local c, s = math.cos(theta), math.sin(theta)
	local dx, dy = p2x-p1x, p2y-p1y
	local p3x, p3y = p1x+dx*c-dy*s, p1y+dy*c+dx*s
	local p4x, p4y = p1x+dx*c+dy*s, p1y+dy*c-dx*s

	local p3 = { x =  p3x, y = p3y }
	local p4 = { x =  p4x, y = p4y }
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

	local p3, p4 = calculatePoints()

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