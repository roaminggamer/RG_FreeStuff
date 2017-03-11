local menu = {}


local function onTouch( self, event )
	if( event.phase == "ended" ) then
		if( self.action ) then
			self:action( )
		end
		return true
	end
	return true
end

function menu.create ( group, x, y, params )
	group = group or display.currentStage
	x = x or centerX
	y = y or centerY
	params = params or {}
	params.size = params.size or 300
	params.style = params.style or "right" -- "right", "left", "full"
	params.offsetAngle = params.offsetAngle or 0
	params.offsetDist = params.offsetDist or 0

	local tray = display.newImageRect( group, "images/ring.png", params.size, params.size )	
	tray.x = x
	tray.y = y
	tray.group = display.newGroup()
	tray.group.x  = x
	tray.group.y = y
	group:insert( tray.group )

	local buttons = {}

	function tray.addButton( self, options )
		options = options or {}
		options.img = options.img or "images/blockA.png"
		options.size = options.size or 40

		
		local button = display.newImageRect( self.group, options.img, options.size, options.size )	
		buttons[#buttons+1] = button

		button.action = options.action

		button.touch = onTouch 
		button:addEventListener( "touch" )
	end

	function tray.draw()

		local degreesPerButton = 360 / #buttons

		if( params.style ~= "full" ) then
			degreesPerButton = degreesPerButton/2
		end

		if( params.style == "full" or params.style == "right" ) then
			local angle = 0 + params.offsetAngle

			for i = 1, #buttons do
				local vec = ssk.math2d.angle2Vector( angle, true )
				vec = ssk.math2d.scale( vec, params.size/2 + params.offsetDist )
				buttons[i].x = vec.x
				buttons[i].y = vec.y
				angle = angle + degreesPerButton
			end

		elseif( params.style == "left" ) then

			local angle = -180 + params.offsetAngle

			for i = 1, #buttons do
				local vec = ssk.math2d.angle2Vector( angle, true )
				vec = ssk.math2d.scale( vec, params.size/2 + params.offsetDist )
				buttons[i].x = vec.x
				buttons[i].y = vec.y
				angle = angle + degreesPerButton
			end
		end		
	end

	return tray
end


return menu