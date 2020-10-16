io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================

-- =====================================================
-- IGNORE ABOVE SECTION
-- =====================================================

-- API Docs https://docs.coronalabs.com/api/



local function doTest(size)
	-- https://docs.coronalabs.com/api/library/display/newGroup.html
	local group = display.newGroup()

	-- https://docs.coronalabs.com/api/library/display/newImageRect.html
	local tmp = display.newImageRect( group, "test_image.jpg", size, size )
	tmp.x = centerX -- ssk var 
	tmp.y = centerY-- ssk var 

	-- https://docs.coronalabs.com/api/library/timer/performWithDelay.html
	timer.performWithDelay( 500, 
		function()
			-- https://docs.coronalabs.com/api/library/display/save.html
			display.save( group, 
				{ filename 				= "maxTextureTest" .. "_" .. size .. ".jpg" , 
				  captureOffscreenArea  = true,
				} ) 
		end )

	timer.performWithDelay( 1000, 
		function()
			--https://docs.coronalabs.com/api/library/display/remove.html
			display.remove(group)
		end )

end



-- =====================================================
local ifcGroup = display.newGroup()

--
-- Determine maximum size of texture (place in label on screen)
-- https://docs.coronalabs.com/api/library/system/getInfo.html#maxtexturesize
local maxTextureSize = system.getInfo( "maxTextureSize" )

-- Show maxTextureSize info on screen
-- https://docs.coronalabs.com/api/library/display/newText.html#syntax-legacy
display.newText( ifcGroup, "Max Texture Size: " .. maxTextureSize, centerX, top + 50, "Roboto-Bold.ttf", 20 )


-- 
-- Add some buttons (using SSK) to test save various sized display objects.
--
local tmp = ssk.easyIFC:presetPush( ifcGroup, "default", centerX, centerY - 200, 200, 40, "1024 x 1024",   function() doTest(1024) end )
local tmp = ssk.easyIFC:presetPush( ifcGroup, "default", centerX, centerY - 150, 200, 40, "2048 x 2048",   function() doTest(2048) end )
local tmp = ssk.easyIFC:presetPush( ifcGroup, "default", centerX, centerY - 100, 200, 40, "4096 x 4096",   function() doTest(4096) end )
local tmp = ssk.easyIFC:presetPush( ifcGroup, "default", centerX, centerY -  50, 200, 40, "8192 x 8192",   function() doTest(8192) end )
local tmp = ssk.easyIFC:presetPush( ifcGroup, "default", centerX, centerY +   0, 200, 40, "16384 x 16384", function() doTest(16384) end )
local tmp = ssk.easyIFC:presetPush( ifcGroup, "default", centerX, centerY +  50, 200, 40, "32768 x 32768", function() doTest(32768) end ) -- add more as needed, but I think this is the max you will ever see
