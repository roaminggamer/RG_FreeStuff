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

local onButtonRelease

----------------------------------------------------------------------
--	STORYBOARD METHOD DEFINITIONS
----------------------------------------------------------------------
function scene:createScene( event )
	local screenGroup = self.view

	easyMemLabels( screenGroup, centerY )
	easyButton( screenGroup, centerX, centerY - 200, "1. 'Empty' Scene", onButtonRelease, "test1" )
	easyButton( screenGroup, centerX, centerY - 150, "2. Local w/ nil", onButtonRelease, "test2" )
	easyButton( screenGroup, centerX, centerY - 100, "3. Local w/o nil", onButtonRelease, "test3" )
	easyButton( screenGroup, centerX, centerY - 50,  "4. Local using Fields", onButtonRelease, "test4" )
	easyButton( screenGroup, centerX, centerY,       "5. Object Listeners Removed", onButtonRelease, "test5" )
	easyButton( screenGroup, centerX, centerY + 50,  "6. Object Listeners Not Removed", onButtonRelease, "test6" )
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

	storyboard.purgeAll()

	-- Give time for purge to take effect
	timer.performWithDelay( 100, 
		function()
			monitorMem( mainMemLabel, textureMemLabel )
		end )

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
	
	local button = display.newRect( group, 0, 0, 300, 30) 

	button.x = x
	button.y = y

	button:setFillColor( 32,32,32,255 )
	button:setStrokeColor( 128,128,128,255 )
	button.strokeWidth = 1

	button.targetScene = targetScene
	button.touch = listener
	button:addEventListener( "touch", button )

	local tmp = display.newText( group, labelText, 0, 0, native.systemFont, 14 )
	tmp:setReferencePoint( display.CenterLeftReferencePoint )
	tmp.x = button.x - button.width/2 + 10
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
