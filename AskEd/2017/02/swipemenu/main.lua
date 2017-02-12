-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================

-- Test below:
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

local centerX 	= display.contentCenterX
local centerY 	= display.contentCenterY
local fullw 	= display.actualContentWidth
local fullh		= display.actualContentHeight
local left 		= centerX - fullw/2
local right 	= left + fullw
local top 		= centerY - fullh/2
local bottom 	= top + fullh

local scrollThreshold = 10
local resetColorOnScrolled = false
local snapRate = 600 -- pixels per second

local scrollW = fullw
local scrollH = fullh
local buttonW = fullw
local buttonH = math.floor(fullh/3)

local function isInBounds( obj, obj2 )
	if(not obj2) then return false end
	local bounds = obj2.contentBounds
	if( obj.x > bounds.xMax ) then return false end
	if( obj.x < bounds.xMin ) then return false end
	if( obj.y > bounds.yMax ) then return false end
	if( obj.y < bounds.yMin ) then return false end
	return true
end

local buttons = {}

local function listener( event )
	
	--[[
	for k,v in pairs( event ) do
		print(k,v)
	end
	print("-------------------------")
	--]]

	if( event.phase == "began" ) then
		event.target.scrolled = false
		for i = 1, #buttons do			
			if( isInBounds( event, buttons[i] ) ) then
				buttons[i]:setFillColor(0.5, 0.8, 0.5)
			else
				buttons[i]:setFillColor(0.8, 0.5, 0.5)
			end
		end
	elseif(event.phase == "ended" ) then
		event.target:realign()

		for i = 1, #buttons do			
			buttons[i]:setFillColor(0.8, 0.5, 0.5)
		end

		-- Is it a click?
		if( not event.target.scrolled ) then
			local button
			for i = 1, #buttons do
				if( isInBounds( event, buttons[i] ) ) then
					button = buttons[i]
				end
			end
			if( button ) then
				button:clickAction()
				button:setFillColor(0.5,1,1)
				timer.performWithDelay( 333, function() button:setFillColor(0.8,0.5,0.5) end )
			end
		end

	elseif(event.phase == "moved" ) then

		-- Update to 'scrolled' if drag passes threshold
		local lastState = event.target.scrolled
		event.target.scrolled = event.target.scrolled or (math.abs(event.y-event.yStart) >= scrollThreshold )

		-- If state changed, recolor all buttons to 'off'
		if( resetColorOnScrolled and lastState ~= event.target.scrolled ) then
			for i = 1, #buttons do			
				buttons[i]:setFillColor(0.8, 0.5, 0.5)
			end
		end
	end
end


local widget = require "widget"

local options = 
{
	x = centerX,
	y = centerY,
	width = fullw,
	height = fullh,
	backgroundColor = { 0.8, 0.8, 0.8 },
	hideScrollBar = true,
	listener = listener,
}

local menu = widget.newScrollView( options )

-- This function make sure the buttons align nicely to the top edge
function menu.realign(self)
	local minY = -self:getView().contentHeight + 3 * buttonH
	local x,y = self:getContentPosition()

	if( y <= minY ) then 
		print( "Skipping")
	elseif( y >= 0 ) then 
		print("Skipping")
	else
		
		local dy = y
		local count = 0
		local toY
		while(dy < 0) do
			count = count + 1
			dy = dy + buttonH
		end

		if( dy > buttonH/2 ) then
			toY = y + (buttonH-dy)
		else
			toY = y + (buttonH-dy) - buttonH
		end

		local distance = math.abs(y-toY)
		print("Realign it" , buttonH, dy, y, count, toY, distance )
		self:scrollToPosition( { y = toY, time = 1000 *  distance/snapRate })
	end

end

for i = 1, 6 do
	local button = display.newRect( buttonW/2, (i-0.5) * buttonH, buttonW-2, buttonH-2 )
	menu:insert(button)
	button:setFillColor(0.8, 0.5, 0.5)
	button:setStrokeColor(0)
	button.strokeWidth = 2
	buttons[#buttons+1] = button
	button.label = display.newText( i, button.x, button.y, native.systemFont, 20 )
	button.label:setFillColor(0)
	menu:insert(button.label)
	
	button.id = i

	function button.clickAction( self )
		print("Clicked button ", self.id )
		-- Do click work here
	end

end