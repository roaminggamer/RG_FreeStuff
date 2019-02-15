-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Play GUI
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local onBack
local backButton 
local statusMarker
local saver 			= require "scripts.saver"

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
	local label = display.newEmbossedText( sceneGroup, "Non Blocking", centerX, centerY, native.systemFont, 60 )
	label:setFillColor( 0xCC/255, 1, 1  )
	local color = 
	{
	    highlight = { r=1, g=1, b=1 },
	    shadow = { r=0, g=1, b=0.3 }
	}
	label:setEmbossColor( color )

	statusMarker = display.newRect( sceneGroup, centerX, centerY + 200, 50, 50  )
	statusMarker.isVisible = false

	backButton = ssk.easyIFC:presetPush( sceneGroup, "default", centerX, centerY - 200, 200, 40, "Back", onBack )
	backButton.isVisible = false
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willShow( event )
	local sceneGroup = self.view	
	statusMarker.fill = { type = "image", filename = "images/throbber.png" }
	statusMarker.isVisible = true
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didShow( event )
	local sceneGroup = self.view

	local myTimer = timer.performWithDelay( 1, function() statusMarker.rotation = statusMarker.rotation + 10 end, -1 )

	local function onComplete()
		backButton.isVisible = true
		timer.cancel( myTimer )
		statusMarker.rotation = 0
		statusMarker.fill = { type = "image", filename = "images/check.png" }
	end

	saver.blocking( _G.bigData, "bigData.txt", onComplete  )
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
	statusMarker.isVisible = false
	backButton.isVisible = false
	statusMarker.rotation = 0
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end


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
	composer.gotoScene( "ifc.mainMenu", options  )	
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
