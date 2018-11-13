io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
ssk.meters.create_fps(true)
ssk.meters.create_mem(true)
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

-- My original image was 12000 x 8854
-- I sliced it up in to a grid of 5 x 6 cells

-- Create group to hold slices and for dragging
-- Adjust so center cell will be on screen in middle
local map = display.newGroup()
map.x = centerX - 12000/2
map.y = centerY - 8854/2

local sliceW = 2000
local sliceH = 1770 -- row 2.. are 1771


-- Function to only fill image if it is on screen
local function doOnScreenFillTest( self )
	local x0 = self.x + self.parent.x + self.contentWidth
	local x1 = self.x + self.parent.x 

	local y0 = self.y + self.parent.y + self.contentHeight
	local y1 = self.y + self.parent.y 

   local onScreen = ( x0 >= left and x1 <= right ) and (y0 >= top and y1 <= bottom )

   if( onScreen and self.lastFill == "fillT.png" ) then
   	self.fill = { type = "image", filename = self.imgPath }
   	self.lastFill = self.imgPath
   	--print("SHOW", self.imgPath ) 
   
   elseif( not onScreen and self.lastFill == self.imgPath ) then
   	self.fill = { type = "image", filename = "fillT.png" }
   	self.lastFill = "fillT.png"
   	--print("HIDE", self.imgPath ) 
   end
end


-- Create images from slices
local slices = {}
local curX = 0
local curY = 0
for row = 1, 5 do
	local slice
	for col = 1, 6 do
		local imgPath = "slices/bigMap_" .. row .. "x" .. col .. ".png"
		slice = display.newImageRect( map, imgPath, sliceW, sliceH )
		slice.anchorX = 0
		slice.anchorY = 0
		slice.x = curX
		slice.y = curY
		curX = curX + sliceW
		--
		slice.imgPath = imgPath
		slice.lastFill = slice.imgPath
		--
		slice.doOnScreenFillTest = doOnScreenFillTest
		--
		slices[slice] = slice
		--
		slice:doOnScreenFillTest()
	end
	curX = 0
	curY = curY + sliceH
	--
	sliceH = 1771
end

-- Add dragger to group
local function listener( event )
   for k,v in pairs(slices) do
   	v:doOnScreenFillTest()
   end
end
ssk.misc.addSmartDrag( map, { toFront = true, listener = listener } )
