-- Question: https://forums.coronalabs.com/topic/72832-using-text-as-a-mask/
--
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================
-- =====================================================
local cx = display.contentCenterX
local cy = display.contentCenterY

local function mask( width, height, maskName, fontSize, text)
	local maskSrc = display.newContainer( width, height )
	maskSrc.x = cx
	maskSrc.y = cy
	local visible = display.newRect( maskSrc, 0, 0, width-6, height-6 )
	visible:setFillColor(1,1,1)
	local label = display.newText(maskSrc, text, 0, 0, "TitanOne-Regular.ttf", fontSize)
	label:setFillColor(0,0,0)
	display.save( maskSrc, { filename=maskName, baseDir=system.DocumentsDirectory, captureOffscreenArea=true, backgroundColor={0,0,0,1} })
	display.remove( maskSrc )
end

local function mask_inverse( width, height, maskName, fontSize, text)
	local maskSrc = display.newContainer( width, height )
	maskSrc.x = cx
	maskSrc.y = cy
	local label = display.newText(maskSrc, text, 0, 0, "TitanOne-Regular.ttf", fontSize)
	label:setFillColor(1,1,1)
	display.save( maskSrc, { filename=maskName, baseDir=system.DocumentsDirectory, captureOffscreenArea=true, backgroundColor={0,0,0,1} })
	display.remove( maskSrc )
end
-- =====================================================
-- =====================================================

mask( 300, 240, "mask1.png", 36, "Lorem Ipsum\nLorem Ipsum\nLorem Ipsum\nLorem Ipsum\nLorem Ipsum" )
mask_inverse( 300, 240, "mask2.png", 36, "Lorem Ipsum\nLorem Ipsum\nLorem Ipsum\nLorem Ipsum\nLorem Ipsum" )

local img1 = display.newImageRect( "cave.png", 320, 240 )
img1.x = cx
img1.y = cy - 200
local mask1 = graphics.newMask( "mask1.png", system.DocumentsDirectory)
img1:setMask(mask1)
img1:scale(1.5,1.5)


local img2 = display.newImageRect( "cave.png", 320, 240 )
img2.x = cx
img2.y = cy + 200
local mask2 = graphics.newMask( "mask2.png", system.DocumentsDirectory)
img2:setMask(mask2)
img2:scale(1.5,1.5)