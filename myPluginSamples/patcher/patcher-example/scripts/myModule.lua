local m = {}
local cx,cy = display.contentCenterX, display.contentCenterY
local mRand = math.random
function m.run( group )
	local tmp = display.newCircle( group, cx + mRand(-200,200), cy + mRand(-20,80), 60 )
	tmp:setFillColor(1,mRand(),mRand())
	display.newText( group, 'original - scripts.myModule', cx, cy + 160,  'Lato-Black.ttf', 22 )
end
return m