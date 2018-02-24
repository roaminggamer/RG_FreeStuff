-----------------------------------------------------------------------------------------
--
-- words.lua
--
-- Copyright 2018 IdeateGames
-- all rights reserved
--
-- 
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"
local json = require("json")


local POOLDIA = 0.2*WIDTH
local butsize = 100


local arrowLoc = {{x=WIDTH/4,y=0.7*HEIGHT},
	{x=3*WIDTH/4,y=0.7*HEIGHT}}
local restartLoc = {x=WIDTH-butsize/2,y=butsize/2}

-- forward declarations
local thisOne, sceneGroup, StageTimer

function IGremove( item )
    if item then pcall(function() item:removeSelf();item=nil; end) end
end
local function nextStage()
    thisOne.x = arrowLoc[2].x
	speaker:play()
end


local function resetGame()
	if StageTimer then timer.cancel(StageTimer) end
	IGremove(speaker)
	IGremove(currentImage)
	currentWord = "bubble_1"
    thisOne.x = arrowLoc[1].x

	local sequenceData = {
    -- consecutive frames sequence
	    {
	        name = "normalRun",
	        start = 1,
	        count = 10,
	        time = 2400,
	        loopCount = 1,
	    }
	}
	local sheetOptions =
		{width = 250,
	    height = 250,
	    numFrames = 10
	}
	local imageSheet = graphics.newImageSheet( "mouths/mouths_sheet.png", sheetOptions )
	currentImage = display.newSprite( sceneGroup, imageSheet, sequenceData )
	currentImage.x,currentImage.y = WIDTH/4,HEIGHT/2

	currentImage:play()
	StageTimer = timer.performWithDelay(2400,nextStage)

	speaker = display.newSprite( sceneGroup, imageSheet, mouthSequences['bubble_1'] )
	speaker.x,speaker.y = 3*WIDTH/4,HEIGHT/2

	return true
end
function scene:create( event )
	sceneGroup = self.view

	bg = display.newRect( WIDTH/2, HEIGHT/2, 1.25*WIDTH, 1.25*HEIGHT )
	bg:setFillColor( 0 )
    sceneGroup:insert(bg)

    local loopHead = display.newText(sceneGroup,'Simple loop',WIDTH/4,0.3*HEIGHT,native.systemFont, 52)

    local stepHead = display.newText(sceneGroup,'Discrete steps',3*WIDTH/4,0.3*HEIGHT,native.systemFont, 52)

    thisOne = display.newImageRect(sceneGroup,'pics/up.png',butsize,butsize)
    thisOne.x,thisOne.y = arrowLoc[1].x,arrowLoc[1].y

    local restartBtn = display.newImageRect(sceneGroup,'pics/restart.png',butsize,butsize)
    restartBtn.x,restartBtn.y = restartLoc.x,restartLoc.y
    restartBtn:addEventListener("tap",resetGame)


end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
	elseif phase == "did" then
		timer.performWithDelay(1000,resetGame)
	end
end
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	if phase == "did" then
	end	
	
end
local function onSystemEvent( event )


end
--setup the system listener to catch applicationExit etc
-- Runtime:addEventListener( "enterFrame", onEveryFrame )

-- Runtime:addEventListener( "system", onSystemEvent )

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene