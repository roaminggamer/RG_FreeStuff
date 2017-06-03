
local centerX  = display.contentCenterX
local centerY  = display.contentCenterY
local fullw 	= display.actualContentWidth
local fullh 	= display.actualContentHeight
local left 		= centerX - fullw/2
local right 	= left + fullw
local top 		= centerY - fullh/2
local bottom 	= top + fullh

local m  = {}

function m.createLeftDock( group, y, width, height, startOpen )
	group = group or display.currentStage
	y = y or centerY
	width = width or math.floor( fullw/4 )
	height = height or fullh

	if(startOpen == nil) then
		startOpen = true
	end

	local dock = display.newContainer( width, height )
	group:insert(dock)
	dock.x = left - width/2
	dock.y = y

	dock.group = display.newGroup( )
	dock:insert(dock.group)
	dock.group.x = -width/2
	dock.group.y = -height/2

	local xClosed 	= dock.x
	local xOpen  	= dock.x + width

	function dock.show( self, time )
		transition.cancel( self )
		if( not time or time < 1 ) then
			self.x = xOpen
		else
			transition.to( self, { x = xOpen, time = time, transition = easing.outCirc } )
		end
	end

	function dock.hide( self, time )
		transition.cancel( self )
		if( not time or time < 1 ) then
			self.x = xClosed
		else
			transition.to( self, { x = xClosed, time = time, transition = easing.inCirc } )
		end
	end

	if( startOpen ) then 
		dock:show()
	end

	return dock	

end

return m
