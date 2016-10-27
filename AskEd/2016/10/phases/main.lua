io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- Include SSK Core (Features I just can't live without.)
require("ssk_core.globals.variables")
require("ssk_core.globals.functions")
require("ssk_core.extensions.display")
require("ssk_core.extensions.io")
require("ssk_core.extensions.math")
require("ssk_core.extensions.string")
require("ssk_core.extensions.table")
require("ssk_core.extensions.transition_color")

-- IGNORE ABOVE THIS LINE
-- =============================================
-- EXAMPLE BEGIN
-- =============================================

-- Looks like you're trying to detect a swipe(s)
--
-- One way to do that would be this:
--
local swipeDist = 40

local function swipeDetector( self, e )
	-- print("swipe",e.phase)
	if e.phase == "began" then

		self.isFocus = true 
		display.getCurrentStage():setFocus( self, e.id )

	elseif( self.isFocus) then
		if( self._swipeDetected == nil ) then
			local dx = e.x - e.xStart
			local dy = e.y - e.yStart

			if( dy < -swipeDist ) then
				self._swipeDetected = "up"
			elseif( dy > swipeDist ) then
				self._swipeDetected = "down"
			elseif( dx < -swipeDist ) then
				self._swipeDetected = "left"
			elseif( dx > swipeDist ) then
				self._swipeDetected = "right"
			end
		end
		
		if( e.phase == "ended" ) then
			self.isFocus = false 
			display.getCurrentStage():setFocus( self, nil )
			if(self._swipeDetected == nil) then
				-- Skip
				return true
			elseif( self._swipeDetected == "up" ) then
				print("Do up action here")
				self.y = self.y - swipeDist
         elseif( self._swipeDetected == "down" ) then
         	print("Do down action here")
         	self.y = self.y + swipeDist
         elseif( self._swipeDetected == "left" ) then
         	print("Do left action here")
         	self.x = self.x - swipeDist
         elseif( self._swipeDetected == "right" ) then
         	print("Do right action here")
         	self.x = self.x + swipeDist
			end
			self._swipeDetected = nil
		end
	end
	return true
end

local tmp = display.newRect( display.contentCenterX, display.contentCenterY, 40, 40 )
tmp.touch = swipeDetector
tmp:addEventListener( "touch" )