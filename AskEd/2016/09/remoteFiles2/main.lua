-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  main.lua
-- =============================================================

io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

-- Include SSK Core (Features I just can't live without.)
require("ssk_core.globals.variables")
require("ssk_core.globals.functions")
require("ssk_core.extensions.display")
require("ssk_core.extensions.io")
require("ssk_core.extensions.math")
require("ssk_core.extensions.string")
require("ssk_core.extensions.table")
require("ssk_core.extensions.transition_color")

-- =============================================
-- EXAMPLE BEGIN
-- =============================================
local imgNum = 0
local imagePaths = {
	"http://roaminggamer.com/wp-content/uploads/2014/05/eat_lean_plugins.png",
	"http://roaminggamer.com/wp-content/uploads/2016/08/new.png",
	"http://roaminggamer.com/wp-content/uploads/2016/08/plugins.png",
}

local saveNum = 1

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

replaceMe = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentWidth/1.67  )

-- Touch hanlder that starts new download on each touch
replaceMe.touch = function( self, event )
	if( event.phase == "began" ) then
		imgNum = imgNum + 1
		if( imgNum > #imagePaths ) then
			imgNum = 1
		end

		local downloadPath 	= imagePaths[imgNum]
		local fileToSave 	= "image" .. saveNum .. ".png"
		saveNum = saveNum + 1
		if( saveNum > 2 ) then
			saveNum = 1
		end

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
local instr = display.newText( "Touch Rectangle To Load Next Image", replaceMe.x, replaceMe.y - replaceMe.contentHeight/2 - 30, native.systemFont, 30  )
local support = display.newText( "<tap here> Get EAT Lean Today! <tap here>", replaceMe.x, replaceMe.y + replaceMe.contentHeight/2 + 50, native.systemFont, 32  )
support:setFillColor( 0, 1, 0 )
support.touch = function( self, event )
	if( event.phase == "began" ) then
		system.openURL("https://gumroad.com/l/eatlean#")
	end
	return true
end; support:addEventListener( "touch" )
transition.blink(support, { time = 2000 })