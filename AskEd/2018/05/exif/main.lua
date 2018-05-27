io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local img = display.newImage("img.jpg", display.contentCenterX, display.contentCenterY )
local scale = display.contentWidth/img.width 
scale = 0.8 * scale
img:scale( scale, scale )

img.y = display.contentCenterY - display.actualContentHeight/2 + img.contentHeight/2

local y = img.y + img.contentHeight/2 + 20

local exif = require "exif"
local path = system.pathForFile( "img.jpg" )
local data = exif.read(path)

for k,v in pairs(data) do
	print(k,v)
	local text = display.newText( tostring(k) .. " == " .. tostring(v), 20, y )
	text.anchorX = 0
	text.anchorY = 0
	y = y + text.contentHeight + 10
end