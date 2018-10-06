io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================

local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = centerX
back.y = centerY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end

local scroller = ssk.vScroller.new( nil, centerX, centerY,
	         								{ w = 400, h = 600,
	         								  backFill = hexcolor("#DDDDDD") } )


-- ======================================================
-- Tap Replacement Example
-- ======================================================
local multiTapInterval = 333
local function fakeTap( self, event )
	-- Only do work in "ended" phase
	if( event.phase == "ended" ) then
		-- Assign taps if not set yet
		self.taps = self.taps or 1

		-- Detect 'dragged' and show it
		if( event.dragged ) then 
			self.label.text = "dragged"
			self.taps = 0
			return false 
		end

		-- Update label to show consecutive taps occuring
		-- in less time than 'multiTapInterval'

		local dt = event.time - (self.lastTapTime or -10000 )
		self.lastTapTime = event.time
		print( event.time, dt )
		if( dt < multiTapInterval ) then 
			self.taps = self.taps + 1
		else
			self.taps = 1
		end
		self.label.text = self.taps

	end
	return false
end

local tmp = display.newRect( 200, 60, 100, 100 )
tmp:setFillColor(unpack(_O_))
scroller:insert(tmp)
tmp.label = display.newText("0", tmp.x, tmp.y)
scroller:insert(tmp.label)
scroller:addTouch( tmp, fakeTap )



-- ======================================================
-- Basic Button Example
-- ======================================================
local isInBounds    	= ssk.easyIFC.isInBounds
local function onPush( self, event )
	if( event.phase == "began" ) then
		self:setFillColor(unpack(_LIGHTGREY_))
	
	elseif( event.phase == "moved" ) then
		if( isInBounds(event,self) ) then
			self:setFillColor(unpack(_LIGHTGREY_))
		
		else
			self:setFillColor(unpack(_DARKGREY_))
		end
	
	elseif( event.phase == "ended" ) then
		self:setFillColor(unpack(_DARKGREY_))
		
		-- Do some action if the button is released, the touch
		-- is still over the button and no drag of the scroller 
		-- happened
		if( isInBounds(event,self) and not event.dragged ) then
			self:setFillColor(unpack(_CYAN_))
			timer.performWithDelay( 100, 
				function()
					self:setFillColor(unpack(_DARKGREY_))
				end )
			
		end
	end
	return false
end

local tmp = display.newRect( 200, 220, 100, 100 )
tmp:setFillColor(unpack(_DARKGREY_))
scroller:insert(tmp)
scroller:addTouch( tmp, onPush )
