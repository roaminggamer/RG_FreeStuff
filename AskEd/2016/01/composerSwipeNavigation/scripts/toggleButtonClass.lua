class = require 'scripts.30log'
require "scripts.pushButtonClass"


ToggleButton = PushButton:extends()
ToggleButton.__name = 'ToggleButton'

function ToggleButton:touch( event )
	local target = event.target 
	local id 	 = event.id
	local phase  = event.phase
	if( phase == "began" ) then
		display.currentStage:setFocus( target, id )
		self.isFocus 				= true
		self.initiallySelected 		= self.selected
		self.selected 				= true
		self.unselRect.isVisible 	= not self.unselRect.isVisible
		self.selRect.isVisible 		= not self.selRect.isVisible

	
	elseif( self.isFocus ) then
		local bounds = target.stageBounds
		local x,y = event.x, event.y
		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

		if( isWithinBounds ) then
			self.unselRect.isVisible 	= self.initiallySelected
			self.selRect.isVisible 		= not self.initiallySelected
		else
			self.unselRect.isVisible 	= not self.initiallySelected
			self.selRect.isVisible 		= self.initiallySelected
		end

		if( phase == "moved" ) then
			-- Do nothing for push-button
		elseif( phase == "ended" or phase == cancelled ) then
			display.currentStage:setFocus( target, nil )
			self.isFocus 				= nil
			if( isWithinBounds and self.listener ) then
				self.selected 				= not self.initiallySelected
				self.unselRect.isVisible 	= self.initiallySelected
				self.selRect.isVisible 		= not self.initiallySelected
				self:listener( event )
			else
				self.selected 				= self.initiallySelected
				self.unselRect.isVisible 	= not self.initiallySelected
				self.selRect.isVisible 		= self.initiallySelected
			end
		end
	end
	return true
end

