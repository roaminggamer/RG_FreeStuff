local m = {}
local cx,cy = display.contentCenterX, display.contentCenterY
local mRand = math.random
function m.run( group )
	local tmp = display.newRect( group, cx - 200, cy + 400, 120, 120 )
	transition.to(tmp, { x = tmp.x + 300, time = 2000, transition = easing.outBack } )
	tmp:setFillColor(1,1,1)
end
return m