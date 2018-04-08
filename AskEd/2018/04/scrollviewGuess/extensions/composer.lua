-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- =============================================================
-- composer.lua - Compose swipe navigation extension module
-- =============================================================
local composer = require "composer"


--[[  TEMPORARY USAGE NOTES
MAIN.LUA:

-- List scenes in order you want them linked
local sampleScenes = 
	{ 
		"scenes.apple",  
		"scenes.banana", 
		"scenes.cherry",
	}
composer.initSwipe( sampleScenes, 
					{ loop = true,
					  swipeDist = 10,
					  maxVertical = 20,
					  --nextOptions = { effect = "fromRight", time = 250, },
					  --prevOptions = { effect = "fromLeft", time = 250, },					
					  --alwaysTo = "front",
					  --alwaysTo = "back",
					} )

--local swiper = composer.createSwipe()
--display.remove(swiper)
composer.gotoScene( "scenes.apple" )


SCENES:
function scene:create( event )
	local sceneGroup = self.view
	...
	-- Create a swiper on this page ONLY
	local swiper = composer.createSwipe( sceneGroup, {alwaysTo = "front"} )
end

function scene:create( event )
	local sceneGroup = self.view
	...
	-- Create a swiper on this page ONLY
	local swiper = composer.createSwipe( sceneGroup )
	swiper:toBack()
end



]]

-- Locals
local isEnabled = false
local sceneLinks = {}

local alwaysTo

local maxVertical = 20
local swipeDist = 10
local mode = "none"
local nextOptions = { effect = "slideLeft", time = 500, }
local prevOptions = { effect = "slideRight", time = 500, }


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