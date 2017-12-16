-- =============================================================
--  main.lua
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
--require "ssk2.loadSSK"
--_G.ssk.init( )
-- =============================================================
-- Optionally enable meters to check FPS and Memory usage.
-- =============================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
-- =============================================================


local water = display.newRect( display.contentCenterX, display.contentCenterY, 
	                            display.actualContentWidth, display.actualContentHeight )

display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )

water.fill = { type = "image", filename = "waterSingle.png"}
water.fill.scaleX = 32/display.actualContentWidth
water.fill.scaleY = 32/display.actualContentHeight

display.setDefault( "textureWrapX", "clampToEdge" )
display.setDefault( "textureWrapY", "clampToEdge" )

water.texOffsetX 	= 0
water.texOffsetY 	= 0
water.lastT    	= system.getTimer()
water.rateX			= 0
water.rateY			= -3

function water.enterFrame( self )
	local curT 	= system.getTimer()
	local dt 	= curT - self.lastT
	self.lastT 	= curT

	local dOffsetX = dt * self.rateX / 1000
	local dOffsetY = dt * self.rateY / 1000
	
	self.texOffsetX = self.texOffsetX + dOffsetX
	self.texOffsetY = self.texOffsetY + dOffsetY

	--
	-- Keep values in bounds [-1, 1]
	--
	if( dOffsetX >= 0 ) then
		while(self.texOffsetX > 1) do
			self.texOffsetX = self.texOffsetX - 2
		end
	else
		while(self.texOffsetX < -1) do
			self.texOffsetX = self.texOffsetX + 2
		end
	end
	if( dOffsetY >= 0 ) then
		while(self.texOffsetY > 1) do
			self.texOffsetY = self.texOffsetY - 2
		end
	else
		while(self.texOffsetY < -1) do
			self.texOffsetY = self.texOffsetY + 2
		end
	end	

	self.fill.x = self.texOffsetX
	self.fill.y = self.texOffsetY
end
Runtime:addEventListener( "enterFrame", water )