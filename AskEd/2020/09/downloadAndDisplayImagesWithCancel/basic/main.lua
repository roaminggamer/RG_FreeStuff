-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  main.lua
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================
-- EXAMPLE BEGIN
-- =============================================
require "extras"

-- Get the remote helper module, then localize the helper function for ease of use/typing.
local remoteImageHelper = require "remoteImageHelper"
local downloadAndUseRemoteImage = remoteImageHelper.downloadAndUseRemoteImage

--
-- Some random files I selected from my git to download in these examples
--
local imagePaths = {
	{ "makemygame.png", 	"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/ForumsImages/2018/makemygame.png" },
	{ "plane.png", 			"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/ForumsImages/2018/plane.png" },
	{ "ship.png", 			"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/ForumsImages/2018/ship.png" },
	{ "image4.png", 		"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/ForumsImages/2018/techority/Image4.png" },
	{ "ring_cylinder.png", 	"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/ForumsImages/ring_cylinder.png" },
	{ "player.png", 		"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/ForumsImages/player.png" },
	{ "ssk2tiny.png", 		"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/SSK2/ssk2tiny.png" },
	{ "carousel.jpg", 		"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/SSK23/ssk2PRO_carousel_image2.jpg" },
}

-- =============================================
-- Basic Example - Download then display images as them come it (run a few times to see that order changes)
-- =============================================
local curY = top 		-- top from 'extras.lua'


-- Basic failure handler that prints out 'Failed to download ...'
local function onDownloadFailure( downloadPath, saveAs, baseDir, event )
	print( "Failed to download file from URL: ", downloadPath )
end

-- Basic success handler.  As soon as object is downloaded, display it 
local function onDownloadSuccess( downloadPath, saveAs, baseDir, event )
	print( "Downloaded file from URL: ", downloadPath, " Processing." )


	-- 1. Create a display object (https://docs.coronalabs.com/api/library/display/newImage.html)
	local tmp = display.newImage( saveAs, baseDir )

	-- 2. Find out how tall the object is.	
	local height = tmp.contentHeight

	-- 3. Position the object
	curY = curY + height/2
	tmp.x = centerX -- centerX from 'extras.lua'
	tmp.y = curY

	-- 4. Adjust curY to bottom of the image so we're ready for next download completion
	curY = curY + height/2
end


for i = 1, #imagePaths do
	downloadAndUseRemoteImage( imagePaths[i][2], imagePaths[i][1], onDownloadSuccess, onDownloadFailure )
end
