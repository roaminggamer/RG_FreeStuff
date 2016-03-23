local mAbs = math.abs


local cloud = display.newImage( "cloud.png", 300, 100)
cloud.xScale = 0.4
cloud.yScale = 0.4

local cw 		= cloud.width
local halfW 	= cw/2
local beginX 	= display.contentWidth + halfW	 
local endX		= -halfW

local speed 	= 200
local time 		= 1000 * mAbs(endX - beginX) / speed

cloud.x = beginX
cloud.onComplete = function( self )
	self.x = beginX	
	transition.to( self, { x = endX, time = time, onComplete = self } )
end

transition.to( cloud, { x = endX, time = time, onComplete = cloud } )

