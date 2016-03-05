class = require 'scripts.30log'

PushButton = class 
	{ 
		x 			= display.contentCenterX,
		y 			= display.contentCenterY, 
		width 		= 100, 
		height 		= 40, 
		selFill 	= { 0.8, 0.8, 0.8 }, 
		unselFill 	= { 0.5, 0.5, 0.5 }, 
		selStroke 	= { 1, 1, 1 },
		unselStroke = { 0.8, 0.8, 0.8 },
		strokeWidth = 2,
		labelColor 	= { 0, 0, 0 },
		labelSize 	= 14,
		labelFont 	= native.systemFontBold,
		__name = 'PushButton'
	}

function PushButton:toggle( skipCall )	
	self.selected = not self.selected
	self.unselRect.isVisible = not self.selected
	self.selRect.isVisible = self.selected
	if(self.selected and self.listener and not skipCall ) then 
		self:listener( { target = self.unselRect, 
			             x = self.unselRect.x, 
			             y = self.unselRect.y,
			             timer = system.getTimer(),
			             phase = "ended" } )

	end
end

function PushButton:isSelected()
	return (self.selected == true)
end

function PushButton:getText()
	return (self.labelText)
end

function PushButton:setText( newText )
	self.labelText = newText
	self.label.text = newText
end

function PushButton:touch( event )
	local target = event.target 
	local id 	 = event.id
	local phase  = event.phase
	if( phase == "began" ) then
		display.currentStage:setFocus( target, id )
		self.isFocus 				= true
		self.selected 				= true
		self.unselRect.isVisible 	= false
		self.selRect.isVisible 		= true
	
	elseif( self.isFocus ) then
		local bounds = target.stageBounds
		local x,y = event.x, event.y
		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

		if( isWithinBounds ) then
			self.unselRect.isVisible 	= false
			self.selRect.isVisible 		= true
		else
			self.unselRect.isVisible 	= true
			self.selRect.isVisible 		= false
		end

		if( phase == "moved" ) then
			-- Do nothing for push-button
		elseif( phase == "ended" or phase == cancelled ) then
			display.currentStage:setFocus( target, nil )
			self.isFocus 				= nil
			self.selected 				= false
			self.unselRect.isVisible 	= true
			self.selRect.isVisible 		= false
			if( isWithinBounds and self.listener ) then
				self:listener( event )
			end
		end
	end
	return true
end

function PushButton:draw( group, x, y, labelText, listener, params)	
  	-- Build the button parts from display object(s)
  	--
	self.unselRect = display.newRect( group, self.x, self.y, self.width, self.height )
	self.unselRect:setFillColor( unpack(self.unselFill) )
	self.unselRect:setStrokeColor( unpack(self.unselStroke) )
	self.unselRect.strokeWidth = self.strokeWidth

	self.selRect = display.newRect( group, self.x, self.y, self.width, self.height )
	self.selRect:setFillColor( unpack(self.selFill) )
	self.selRect:setStrokeColor( unpack(self.selStroke) )
	self.selRect.strokeWidth = self.strokeWidth

	self.label = display.newText( group, self.labelText, self.x, self.y, self.labelFont, self.labelSize )
	self.label:setFillColor( unpack( self.labelColor) )

	self.unselRect.isHitTestable = true	
	self.selRect.isVisible = false
	self.unselRect:addEventListener( "touch", self )
end

function PushButton:__init( group, x, y, labelText, listener, params)	
	group 		= group or display.currentStage
	params  	= params or {}

	-- Save rest of parameters to class instance
	self.labelText 	= labelText or ""
	self.listener 	= listener or function() return false end
	self.x 			= x or self.x
	self.y 			= y or self.y

	-- Simply copy all params values onto this instance
	for k,v in pairs( params ) do
		self[k] = v
	end
	self:draw( group, x, y, labelText, listener, params )	
end

