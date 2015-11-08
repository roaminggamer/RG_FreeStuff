-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- nswers to interesting Corona Forums Questions
-- =============================================================
--
-- Hey!  Why are you reading this?  This is a custom menu for the kit
-- Not an answer!  Go to the answers :)
--
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local override 		= require "override"
----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local layers
local curMenu = 1
local buttonsPerMenu = 8
--local autoRun = 1

local answers = 
{
	{ "enterFrameDelta", 	false, false, "http://forums.coronalabs.com/topic/56542-why-enterframe-delta-time-so-difference", "GET_LINK" },
	{ "spinningArrow", 		false, false, "http://forums.coronalabs.com/topic/56622-how-to-implement-a-spinning-arrow-that-slows-down", "GET_LINK" },
	{ "dustTrail", 			true, false, "http://forums.coronalabs.com/topic/56674-i-need-help-to-get-dust-emitter-for-runner-character", "GET_LINK" },
	{ "tiltBall", 			false, false, "http://forums.coronalabs.com/topic/56748-roll-around-marble-game-using-corona", "GET_LINK" },
	{ "dollClothes", 		false, false, "http://forums.coronalabs.com/topic/56834-changing-the-attachment-clothes-for-a-character", "GET_LINK" },
	{ "mRand", 				false, false, "http://forums.coronalabs.com/topic/56844-mrand-question", "GET_LINK" },
	{ "scaledDragging", 	false, false, "http://forums.coronalabs.com/topic/56883-problem-dragging-object-with-display-scaled", "GET_LINK" },
	{ "fallingObjects", 	false, false, "http://forums.coronalabs.com/topic/56918-how-do-i-make-a-objects-randomly-fall-from-top-of-the-screen", "GET_LINK" },
	{ "returnHome", 		false, false, "http://forums.coronalabs.com/topic/56945-how-do-i-make-an-object-return-to-original-position", "GET_LINK" },
	{ "followTheLeader", 	true, false, "http://forums.coronalabs.com/topic/56964-multiple-transition-on-the-same-time", "GET_LINK" },
	{ "balanceBeam", 		true, false, "http://forums.coronalabs.com/topic/56992-does-anyone-know-to-how-do-a-beam-balance-using-physics", "GET_LINK" },

}

-- Forward Declarations


-- Useful Localizations
-- SSK
--
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local newAngleLine 	= ssk.display.newAngleLine
local easyIFC   	= ssk.easyIFC
local isInBounds    = ssk.easyIFC.isInBounds
local persist 		= ssk.persist
local isValid 		= display.isValid
local easyFlyIn 	= easyIFC.easyFlyIn

