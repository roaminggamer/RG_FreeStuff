-- =============================================================
-- =============================================================

local curtainTime = 750
local closeEasing = easing.outCirc
local openEasing = easing.inCirc

local cover = {}

	cover.new = function( color )
	   local curtains = display.newGroup()
	   local leftCurtain = display.newRect( left, top, fullw/2, fullh )
	   leftCurtain:setFillColor(unpack(color))
	   leftCurtain.anchorX = 1
	   leftCurtain.anchorY = 0

	   local rightCurtain = display.newRect( right, top, fullw/2, fullh )
	   rightCurtain:setFillColor(unpack(color))
	   rightCurtain.anchorX = 0
	   rightCurtain.anchorY = 0

	   function curtains:enterFrame()
	   	self:toFront()
	   end; Runtime:addEventListener("enterFrame",curtains)

	   function curtains:close( onComplete )
	   	transition.to( leftCurtain, { x = centerX, time = curtainTime, transition = closeEasing } )
	   	transition.to( rightCurtain, { x = centerX, time = curtainTime, transition = closeEasing, onComplete = onComplete } )
	   end

	   function curtains:open()
	   	local function onComplete()
	   	   Runtime:removeEventListener("enterFrame",curtains)
	   	   display.remove(curtains)
	   	end
	   	transition.to( leftCurtain, { x = left, time = curtainTime, transition = openEasing } )
	   	transition.to( rightCurtain, { x = right, time = curtainTime, transition = openEasing, onComplete = onComplete } )
	   end

	   return curtains
	end

return cover