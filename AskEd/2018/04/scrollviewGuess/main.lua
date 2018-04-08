-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
require "common"
-- Extensions from SSK2: https://roaminggamer.github.io/RGDocs/pages/SSK2/extensions/
require("extensions.display")
require("extensions.io")
require("extensions.math")
require("extensions.string")
require("extensions.table")
require("extensions.transition")
require("extensions.composer")
-- =====================================================
-- =====================================================

local fadeYDistance = 240 -- you had 120 I think

display.setDefault( "background", 245/255, 245/255, 245/255)
local widget = require("widget")
-- 
local scrollParent = display.newGroup()
local titleParent = display.newGroup()
titleParent.alpha = 0
--
local function scrollViewListener( event )
	--table.dump(event)
	--
	local phase = event.phase
	
	if( phase == "stopped" ) then
	end

	return true
end

local scrollView = widget.newScrollView({
		x = centerX,
		y = centerY,
		width = fullw,
		height = fullh,
		isBounceEnabled = false,
		horizontalScrollDisabled = true,
		backgroundColor = { 1, 0, 0, 0.3},
		listener = scrollViewListener
	})
local scrollChild = display.newGroup()
scrollView:insert(scrollChild)
scrollParent:insert( scrollView)

local title = display.newRect( titleParent, centerX, left, fullw, fullh*0.2)
title:setFillColor( 1, 1, 1 )

local baseX = scrollView.contentWidth*0.5
local baseWidth = scrollView.contentWidth*0.7
local baseHeight = 100
local scrollHeight = 0
local maxRectNum = 100
for i = 1, maxRectNum do 
	local base = display.newRect( scrollChild, baseX, (10+baseHeight*0.5)+(10+baseHeight)*(i-1), baseWidth, baseHeight)
	base:setFillColor( math.random(), math.random(), math.random())
	base:addEventListener("touch",
		function ( event )
			local phase = event.phase
			if ( phase == "moved" ) then
				scrollView:takeFocus(event)
			end
			return true
		end)
	if ( i == maxRectNum ) then
		scrollHeight = base.y+baseHeight*0.5+10
		scrollView:setScrollHeight(scrollHeight)
	end
end

function titleParent.enterFrame( self )
	-- https://roaminggamer.github.io/RGDocs/pages/SSK2/extensions/#display
	if( not display.isValid( self ) ) then return end
	if( not display.isValid( scrollView ) ) then return end
	--
	local x,y = scrollView:getContentPosition()
	--print( string.format( "titleParent.enterFrame() < %d, %d > ", x, y ) )
	if( y >= 0 ) then
		self.alpha = 0
		return
	end
	--
	local alpha = math.abs(y)/fadeYDistance
	--print(alpha)
	--
	self.alpha = (alpha >= 1) and 1 or alpha
end; Runtime:addEventListener("enterFrame", titleParent)

function titleParent.finalize( self )
	Runtime:removeEventListener( "enterFrame", self )
end

