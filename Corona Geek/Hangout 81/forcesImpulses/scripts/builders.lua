local cc = require "scripts.cc"


local function createPad( x, y, color, myShip )
	local pad = display.newRect( 0, 0, 60, 40 )
	pad.x = x
	pad.y = y
	pad:setFillColor( unpack(color) )
	pad:setStrokeColor( unpack(_GREY_) )
	pad.strokeWidth = 2
	physics.addBody( pad, "static", { density=1, friction=0, bounce=0, filter=cc:getCollisionFilter("pad") } )

	pad.touch = function( self, event )
		if( event.phase == "began" ) then
			if( myShip and myShip.touchAction ) then
				myShip:touchAction( event )
			end
		elseif( event.phase == "ended" ) then
			if( myShip and myShip.touchAction ) then
				myShip:touchAction( event )
			end
		end
		return true
	end
	pad:addEventListener( "touch" )
	return pad
end


local function createShip( x, y, ... )
	local ship = display.newImageRect( "images/rocket2.png", 50, 60 )
	ship.x = x
	ship.y = y

	local shipShape = { -25, -30, 
                         25, -30, 
                         25,  30, 
                        -25,  30 }

	physics.addBody( ship, "dynamic", { density=1, friction=0, bounce=0, filter=cc:getCollisionFilter("shipyang"), shape=shipShape } )

	ship.linearDamping = 0
	ship.angularDamping = 0

	ship.markers = {}
	ship.getMarker = function( self, num )
		return self.markers[num]
	end
	for i = 1, #arg do	
		local tmp = display.newCircle( ship.x + arg[i].x, ship.y + arg[i].y, 4 )
		tmp:setFillColor( unpack( _RED_ ) )
		physics.addBody( tmp, "dynamic", { density=0.001, radius = 4, friction=0, bounce=0, filter=cc:getCollisionFilter("marker") } )
		ship.markers[i] = tmp
		physics.newJoint( "weld", tmp, ship, tmp.x, tmp.y )
	end

	return ship
end


local function createYinYang( x, y, ... )
	local yinyang = display.newImageRect( "images/yinyang.png", 60, 60 )
	yinyang.x = x
	yinyang.y = y

	physics.addBody( yinyang, "dynamic", { density=1, friction=0, bounce=0, filter=cc:getCollisionFilter("shipyang"), radius = 30 } )

	yinyang.linearDamping = 0
	yinyang.angularDamping = 0.5


	yinyang.gravityScale = 0

	yinyang.markers = {}
	yinyang.getMarker = function( self, num )
		return self.markers[num]
	end
	for i = 1, #arg do	
		local tmp = display.newCircle( yinyang.x + arg[i].x, yinyang.y + arg[i].y, 4 )
		tmp:setFillColor( unpack( _RED_ ) )
		physics.addBody( tmp, "dynamic", { density=0.001, radius = 4, friction=0, bounce=0, filter=cc:getCollisionFilter("marker") } )
		yinyang.markers[i] = tmp
		physics.newJoint( "weld", tmp, yinyang, tmp.x, tmp.y )
	end

	return yinyang
end


local public = {}

public.createPad = createPad
public.createShip = createShip
public.createYinYang = createYinYang

return public