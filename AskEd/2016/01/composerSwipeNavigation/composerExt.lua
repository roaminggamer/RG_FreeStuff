-- =============================================================
-- composerExt.lua - Compose swipe navigation extension module
-- =============================================================
local composer = require "composer"

-- Locals
local isEnabled = false
local sceneLinks = {}

local alwaysTo

local maxVertical = 20
local swipeDist = 10
local mode = "none"
local nextOptions = { effect = "slideLeft", time = 500, }
local prevOptions = { effect = "slideRight", time = 500, }


-- Useful values and forward declarations
local w 				= display.contentWidth
local h 				= display.contentHeight
local centerX 			= display.contentCenterX
local centerY 			= display.contentCenterY
local fullw				= display.actualContentWidth 
local fullh				= display.actualContentHeight
local unusedWidth		= fullw - w
local unusedHeight		= fullh - h
local deviceWidth		= math.floor((fullw/display.contentScaleX) + 0.5)
local deviceHeight 		= math.floor((fullh/display.contentScaleY) + 0.5)
local left				= 0 - unusedWidth/2
local top 				= 0 - unusedHeight/2
local right 			= w + unusedWidth/2
local bottom 			= h + unusedHeight/2
local orientation  		= ( w > h ) and "landscape"  or "portrait"
local isLandscape 		= ( w > h )
local isPortrait 		= ( h > w )

local mAbs = math.abs

-- Swiper Function Definitions
--
local function onTouch( self, event )	
	if(not isEnabled) then return false end
	if( self.lastTouchTime and 
		event.time == self.lastTouchTime and
		self.lastPhase == event.phase ) then return end
	local dx = event.x - event.xStart
	local adx = mAbs(dx)
	local dy = mAbs(event.y - event.yStart)

	if( event.phase == "began" ) then
		mode = "none"		
	elseif( event.phase == "moved" ) then
		if( mode == "none" and dy >= maxVertical ) then
			mode = "locked"
		elseif( mode == "none" and adx >= swipeDist ) then
			mode = (dx>0) and "left" or "right"
		end

	elseif( event.phase == "ended" or event.phase == "cancelled" ) then
		local sceneLink = sceneLinks[composer.getSceneName( "current" )]
		if( sceneLink ) then
			if( mode == "left" and sceneLink.prev ) then
				composer.gotoScene( sceneLink.prev, prevOptions )
			elseif( mode == "right" and sceneLink.next ) then
				composer.gotoScene( sceneLink.next, nextOptions )
			end
		end
		mode = "none"
	end
	self.lastTouchTime = event.time
	self.lastPhase = event.phase		
	return false
end

-- Create a swipe
function composer.createSwipe( group, params )
	local uniSwipe = (group == nil)
	group = group or display.currentStage
	params = params or {}

	local swiper = display.newRect( group, centerX, centerY, fullw, fullh )
	swiper.alpha = 0
	swiper.isHitTestable = true

	swiper.touch = onTouch
	swiper:addEventListener("touch")
	local to = params.alwaysTo or alwaysTo

	if( to and (to == "front" or to == "back" ) ) then
		swiper.enterFrame = function( self )		
			if(self and self.toFront and self.toBack) then
				if( to == "back" ) then
					self:toBack()
				else
					self:toFront()
				end				
			else
				Runtime:removeEventListener( "enterFrame", self )
			end
		end; Runtime:addEventListener( "enterFrame", swiper )
	end
	swiper.destroy = function( self )
		display.remove(self)
		isEnabled = false
	end
	swiper.finalize = function( self )
		Runtime:removeEventListener( "enterFrame", self )
		display.remove(self)
		isEnabled = false
	end; swiper:addEventListener( "finalize" )
	isEnabled = true
	return swiper
end

-- scenesList = { "scene1", "scene2", ... )
--
function composer.initSwipe( scenesList, params )	
	if( #scenesList < 2 ) then return end
	params = params or {}
	local loop = params.loop or false

	swipeDist = params.swipeDist or swipeDist
	prevOptions = params.prevOptions or prevOptions
	nextOptions = params.nextOptions or nextOptions
	alwaysTo 	= params.alwaysTo  

	for i = 1, #scenesList do
		local cur = scenesList[i]
		local curIndex = {}
		sceneLinks[cur] = curIndex
		
		if( i == 1 ) then
			curIndex.next = scenesList[i+1]
			if( loop ) then
				curIndex.prev = scenesList[#scenesList]
			end
		elseif( i == #scenesList ) then
			curIndex.prev = scenesList[i-1]
			if( loop ) then
				curIndex.next = scenesList[1]
			end
		else
			curIndex.prev = scenesList[i-1]
			curIndex.next = scenesList[i+1]
		end
	end
end

-- Enable/disable swiping
--
function composer.enableSwipe( enabled )
	isEnabled = enabled
end