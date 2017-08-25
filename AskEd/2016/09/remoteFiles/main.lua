-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  main.lua
-- =============================================================

io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

-- Include SSK Core (Features I just can't live without.)
require "ssk2.loadSSK"
_G.ssk.init()


-- =============================================
-- EXAMPLE BEGIN
-- =============================================
local imgNum = 0
local imagePaths = {
	"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/AskEd/2016/09/remoteFiles/images/cardClubs2.png",
	"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/AskEd/2016/09/remoteFiles/images/cardClubs3.png",
	"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/AskEd/2016/09/remoteFiles/images/cardClubs4.png",
	"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/AskEd/2016/09/remoteFiles/images/cardClubs5.png",
	"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/AskEd/2016/09/remoteFiles/images/cardClubs6.png",
	"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/AskEd/2016/09/remoteFiles/images/cardClubs7.png",
	"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/AskEd/2016/09/remoteFiles/images/cardClubs8.png",
	"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/AskEd/2016/09/remoteFiles/images/cardClubs9.png",
	"https://raw.githubusercontent.com/roaminggamer/RG_FreeStuff/master/AskEd/2016/09/remoteFiles/images/cardClubs10.png",
}


local replaceMe

local function networkListener( event )
    if ( event.isError ) then
        print( "Network error - download failed: ", event.response )
    elseif ( event.phase == "began" ) then
        print( "Progress Phase: began" )

    elseif ( event.phase == "ended" ) then
        print( "Fill rectangle 'replaceMe' with new image." )
        replaceMe.fill = { type = "image", filename = event.response.filename, baseDir = event.response.baseDirectory }
    end
end

replaceMe = display.newRect( display.contentCenterX, display.contentCenterY, 140, 190  )

-- Touch hanlder that starts new download on each touch
replaceMe.touch = function( self, event )
	if( event.phase == "began" ) then
		imgNum = imgNum + 1
		if( imgNum > #imagePaths ) then
			imgNum = 1
		end

		local downloadPath 	= imagePaths[imgNum]
		local fileToSave 	= string.split( downloadPath, "/" )
		fileToSave = fileToSave[#fileToSave]

		print("Download path: " .. tostring( downloadPath ))
		print("Save in temporary directory as: " .. tostring(fileToSave) )

		local params = {}
		network.download( downloadPath, "GET", networkListener, params, fileToSave, system.TemporaryDirectory )
	end
	return true
end; replaceMe:addEventListener( "touch" )




-- =============================================
-- EXAMPLE END
-- =============================================
local instr = display.newText( "Touch Square To Load Next Image", replaceMe.x, replaceMe.y - replaceMe.contentHeight/2 - 30, native.systemFont, 30  )
