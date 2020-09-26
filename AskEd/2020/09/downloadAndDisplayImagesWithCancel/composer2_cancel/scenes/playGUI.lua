-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Play GUI
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

-- Get the remote helper module, then localize the helper function for ease of use/typing.
local remoteImageHelper = require "scripts.remoteImageHelper"
local downloadAndUseRemoteImage = remoteImageHelper.downloadAndUseRemoteImage

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local curY = top 		-- top from 'scripts.extras.lua'

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
	{ "carousel.jpg", 		"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/SSK2/ssk2PRO_carousel_image2.jpg" },
}


-- Forward Declarations
local onBack

-- Useful Localizations
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	-- Create a simple background
	local back = display.newImageRect( sceneGroup, "images/protoBack.png", 380*2, 570*2 )
	back.x = centerX
	back.y = centerY
	if(w>h) then back.rotation = 90 end

	-- Create a label showing which scene this is
	local label = display.newEmbossedText( sceneGroup, "Play GUI", centerX - 50, 40, native.systemFont, 60 )
	label:setFillColor( 0xCC/255, 1, 1  )
	local color = 
	{
	    highlight = { r=1, g=1, b=1 },
	    shadow = { r=0, g=1, b=0.3 }
	}
	label:setEmbossColor( color )

	-- Create a button
	local push1 = PushButton( sceneGroup, right - 110, top + 40, "Back", onBack, 
	                          { labelColor = {0.8,0.2,0.2}, labelSize = 24 } )

	curY = push1.y + 60


	-- Basic failure handler that prints out 'Failed to download ...'
	local function onDownloadFailure( downloadPath, saveAs, baseDir, event )
		print( "Failed to download file from URL: ", downloadPath )
	end

	-- Basic success handler.  As soon as object is downloaded, display it 
	local function onDownloadSuccess( downloadPath, saveAs, baseDir, event )
		print( "Downloaded file from URL: ", downloadPath, " Processing." )

		-- 0. Check to see that sceneGroup is still valid and exists or exit early.
		if( not display.isValid(sceneGroup) ) then 
			print( "sceneGroup invalid, skipping creation of image from file: ", saveAs )
			return 
		end

		-- 1. Create a display object (https://docs.coronalabs.com/api/library/display/newImage.html)
		local tmp = display.newImage( sceneGroup, saveAs, baseDir )

		-- 2. Find out how tall the object is.	
		local height = tmp.contentHeight

		-- 3. Position the object
		curY = curY + height/2
		tmp.x = centerX -- centerX from 'scripts.extras.lua'
		tmp.y = curY

		-- 4. Adjust curY to bottom of the image so we're ready for next download completion
		curY = curY + height/2
	end

	for i = 1, #imagePaths do
		downloadAndUseRemoteImage( imagePaths[i][2], imagePaths[i][1], onDownloadSuccess, onDownloadFailure )
	end

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willShow( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didShow( event )
	local sceneGroup = self.view

	-- Immediately call 'onBack' to force cancel code to excute in 'onDownloadSuccess()'
	onBack()

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willHide( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didHide( event )
	local sceneGroup = self.view
	composer.removeScene( "scenes.playGUI", true )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onBack = function ( self, event ) 
	local options =
	{
		effect = "fromTop", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "scenes.mainMenu", options  )	
	return true
end

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willShow( event )
	elseif( willDid == "did" ) then
		self:didShow( event )
	end
end
function scene:hide( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willHide( event )
	elseif( willDid == "did" ) then
		self:didHide( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
