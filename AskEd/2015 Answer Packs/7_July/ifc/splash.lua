-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local timerHandle
local back
local waitTime = 12000

-- Forward Declarations
local onMainMenu


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

	local layers = ssk.display.quickLayers( sceneGroup, "underlay", "content", "overlay" )

	-- Create a simple background
	back = newImageRect( layers.underlay, centerX, centerY, 
		                       "images/paper_bkg.png",
		                       { w = 768, h = 1028, rotation = (w>h) and 90 or 0, scale = 1.5 } )

	-- Create a basic label
	local labelColor = hexcolor("#DAA520")
	local phrase = "Weekly Answers"
	local tmp = easyIFC:quickLabel( layers.content, phrase, centerX, centerY - 110, gameFont2, 42*2, labelColor )
	local tmp = easyIFC:quickLabel( layers.content, phrase, tmp.x + 1, tmp.y + 1, gameFont2, 42*2, _K_ )
	
	--local phrase = "Easy Answers"
	--local tmp = easyIFC:quickLabel( layers.content, phrase, centerX, tmp.y + 90, gameFont2, 22*2, labelColor )
	--local tmp = easyIFC:quickLabel( layers.content, phrase, tmp.x + 1, tmp.y + 1, gameFont2, 22*2, _K_ )

	local phrase = "To Interesting Forums Questions"
	local tmp = easyIFC:quickLabel( layers.content, phrase, centerX, tmp.y + 90, gameFont2, 18*2, labelColor )
	local tmp = easyIFC:quickLabel( layers.content, phrase, tmp.x + 1, tmp.y + 1, gameFont2, 18*2, _K_ )

	local msg = string.format("Week %d - %d", details.week, details.year)
	local tmp = easyIFC:quickLabel( layers.content, msg, centerX, centerY + 100, gameFont2, 22*2, labelColor )
	local tmp = easyIFC:quickLabel( layers.content, msg, tmp.x + 1, tmp.y + 1, gameFont2, 22*2, _K_ )

	local msg =  "( " .. details.questions .. " questions and answers )"
	local tmp = easyIFC:quickLabel( layers.content, msg, centerX, tmp.y + 40*2, gameFont2, 22*2, labelColor )
	local tmp = easyIFC:quickLabel( layers.content, msg, tmp.x + 1, tmp.y + 1, gameFont2, 22*2, _K_ )


	-- If user touches back, go to main menu early.
	--
	back.touch = function( self, event )
		if(event.phase == "ended") then
			onMainMenu()
		end
		return true
	end
	back:addEventListener( "touch" )	
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

	-- Automatically Go to main menu in 2 seconds 
	--
	timerHandle = timer.performWithDelay( waitTime, onMainMenu )
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
onMainMenu = function( event )
	if( event and event.target ) then print( "Pushed button labeled: " .. event.target:getText() ) end

	if( timerHandle) then
		timer.cancel(timerHandle)
		timerHandle = nil 
	end

	local options =
	{
		effect = "fromRight", -- See list here: http://docs.coronalabs.com/daily/api/library/composer/gotoScene.html
		time = 500,
		params =
		{
			arg1 = "value", 
			arg2 = 0
		}
	}
	composer.gotoScene( "ifc.mainMenu", options  )	
	--]]
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
