-- =============================================================
-- page1.lua
-- =============================================================
local storyboard = require( "storyboard" )
local scene      = storyboard.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables

-- Callbacks/Functions (Forward Declaration)
local easyMemLabels
local easyButton
local mainMemLabel
local textureMemLabel

local imageHandles

local onButtonRelease

----------------------------------------------------------------------
--	STORYBOARD METHOD DEFINITIONS
----------------------------------------------------------------------
function scene:createScene( event )
	local screenGroup = self.view	

	easyMemLabels( screenGroup, centerY - 200 )
	easyButton( screenGroup, centerX, centerY + 200 , "Back", onButtonRelease, "mainMenu" )

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnterScene( event )
	local screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:enterScene( event )
	local screenGroup = self.view

	imageHandles = {}

	local tmpGroup = display.newGroup()
	screenGroup:insert( tmpGroup )
	tmpGroup:toBack()

	local tmp

	for h = 1, 500 do
		for i = 1, w / 40 do
			for j = 1, h / 40 do
				tmp = display.newImageRect( tmpGroup, "geek.png", 40, 40 )
				tmp.x = i * 40 - 20
				tmp.y = j * 40 - 20
				tmp:setFillColor( math.random(1,255), math.random(1,255), math.random(1,255) )

				imageHandles[#imageHandles+1] = tmp 
			end
		end	
	end
	print("Created " .. #imageHandles .. " images" )

	monitorMem( mainMemLabel, textureMemLabel )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:exitScene( event )
	local screenGroup = self.view	
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExitScene( event )
	local screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroyScene( event )
	local screenGroup = self.view

	mainMemLabel = nil
	textureMemLabel = nil

	imageHandles = nil -- Remove the table and all handles at once.
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
easyMemLabels = function( group, y )

	local tmp = display.newRect( group, 0, 0, w-20, 30) 		
	tmp.x = centerX
	tmp.y = y + 160
	tmp:setFillColor(32,32,32)
	mainMemLabel = display.newText( group, "LOADING", 0, 0, native.systemFont, 18 )
	mainMemLabel.x = tmp.x
	mainMemLabel.y = tmp.y

	local tmp = display.newRect( group, 0, 0, w-20, 30) 		
	tmp.x = centerX
	tmp.y = y + 200
	tmp:setFillColor(32,32,32)
	textureMemLabel = display.newText( group, "LOADING", 0, 0, native.systemFont, 18 )
	textureMemLabel.x = tmp.x
	textureMemLabel.y = tmp.y

end


easyButton = function( group, x, y, labelText, listener, targetScene )
	
	local button = display.newRect( group, 0, 0, 120, 30) 

	button.x = x
	button.y = y

	button:setFillColor( 32,32,32,255 )
	button:setStrokeColor( 128,128,128,255 )
	button.strokeWidth = 1

	button.targetScene = targetScene
	button.touch = listener
	button:addEventListener( "touch", button )

	local tmp = display.newText( group, labelText, 0, 0, native.systemFont, 18 )
	tmp.x = button.x
	tmp.y = button.y

	return button
end


onButtonRelease = function ( self, event ) 
	if(event.phase == "ended") then
		print("onButtonRelease go to: ", self.targetScene )	
		storyboard.gotoScene( self.targetScene,  { effect = "fade", time = 100, }  )			
	end
	return true
end

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "didExitScene", scene )
scene:addEventListener( "destroyScene", scene )
---------------------------------------------------------------------------------

return scene