-- Corona & Lua
--
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
	
	local maxMenus = 1
	local menuPages = {}
	menuPages[maxMenus] = "menu" .. 1 
	for i = 1, #answers do
		if ( i % buttonsPerMenu == 0 ) then 
			maxMenus = maxMenus + 1
			menuPages[maxMenus] = "menu" .. maxMenus
		end
	end
	
	layers = ssk.display.quickLayers( sceneGroup, "underlay", "content", "menu",  menuPages, "overlay" )

	local function showCurrentMenu()
		for i = 1, #menuPages do
			local layerName = menuPages[i]
			layers[layerName].isVisible = false
		end

		layers["menu" .. curMenu].isVisible = true
	end
	showCurrentMenu()

	-- Create a simple background
	local back = newImageRect( layers.underlay, centerX, centerY, 
		                       "images/paper_bkg.png",
		                       { w = 320, h = 480, rotation = (w>h) and 90 or 0, scale = 2.25 } )

	-- Create a basic label
	local labelColor = hexcolor("#DAA520")
	--local msg = "(" .. details.questions .. ") Questions & Answers - Set #" .. details.installment
	local msg = string.format("%s %d", details.month, details.year)
	local tmp = easyIFC:quickLabel( layers.content, msg, centerX, top + 50, gameFont2, 42, labelColor )
	local tmp = easyIFC:quickLabel( layers.content, msg, tmp.x + 1, tmp.y + 1, gameFont2, 42, _K_ )


	--local function compare(a,b)
		--return a[3] > b[3]
	--end
	--table.sort(answers,compare)

	local onPress = function( event )
		local runExample = _G.require
		--print(answers[event.target.num][1])
		override.doIt( "answers/" .. answers[event.target.num][1]  )
		runExample( "answers." .. answers[event.target.num][1] .. ".main" )
		layers.x = 100000
	end
	local onPress2 = function( event )
		system.openURL( answers[event.target.num][4] )
	end
	local onPress3 = function( event )
		system.openURL( answers[event.target.num][5] )
	end

	-- Create Examples Menu
	local bh = 45
	local bw1 = 850
	local bw2 = 60
	local bw3 = 60
	local startY = 95 + bh/2 
	local x1 = centerX - (bw2 + bw3)/2  + 20
	local x2 = x1 + bw1/2 + bw2/2 + 10
	local x3 = x2 + bw2/2 + bw3/2 + 10
	local curY 	= startY
	local dY = bh + 2
	local insertMenu = 1
	

	for i = 1, #answers do
		local insertLayer = layers["menu" .. insertMenu ]
		local str = answers[i][4]
		local first = str:find("%-")
		local labelText = str:sub(first+1)
		labelText = labelText:gsub( "%-", " " )
		labelText = labelText:first_upper()

		local goB = easyIFC:presetPush( insertLayer, "gel_4_1", x1, curY, bw1, bh, "  #" .. i .. " - " .. labelText, onPress, { labelHorizAlign = "left", labelSize = 14, labelColor = _Y_, labelOffset = { 0, 0 } } )
		goB.num = i

		if( goB.myLabel.contentWidth > (bw1 - 80)) then
			local scale = (bw1 - 80) / goB.myLabel.contentWidth
			goB.myLabel:scale(scale, scale)
		end

		if( answers[i][1] == "FOLDER" ) then goB:disable() end

		local forumB = easyIFC:presetPush( insertLayer, "gel_5_2", x2, curY, bw2, bh, "Forum", onPress2, { labelSize = 12, labelOffset = { 0, 2 }  } )
		forumB.num = i
		if( string.len(answers[i][4]) == 0 ) then
			forumB:disable()
		end

		--[[
		local presetName = (answers[i][3]) and "gel_10_5" or "gel_7_1"
		local msg = (answers[i][3]) and "Get It!" or "Buy It!"
		msg = "Get It!"		

		local getB = easyIFC:presetPush( insertLayer, presetName, x3, curY, bw3, bh, msg, onPress3, { labelSize = 12, labelColor = _K_, labelOffset = { 0, 2 }  } )
		getB.num = i
		--]]

		if(answers[i][2]) then
			newImageRect( insertLayer, goB.x + bw1/2 - 5, goB.y - bh/2 + 2, "images/SSKCorona.png", { w = 188, h = 42, scale = 0.5, anchorX = 1, anchorY = 0 } )
		end
		
		if( answers[i][1] ~= "FOLDER" ) then
			local folderLabel = easyIFC:quickLabel( insertLayer, "/" .. answers[i][1], goB.x + bw1/2 - 10, goB.y + bh/3 - 2, gameFont2, 12, _W_, 1 )
		end

		 

		curY = curY + dY

		if ( i % buttonsPerMenu == 0 ) then 
			insertMenu = insertMenu + 1
			curY = startY
		end
	end

	-- Current Menu Page
	local currentPage = easyIFC:quickLabel( layers.content, "Page: " .. curMenu .. " of " .. maxMenus , centerX - 40, bottom - 110, gameFont2, 22, _W_ )
	local function onNext( event )
		curMenu = curMenu + 1
		if( curMenu > maxMenus ) then 
			curMenu = 1
		end
		showCurrentMenu()
		currentPage.text = "Page: " .. curMenu .. " of " .. maxMenus
	end
	local function onPrev( event )
		curMenu = curMenu - 1
		if( curMenu < 1 ) then 
			curMenu = maxMenus
		end
		showCurrentMenu()
		currentPage.text = "Page: " .. curMenu .. " of " .. maxMenus
	end

	local prevB = easyIFC:presetPush( layers.content, "gel_5_4", currentPage.x - 140, currentPage.y, bw2, bh, "<<", onPrev, { labelSize = 22, labelOffset = { 0, 2 }, labelColor = _O_  } )	
	local nextB = easyIFC:presetPush( layers.content, "gel_5_4", currentPage.x + 140, currentPage.y, bw2, bh, ">>", onNext, { labelSize = 22, labelOffset = { 0, 2 }, labelColor = _O_  } )	


	-- Note about Corona
	local tmp = easyIFC:quickLabel( layers.content, "Answers marked with: ", left + 50, bottom - 50, gameFont2, 18, _W_, 0 )
	local tmp = newImageRect( layers.content, tmp.x + tmp.contentWidth - 10, tmp.y-4, "images/SSKCorona.png", { w = 188, h = 42, scale = 0.75, anchorX = 0 } )
	local tmp = easyIFC:quickLabel( layers.content, "use the **FREE** SSK Library.", tmp.x + tmp.contentWidth + 0, tmp.y+4, gameFont2, 18, _W_, 0 )
	local function onSSK(event)
		system.openURL("http://github.com/roaminggamer/SSKCorona/")
	end
	local getB = easyIFC:presetPush( layers.content, "gel_10_5", tmp.x + tmp.contentWidth + bw3/2 + 10, tmp.y, bw3 + 5, bh- 5, "Get It!", onSSK, { labelSize = 12, labelColor = _K_, labelOffset = { 0, 2 }  } )
	
	-- If autoRun is specified, run the example
	--
	if( autoRun ) then
		local runExample = _G.require
		override.doIt( "answers/" .. answers[autoRun][1]  )
		runExample( "answers." .. answers[autoRun][1] .. ".main" )
		layers.x = 100000
	end

end

local toRun = ""
local function ON_KEY( event )
	if( event.phase == "up" ) then
		local key = event.descriptor
		if( tonumber(key) ) then
			toRun = toRun .. tostring(key)
		
		elseif( key == "enter" ) then
			local runExample = _G.require
			override.doIt( "answers/" .. answers[tonumber(toRun)][1]  )
			runExample( "answers." .. answers[tonumber(toRun)][1] .. ".main" )
			layers.x = 100000
		elseif( key == "deleteBack" ) then
			toRun = ""
		end
	end
end; listen( "ON_KEY", ON_KEY )



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
