io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

local mRand = math.random
local getTimer = system.getTimer

local centerX 	= display.contentCenterX
local centerY 	= display.contentCenterY
local fullw 	= display.actualContentWidth
local fullh 	= display.actualContentHeight
local left 		= centerX - fullw/2
local right 	= left + fullw
local top 		= centerY - fullh/2
local bottom 	= top + fullh


local function test( img, filename, desiredMaxWidth, desiredMaxHeight)

	desiredMaxWidth 	= desiredMaxWidth or 100
	desiredMaxHeight 	= desiredMaxHeight or 100

	local correctedWidth 		= desiredMaxWidth * display.contentScaleX
	local correctedHeight 		= desiredMaxHeight * display.contentScaleY

	local xScale0 = img.xScale
	local yScale0 = img.yScale

	local imgW = img.width
	local imgH = img.height

	local aspectRatio = imgW/imgH

	local rescale
	if( aspectRatio == 1 ) then
		if( correctedWidth < correctedHeight ) then			
			rescale = correctedWidth/imgW			
		else
			rescale = correctedHeight/imgH				
		end
	elseif( aspectRatio < 1 ) then
		rescale = correctedHeight/imgH	
	else
		rescale = correctedWidth/imgW
	end

	print( imgW, imgH, aspectRatio, rescale, desiredMaxWidth, desiredMaxHeight )

	local saveGroup = display.newGroup()
	saveGroup:insert(img)

	img:scale(rescale, rescale)

	timer.performWithDelay( 30, 
		function() 			
			display.save(saveGroup, filename)
			img.xScale = xScale0
			img.yScale = yScale0
		end )
end


local img1 = display.newImage( "edo.jpg", system.resourceDirectory )
img1.x = centerX - 100
img1.y = centerY

local img2 = display.newImage( "edosquare.jpg", system.resourceDirectory )
img2.x = centerX + 100
img2.y = centerY


local testToRun = 1

if( testToRun == 1 ) then
	test( img1, "img1_test1.jpg", 100, 100 ) -- should be ~ 83 x 100
	test( img2, "img2_test1.jpg", 100, 100 ) -- should be ~ 100 x 100

elseif( testToRun == 2 ) then
	test( img1, "img1_test2.jpg", 100, 150 ) -- should be ~ 125 x 150
	test( img2, "img2_test2.jpg", 100, 150 ) -- should be ~ 100 x 100


elseif( testToRun == 3 ) then
	test( img1, "img1_test3.jpg", 150, 100 ) -- should be ~ 83 x 100
  	test( img2, "img2_test3.jpg", 150, 100 ) -- should be ~ 100 x 100


elseif( testToRun == 4 ) then
	test( img1, "img1_test4.jpg", 150, 150 ) -- should be ~ 125 x 100
  	test( img2, "img2_test4.jpg", 150, 150 ) -- should be ~ 150 x 150

end
--local reScale = 


