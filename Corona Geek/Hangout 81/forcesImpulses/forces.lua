-- =============================================================
-- forces.lua
-- =============================================================
local builders = require "scripts.builders"
local createPad 	= builders.createPad
local createShip 	= builders.createShip
local createYinYang = builders.createYinYang

local tmp = display.newText( "Forces", 0, 0, native.systemFontBold, 32 )
tmp.x = centerX 
tmp.y = 20

tmp:setFillColor( unpack( _CYAN_ ) )

-- ==
--    Example 1 - Single force in center (Applied Every Frame)
-- ==
local function example1()
	local ship = createShip( 35, 280, { x = 0, y = 0 } )
	local pad = createPad( ship.x, ship.y + 60, _PINK_, ship )

	local tmp = display.newText( "Single", 0, 0, native.systemFontBold, 8 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "<0,-100>", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	ship.enterFrame = function( self )
		local marker1 = self:getMarker(1)
		self:applyForce( 0, -100, marker1.x, marker1.y )
	end

	ship.touchAction = function( self, event )
		if( event.phase == "began" ) then
			Runtime:addEventListener( "enterFrame", ship )
		
		elseif( event.phase == "ended" ) then
			Runtime:removeEventListener( "enterFrame", ship )
		end
	end
end


-- ==
--    Example 2 - Two equal forces at bottom and offset equally about y-axis (Applied Every Frame)
-- ==
local function example2()
	local ship = createShip( 100, 280, { x = -10, y = 20 }, { x = 10, y = 20 } )
	local pad = createPad( ship.x, ship.y + 60, _GREEN_, ship )

	local tmp = display.newText( "Dual Equal", 0, 0, native.systemFontBold, 8 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "<0,-50>", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	ship.enterFrame = function( self )
		local marker1 = self:getMarker(1)
		self:applyForce( 0, -50, marker1.x, marker1.y )

		local marker2 = self:getMarker(2)
		self:applyForce( 0, -50, marker2.x, marker2.y )
	end

	ship.touchAction = function( self, event )
		if( event.phase == "began" ) then
			Runtime:addEventListener( "enterFrame", ship )
		
		elseif( event.phase == "ended" ) then
			Runtime:removeEventListener( "enterFrame", ship )
		end
	end
end

-- ==
--    Example 3 - Two unequal forces at bottom and offset equally about y-axis (Applied Every Frame)
-- ==
local function example3()
	local ship = createShip( 165, 280, { x = -10, y = 20 }, { x = 10, y = 20 } )
	local pad = createPad( ship.x, ship.y + 60, _YELLOW_, ship )


	local tmp = display.newText( "Dual NOT Equal", 0, 0, native.systemFontBold, 8 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "<0,-45> <0,-50>", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	ship.enterFrame = function( self )
		local marker1 = self:getMarker(1)
		self:applyForce( 0, -45, marker1.x, marker1.y )

		local marker2 = self:getMarker(2)
		self:applyForce( 0, -50, marker2.x, marker2.y )
	end

	ship.touchAction = function( self, event )
		if( event.phase == "began" ) then
			Runtime:addEventListener( "enterFrame", ship )
		
		elseif( event.phase == "ended" ) then
			Runtime:removeEventListener( "enterFrame", ship )
		end
	end
end


-- ==
--    Example 4 - Apply Torque
-- ==
local function example4()
	local yinyang = createYinYang( 230, 280)
	local pad = createPad( yinyang.x, yinyang.y + 60, _PURPLE_, yinyang )

	local tmp = display.newText( "Torque", 0, 0, native.systemFontBold, 8 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "(20)", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	yinyang.enterFrame = function( self )
		local marker1 = self:getMarker(1)
		self:applyTorque( 20 )
	end

	yinyang.touchAction = function( self, event )
		if( event.phase == "began" ) then
			Runtime:addEventListener( "enterFrame", yinyang )
		
		elseif( event.phase == "ended" ) then
			Runtime:removeEventListener( "enterFrame", yinyang )
		end
	end
end


-- ==
--    Run Examples
-- ==

example1()
example2()
example3()
example4()
--example5()
--example6()
--example7()

