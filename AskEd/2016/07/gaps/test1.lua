
-- red background to make gaps easy to see
local back = display.newRect( display.contentCenterX, display.contentCenterY, 10000, 10000 )
back:setFillColor(1,0,0)

local size = 128
local startX = -display.actualContentWidth
local startY = -display.actualContentHeight
local group = display.newGroup()
group.x = display.contentCenterX
group.y = display.contentCenterY

for i = 1, (2*display.actualContentWidth)/size do
	for j = 1, (2*display.actualContentHeight)/size do
		local tmp = display.newImageRect( group, "tile" .. math.random(1,2) .. ".jpg", size, size )
		tmp.x = startX + (i-1) * size
		tmp.y = startY + (j-1) * size
	end
end

local move1
local move2

move1 = function()
	transition.to( group, { x = display.contentCenterX + math.random( -100, 100 ),  y = display.contentCenterY + math.random( -100, 100 ), onComplete = move2 } )
end

move2 = function()
	transition.to( group, { x = display.contentCenterX,  y = display.contentCenterY, onComplete = move1 } )
end


move1()



