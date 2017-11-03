-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Play GUI
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local w = display.contentWidth
local h = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Forward Declarations
local example

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	example( sceneGroup )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willShow( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didShow( event )
	local sceneGroup = self.view
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
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

example = function( sceneGroup )

	--
	-- Run in simulated "Borderless 610 x 960 iPhone"
	--
	local fullw = display.actualContentWidth
	local fullh = display.actualContentHeight
	local centerX = display.contentCenterX
	local centerY = display.contentCenterY

	--
	-- This example explores any issues with bar
	-- 
	local group = display.newGroup()
	local group2 = display.newGroup()
	sceneGroup:insert(group)
	group:insert(group2)
	group2.x = centerX
	group2.y = centerY
	--
	local fbm = require "lib.fillbar_m"
	local bar = fbm.new( {
	  parent=group2,
	  x=0,
	  y=00, 
	  barprefix="runnerlife", 
	  useback = true,
	  maxval=1000
	})

	local width = bar.contentWidth
	local height = math.floor(1.5 * width)

	--
	local back = display.newRect( group2, 0, 0, width, height )
	back:setFillColor(0.25,0.25,0.25)
	back:toBack()
	-- align bar right at bottom of 'back'
	bar.y = back.y + math.ceil(back.contentHeight/2 - bar.contentHeight/2)
	--
	local tmp = display.newRect( group2, -width/2, -height/2, 10, 10  )
	tmp:setFillColor(1,0,0)
	tmp.anchorX = 0
	tmp.anchorY = 0
	--
	local tmp = display.newRect( group2, width/2, -height/2, 10, 10  )
	tmp:setFillColor(0,1,0)
	tmp.anchorX = 1
	tmp.anchorY = 0
	--
	local tmp = display.newRect( group2, width/2, height/2, 10, 10  )
	tmp:setFillColor(0,0,1)
	tmp.anchorX = 1
	tmp.anchorY = 1
	--
	local tmp = display.newRect( group2, -width/2, height/2, 10, 10  )
	tmp:setFillColor(1,1,0)
	tmp.anchorX = 0
	tmp.anchorY = 1

	--
	-- Scale up by factor of 2 after short delay
	local scaleFactor = fullw/width
	transition.to( group2, { delay = 0, time = 1000, 
		                     xScale = scaleFactor, yScale = scaleFactor })
end



---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willShow( event )
	elseif( willDid == "did" ) then
		self:didShow( event )
	end
end
function scene:hide( event )
	sceneGroup 	= self.view
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
