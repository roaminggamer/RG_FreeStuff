class = require 'scripts.30log'
require "scripts.pushButtonClass"


ImagePushButton = PushButton:extends()
ImagePushButton.__name = 'ImagePushButton'
ImagePushButton.selFill = {1,1,1,1}
ImagePushButton.unselFill = {1,1,1,1}
ImagePushButton.strokeWidth = 0

function ImagePushButton:draw( group, x, y, labelText, listener, params)	
  	-- Build the button parts from display object(s)
  	--
	self.unselRect = display.newImageRect( group, params.unselImg, self.width, self.height )
	self.unselRect.x = self.x
	self.unselRect.y = self.y
	self.unselRect:setFillColor( unpack(self.unselFill) )
	self.unselRect:setStrokeColor( unpack(self.unselStroke) )
	self.unselRect.strokeWidth = self.strokeWidth

	self.selRect = display.newImageRect( group, params.selImg, self.width, self.height )
	self.selRect.x = self.x
	self.selRect.y = self.y
	self.selRect:setFillColor( unpack(self.selFill) )
	self.selRect:setStrokeColor( unpack(self.selStroke) )
	self.selRect.strokeWidth = self.strokeWidth

	self.label = display.newText( group, self.labelText, self.x, self.y, self.labelFont, self.labelSize )
	self.label:setFillColor( unpack( self.labelColor) )

	self.unselRect.isHitTestable = true	
	self.selRect.isVisible = false
	self.unselRect:addEventListener( "touch", self )
end

