
local swapWH = false -- set to true to fix bug

-- BLUE Upper Left
local ul = display.newRect( 0, 0, 40, 40 )
ul:setStrokeColor(1,0,0)
ul:setFillColor(0,0,1)
ul.strokeWidth = 1
function ul.enterFrame( self )
	self.x = 21
	self.y = 21
end; Runtime:addEventListener( "enterFrame", ul )

-- GREEN Upper Right
local ur = display.newRect( 0, 0, 40, 40 )
ur:setStrokeColor(1,0,0)
ur:setFillColor(0,1,0)
ur.strokeWidth = 1
function ur.enterFrame( self )
	self.x = display.actualContentWidth - 21
	if( swapWH ) then
		self.x = display.actualContentHeight - 21
	end
	self.y = 21
end; Runtime:addEventListener( "enterFrame", ur )

-- YELLOW Lower Left
local ll = display.newRect( 0, 0, 40, 40 )
ll:setStrokeColor(1,0,0)
ll:setFillColor(1,1,0)
ll.strokeWidth = 1
function ll.enterFrame( self )
	self.x = 21
	self.y = display.actualContentHeight - 21
	if( swapWH ) then
		self.y = display.actualContentWidth - 21
	end
end; Runtime:addEventListener( "enterFrame", ll )

-- CYAN Lower Left
local lr = display.newRect( 0, 0, 40, 40 )
lr:setStrokeColor(1,0,0)
lr:setFillColor(0,1,1)
lr.strokeWidth = 1
function lr.enterFrame( self )
	self.x = display.actualContentWidth - 21
	self.y = display.actualContentHeight - 21
	if( swapWH ) then
		self.x = display.actualContentHeight - 21
		self.y = display.actualContentWidth - 21
	end


end; Runtime:addEventListener( "enterFrame", lr )