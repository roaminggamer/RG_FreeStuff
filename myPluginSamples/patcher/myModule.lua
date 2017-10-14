local m = {}
local cx,cy = display.contentCenterX, display.contentCenterY
local mRand = math.random
function m.run( group )
	local tmp = display.newRect( group, cx - display.actualContentWidth/2 + 60, cy, 120, 120 )
	transition.to(tmp, { x = cx + display.actualContentWidth/2 - 60, time = 2000, transition = easing.outBack } )
	tmp:setFillColor(1,1,1)
	display.newText( group, 'patch v3 - scripts.myModule', cx, cy + 160,  'Lato-Black.ttf', 22 )
end
return m