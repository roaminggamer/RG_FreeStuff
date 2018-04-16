io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================

local container = display.newContainer( 300, 400 )
container.x = display.contentCenterX
container.y = display.contentCenterY

local image = display.newImageRect( container, "image.jpg", 3769, 2513 )


image.touch = function( self, event )
   if( event.phase == "began" ) then
   	self.x0 = self.x
   	self.y0 = self.y
   else
		self.x = event.x - event.xStart + self.x0
		self.y = event.y - event.yStart + self.y0
	end
		
end
image:addEventListener("touch")