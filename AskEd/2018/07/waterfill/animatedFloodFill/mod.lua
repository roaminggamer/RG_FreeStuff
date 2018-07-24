
local mod = {}

function mod.create( group, x, y, params  )
	local water = display.newContainer( group, params.width, params.height )
	water.x = x
	water.y = y

	local startX = -params.width/2 + params.baseWidth/2
	local startY = -params.height/2 + params.baseHeight/2
	local endX 	 = startX + params.width
	local endY   = startY + params.height
	local curX   = startX
	local curY   = startY
	while curY < endY do
	   curX = startX
		while curX < endX  do
			local myAnimation = display.newSprite( water, params.sheet, params.seqData )
			myAnimation.x = curX
			myAnimation.y = curY
			myAnimation:play()
			curX = curX + params.baseWidth
		end
		curY = curY + params.baseHeight
	end

	return water
end


return mod