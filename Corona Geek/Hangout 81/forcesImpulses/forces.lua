-- =============================================================
-- forces.lua
-- =============================================================
local builders = require "scripts.builders"
local createPad 	= builders.createPad
local createShip 	= builders.createShip
local createYinYang = builders.createYinYang

local math2d 		= require "ssk.RGMath2D"

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

	local tmp2 = display.newText( "<0,-25> <0,-30>", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	ship.enterFrame = function( self )
		local marker1 = self:getMarker(1)
		self:applyForce( 0, -25, marker1.x, marker1.y )

		local marker2 = self:getMarker(2)
		self:applyForce( 0, -30, marker2.x, marker2.y )
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
--    Example 5 - Two unequal forces at bottom and offset equally about y-axis (Applied Every Frame)
--                Modified so that forces always thrust in direction ship is pointing.
-- ==
local function example5()
	local ship = createShip( 295, 280, { x = -10, y = 20 }, { x = 10, y = 20 } )
	local pad = createPad( ship.x, ship.y + 60, _BRIGHTORANGE_, ship )

	local tmp = display.newText( "Dual NOT Equal Facing", 0, 0, native.systemFontBold, 7 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "<0,-25> <0,-30>", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	ship.enterFrame = function( self )

		local force1 = math2d.angle2Vector( self.rotation, true )
		local force2 = math2d.angle2Vector( self.rotation, true )

		force1 = math2d.scale( force1, 25 )
		force2 = math2d.scale( force2, 30 )

		local marker1 = self:getMarker(1)
		self:applyForce( force1.x, force1.y, marker1.x, marker1.y )

		local marker2 = self:getMarker(2)
		self:applyForce( force2.x, force2.y, marker2.x, marker2.y )
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
--    Example 6 - Mount and Apply Offset  Force
-- ==
local function example6()
	local yinyang = createYinYang( 360, 280, { x = -30, y = 0 } )
	local pad = createPad( yinyang.x, yinyang.y + 60, _CYAN_, yinyang )

	physics.newJoint( "pivot", yinyang, pad, yinyang.x, yinyang.y )

	local tmp = display.newText( "Pivot + Force", 0, 0, native.systemFontBold, 8 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "<0,-20>", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	yinyang.enterFrame = function( self )
		local marker1 = self:getMarker(1)
		self:applyForce( 0, -20, marker1.x, marker1.y )
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
--    Example 7 - Mount and Apply Offset Facing Force
-- ==
local function example7()
	local yinyang = createYinYang( 425, 280, { x = -30, y = 0 } )
	local pad = createPad( yinyang.x, yinyang.y + 60, _WHITE_, yinyang )

	physics.newJoint( "pivot", yinyang, pad, yinyang.x, yinyang.y )

	local tmp = display.newText( "Pivot + Facing Force", 0, 0, native.systemFontBold, 7 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "(20)", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	yinyang.enterFrame = function( self )
		local force1 = math2d.angle2Vector( self.rotation, true )	
		force1 = math2d.scale( force1, 20 )

		print(force1.x, force1.y)
		
		local marker1 = self:getMarker(1)
		self:applyForce( force1.x, force1.y, marker1.x, marker1.y )
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
example5()
example6()
example7()

