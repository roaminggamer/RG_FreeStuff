io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720/2, 1386/2 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
back.alpha = 0.6
display.setDefault("background",0,1,0)
-- =====================================================
-- EXAMPLE BELOW
-- =====================================================
local topInset, leftInset, bottomInset, rightInset = display.getSafeAreaInsets()
print(topInset, leftInset, bottomInset, rightInset)

-- original width and height of your art, whatever you made it.
local origWidth = 256
local origHeight = 256

-- Take notch out of actual width
local modifiedActualWidth = display.actualContentWidth - leftInset

-- calculate exact width for 8 blocks to fill screen
local targetWidth = modifiedActualWidth/8

-- Calculate new height as ratio of original width and new width multiplied by old height
-- We do this to maintain the original aspect ratio of the art.
local targetHeight = (targetWidth/origWidth) * origHeight

-- calculate left edge of screen
local curX = display.contentCenterX - display.actualContentWidth/2 + leftInset

-- choose y position
local curY = display.contentCenterY

-- place 8 blocks left to right, aligned to their left edges.
for i = 1, 8 do
   local tmp = display.newImageRect( "letter_A.png", targetWidth, targetHeight )
   tmp.anchorX = 0
   tmp.x = curX
   tmp.y = curY
   curX = curX + targetWidth
end