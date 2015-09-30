local ccmgr = require "plugin.cc"
local math2d = require "plugin.math2d"

local physics = require("physics")
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode( "hybrid" )


local myCC = ccmgr.newCalculator()
myCC:addNames( "redBall", "greenBall", "wall" )
myCC:collidesWith( "redBall", { "wall", "redBall" } )
myCC:collidesWith( "greenBall", { "wall", "greenBall" } )

myCC:dump()

local group = display.newGroup() 

local impulseMagnitude = 100
local maxImpulse = 15

local createBlock
local createBall
local onTouch

createBall = function( group, x, y, color, type )
	print(x,y)
	local tmp = display.newCircle( group, x, y, 10 )
	tmp:setFillColor( unpack( color ) )
	physics.addBody( tmp, "dynamic", { radius = 10, friction = 0.2, bounce = 0.85, filter = myCC:getCollisionFilter( type ) } )

	tmp.linearDamping = 1

	tmp.touch = onTouch
	Runtime:addEventListener( "touch", tmp )
end

createWalls = function()
	local tmp = display.newRect( group, display.screenOriginX, display.contentCenterY, 20, display.actualContentHeight)
	tmp:setFillColor( 0.5, 0.5, 0.5 )
	tmp:setStrokeColor( 1, 1, 0 )
	tmp.strokeWidth = 1
	physics.addBody( tmp, "static", {  friction = 0, bounce = 1, filter = myCC:getCollisionFilter( "wall" ) } )

	local tmp = display.newRect( group, display.screenOriginX + display.actualContentWidth, display.contentCenterY, 20, display.actualContentHeight)
	tmp:setFillColor( 0.5, 0.5, 0.5 )
	tmp:setStrokeColor( 1, 1, 0 )
	tmp.strokeWidth = 1
	physics.addBody( tmp, "static", {  friction = 0, bounce = 1, filter = myCC:getCollisionFilter( "wall" ) } )

	local tmp = display.newRect( group, display.contentCenterX, display.screenOriginY + display.actualContentHeight, display.actualContentWidth, 20)
	tmp:setFillColor( 0.5, 0.5, 0.5 )
	tmp:setStrokeColor( 1, 1, 0 )
	tmp.strokeWidth = 1
	physics.addBody( tmp, "static", {  friction = 0, bounce = 1, filter = myCC:getCollisionFilter( "wall" ) } )

	local tmp = display.newRect( group, display.contentCenterX, display.screenOriginY, display.actualContentWidth, 20)
	tmp:setFillColor( 0.5, 0.5, 0.5 )
	tmp:setStrokeColor( 1, 1, 0 )
	tmp.strokeWidth = 1
	physics.addBody( tmp, "static", {  friction = 0, bounce = 1, filter = myCC:getCollisionFilter( "wall" ) } )

end


local touchMarker
onTouch = function(self,event)
	if( event.phase == "began" ) then
		local vec = math2d.diff( event.x, event.y, self.x, self.y, true )  -- Return a table
		local len =  math2d.length( vec )

		local mag = impulseMagnitude / len
		mag = (mag > maxImpulse) and maxImpulse or mag
		
		vec = math2d.normalize( vec )
		vec = math2d.scale( vec, mag )

		self:applyLinearImpulse( vec.x * self.mass, vec.y * self.mass, self.x, self.y )

		if( not touchMarker ) then
			local function onComplete()
				display.remove(touchMarker)
				touchMarker = nil
			end
			touchMarker = display.newCircle( event.x, event.y, 1 )
			transition.to( touchMarker, { xScale = 20, yScale = 20, alpha = 0, onComplete = onComplete, time = 150 } )
		end


	end
	return false
end



createWalls( display.contentCenterX + 180, display.actualContentHeight - 20, 40, 0)

for i = 1, 50 do
	local x = display.contentCenterX + math.random( -10, 100 )
	local y = display.contentCenterY + math.random( -100, 100 )
	if( i % 2 == 0 ) then
		createBall( group, x, y, {0,1,0}, "greenBall" )
	else
		createBall( group, x, y, {1,0,0}, "redBall" )
	end
end


