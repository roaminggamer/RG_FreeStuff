-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Main Menu
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables


-- Forward Declarations
local onPlay
local onGame
local onOptions
local onChooseInputStyle

local inputStyles = { "oneTouch", "twoTouch", "oneStick", "twoStick", "oneStickOneTouchA", "oneStickOneTouchB", "cornerButtons" }
local selectedInputStyle = inputStyles[1]

-- Useful Localizations
-- SSK 
local isInBounds		= ssk.easyIFC.isInBounds
local newCircle 		= ssk.display.circle
local newRect 			= ssk.display.rect
local newImageRect 		= ssk.display.imageRect
local easyIFC			= ssk.easyIFC
local ternary			= _G.ternary
local quickLayers  		= ssk.display.quickLayers

local angle2Vector 		= ssk.math2d.angle2Vector
local vector2Angle 		= ssk.math2d.vector2Angle
local scaleVec 			= ssk.math2d.scale
local addVec 			= ssk.math2d.add
local subVec 			= ssk.math2d.sub
local getNormals 		= ssk.math2d.normals

-- Lua and Corona
local mAbs 				= math.abs
local mPow 				= math.pow
local mRand 			= math.random
local getInfo			= system.getInfo
local getTimer 			= system.getTimer
local strMatch 			= string.match
local strFormat 		= string.format

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
	local layers = ssk.display.quickLayers( sceneGroup, "underlay", "content", "inputButtons", "overlay" )

	-- Create a simple background
	local back = display.newImageRect( layers.underlay, "images/protoBack.png", 380*2, 570*2 )
	back.x = centerX
	back.y = centerY
	if(w>h) then back.rotation = 90 end

	-- Create a label showing which scene this is
	local label = display.newEmbossedText( layers.content, "Main Menu", centerX, 40, native.systemFont, 60 )
	label:setFillColor( 0xCC/255, 1, 1  )
	local color = 
	{
	    highlight = { r=1, g=1, b=1 },
	    shadow = { r=0, g=1, b=0.3 }
	}
	label:setEmbossColor( color )

	-- Create some buttons for navigation
	--easyIFC:presetPush( layers.content, "default", centerX, bottom - 80, 100, 40, "Play", onPlay )
	--easyIFC:presetPush( layers.content, "default", centerX, bottom - 25, 100, 40, "Options", onOptions )

	--[[
	local inputButtons = {}

	local gap = 5
	local bw = 105
	local bh = 45
	local cols = 3
	local startX = centerX - bw * cols/2 + bw/2
	local startY = centerY - 100
	local curX = startX
	local curY = startY
	for i = 1, #inputStyles do
		local tmp = easyIFC:presetRadio( layers.inputButtons, "default", curX, curY, bw - gap, bh - gap, inputStyles[i], onChooseInputStyle, { labelSize = 10 } )
		tmp.styleNum = i
		--inputButtons[#inputButtons+1]		
		curX = curX + bw
		if( i % cols == 0 ) then
			curX = startX
			curY = curY + bh
		end
	end
	layers.inputButtons[1]:toggle( )

	local tmp = easyIFC:presetPush( layers.content, "default", centerX, centerY, 100, 40, "Lunar Lander", onGame )
	tmp.game = "lander"
	tmp.inputStyle = "twoTouch"

	local tmp = easyIFC:presetPush( layers.content, "default", centerX, centerY + 140, 100, 40, "Asteroids", onGame )
	tmp.game = "asteroids"
	tmp.inputStyle = "twoTouch"

	local tmp = easyIFC:presetPush( layers.content, "default", centerX, centerY + 180, 100, 40, "Joust", onGame )
	tmp.game = "joust"
	tmp.inputStyle = "twoTouch"
	--]]

	local games = { 
		{ "lander", "twoTouch" }, 
		{ "asteroids", "twoTouch" }, 
		{ "twinstick", "twoStick" }, 
		{ "recoil", "twoStick" }, 
	}
	local inputButtons = {}

	local gap = 5
	local bw = 105
	local bh = 45
	local cols = 3
	local startX = centerX - bw * cols/2 + bw/2
	local startY = centerY - 100
	local curX = startX
	local curY = startY

	local tmp 
	for i = 1, #games do
		tmp = easyIFC:presetPush( layers.inputButtons, "default", curX, curY, bw - gap, bh - gap, games[i][1], onGame, { labelSize = 10 } )
		tmp.inputStyle = games[i][2]
		tmp.game = games[i][1]
		--inputButtons[#inputButtons+1]		
		curX = curX + bw
		if( i % cols == 0 ) then
			curX = startX
			curY = curY + bh
		end
	end
	timer.performWithDelay( 1, function() tmp:toggle() end )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onPlay = function ( event ) 
	local options =
	{
		effect = "fromBottom", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			inputStyle = selectedInputStyle, 
			arg2 = 0
		}
	}
	composer.gotoScene( "ifc.playGUI", options  )	
	return true
end

onGame = function ( event ) 
	local options = 
	{ 
		effect = "fromBottom", 
		time = 500, 
		params = {
			inputStyle 	= event.target.inputStyle,
			game 		= event.target.game

		} 
	}
	composer.gotoScene( "ifc.playGUI", options  )	
	return true
end

onOptions = function ( event ) 
	local options =
	{
		isModal = true, -- Don't let touches leak through
		effect = "fromTop", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.showOverlay( "ifc.optionsOverlay", options  )	
	return true
end

onChooseInputStyle = function( event )
	local target = event.target
	selectedInputStyle = inputStyles[target.styleNum]
	print(selectedInputStyle)
end

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end
function scene:hide( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willExit( event )
	elseif( willDid == "did" ) then
		self:didExit( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
