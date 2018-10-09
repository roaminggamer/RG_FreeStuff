io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
-- =====================================================

display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )
--
local img = display.newRect(cx, cy, fullw, fullh)
--
img.fill = { type="image", filename="Dirt.png" }
img.fill.scaleX = 512 / img.contentWidth
img.fill.scaleY = 512 / img.contentHeight
--
display.setDefault( "textureWrapX", "clampToEdge" )
display.setDefault( "textureWrapY", "clampToEdge" )


img.rate = 360/200 -- degrees per second

function img.enterFrame( self )
	local curT  = system.getTimer()
	local lastT = self.lastT  or curT
	self.lastT = curT
	local dt = (curT - lastT)/100
	local dr = self.rate * dt
	--	
	while( self.fill.rotation < 0 ) do
		self.fill.rotation = self.fill.rotation + 360
	end
	--
	self.fill.rotation = self.fill.rotation - dr
	img.path.x2 = -fullw / 2
	img.path.x3 = fullh / 2
end
Runtime:addEventListener( "enterFrame", img )
