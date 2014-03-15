-- =============================================================
-- forces.lua
-- =============================================================
local builders = require "scripts.builders"
local createPad 	= builders.createPad
local createShip 	= builders.createShip
local createYinYang = builders.createYinYang

local math2d 		= require "ssk.RGMath2D"

local tmp = display.newText( "Impulses", 0, 0, native.systemFontBold, 32 )
tmp.x = centerX 
tmp.y = 20

tmp:setFillColor( unpack( _YELLOW_ ) )


-- ==
--    Example 1 - Strong Single impulse applied in center of mass
-- ==
local function example1()
	local ship = createShip( 35, 280, { x = 0, y = 0 } )
	local pad = createPad( ship.x, ship.y + 60, _BLUE_, ship )

	local tmp = display.newText( "Strong", 0, 0, native.systemFontBold, 8 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "<0,-100>", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	ship.touchAction = function( self, event )
		if( event.phase == "began" ) then
			local marker1 = self:getMarker(1)
			self:applyLinearImpulse( 0, -100, marker1.x, marker1.y )
			
		elseif( event.phase == "ended" ) then
		end
	end
end


-- ==
--    Example 2 - Medium Single impulse applied in center of mass
-- ==
local function example2()
	local ship = createShip( 100, 280, { x = 0, y = 0 } )
	local pad = createPad( ship.x, ship.y + 60, _ORANGE_, ship )

	local tmp = display.newText( "Medium", 0, 0, native.systemFontBold, 8 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "<0,-50>", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	ship.touchAction = function( self, event )
		if( event.phase == "began" ) then
			local marker1 = self:getMarker(1)
			self:applyLinearImpulse( 0, -50, marker1.x, marker1.y )
			
		elseif( event.phase == "ended" ) then
		end
	end
end

-- ==
--    Example 3 - Weak single impulse applied in center of mass
-- ==
local function example3()
	local ship = createShip( 165, 280, { x = 0, y = 0 } )
	local pad = createPad( ship.x, ship.y + 60, _LIGHTGREY_, ship )

	local tmp = display.newText( "Weak", 0, 0, native.systemFontBold, 8 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "<0,-10>", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	ship.touchAction = function( self, event )
		if( event.phase == "began" ) then
			local marker1 = self:getMarker(1)
			self:applyLinearImpulse( 0, -10, marker1.x, marker1.y )
			
		elseif( event.phase == "ended" ) then
		end
	end
end

-- ==
--    Example 4 - Medium single impulse applied off-center
-- ==
local function example4()
	local ship = createShip( 230, 280, { x = -5, y = 0 } )
	local pad = createPad( ship.x, ship.y + 60, _BLACK_, ship )

	local tmp = display.newText( "Med. Off-Center", 0, 0, native.systemFontBold, 8 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "<0,-50>", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	ship.touchAction = function( self, event )
		if( event.phase == "began" ) then
			local marker1 = self:getMarker(1)
			self:applyLinearImpulse( 0, -50, marker1.x, marker1.y )
			
		elseif( event.phase == "ended" ) then
		end
	end
end


-- ==
--    Example 5 - Apply Angular Impulse
-- ==
local function example5()
	local yinyang = createYinYang( 295, 280)
	local pad = createPad( yinyang.x, yinyang.y + 60, _RED_, yinyang )

	local tmp = display.newText( "Torque", 0, 0, native.systemFontBold, 8 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "(200)", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	yinyang.touchAction = function( self, event )
		if( event.phase == "began" ) then
			self:applyAngularImpulse( 200 )
		end
	end
end

-- ==
--    Example 6 - Mount and Apply Offset Impulse
-- ==
local function example6()
	local yinyang = createYinYang( 360, 280, { x = -30, y = 0 } )
	local pad = createPad( yinyang.x, yinyang.y + 60, _CYAN_, yinyang )

	physics.newJoint( "pivot", yinyang, pad, yinyang.x, yinyang.y )

	local tmp = display.newText( "Pivot + Impulse", 0, 0, native.systemFontBold, 8 )
	tmp.x = pad.x
	tmp.y = pad.y + 28

	local tmp2 = display.newText( "<0,-20>", 0, 0, native.systemFontBold, 8 )
	tmp2.x = tmp.x
	tmp2.y = tmp.y + 10

	yinyang.touchAction = function( self, event )
		if( event.phase == "began" ) then
			local marker1 = self:getMarker(1)
			self:applyLinearImpulse( 0, -20, marker1.x, marker1.y )
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
--example7()

