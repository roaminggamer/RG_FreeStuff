io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================

local physics  = require("physics")
physics.setDrawMode( "hybrid" )  --debug  hybrid  normal
physics.start()
physics.setGravity( 0, 0 )

--====--
--ball--
--====--
local ballSpeed = 100
--local ball = display.newImageRect( "bowling-ball.png", 30, 30 )
local ball = display.newImageRect( "kenney1.png", 30, 30 )
ball.x = 250
ball.y = 350

physics.addBody( ball,  {density=0.1, radius = 15, bounce = 0.7, friction = 1 } )
ball.isBullet = true
ball.friction = 1

local enterFrame = function( self )
   local vx,vy = self:getLinearVelocity()
   vx,vy = ssk.math2d.normalize( vx, vy )
   vx,vy = ssk.math2d.scale( vx, vy, ballSpeed )
   self:setLinearVelocity( vx, vy )
end

local enterFrame = function( self )
   local vx,vy = self:getLinearVelocity()
   local len = ssk.math2d.length( vx, vy )
   print( len )
end


local angleStart = 299
local vec = ssk.math2d.angle2Vector( angleStart, true )
vec = ssk.math2d.scale( vec, ballSpeed )
ball:setLinearVelocity( vec.x, vec.y )
ball.enterFrame = enterFrame
Runtime:addEventListener( "enterFrame", ball )

--=========--
--obstacles--
--=========--
local points = {
   -7.8459095727845   ,99.691733373313,
   -15.643446504023   ,98.768834059514,
   -23.344536385591   ,97.236992039768,
   -30.901699437495   ,95.105651629515,
   -38.268343236509   ,92.387953251129,
   -45.399049973955   ,89.100652418837,
   -52.249856471595   ,85.264016435409,
   -58.778525229247   ,80.901699437495,
   -64.944804833018   ,76.040596560003,
   -70.710678118655   ,70.710678118655,
   -76.040596560003   ,64.944804833018,
   -80.901699437495   ,58.778525229247,
   -85.264016435409   ,52.249856471595,
   -89.100652418837   ,45.399049973955,
   -92.387953251129   ,38.268343236509,
   -95.105651629515   ,30.901699437495,
   -97.236992039768   ,23.344536385591,
   -98.768834059514   ,15.643446504023,
   -99.691733373313   ,7.8459095727845,
   -100,   2.4492935982947e-014,
}
local obstacle = display.newRect( 185, 292, 10, 10 )

physics.addBody( obstacle, "static", { chain = points, } )
obstacle.friction = 1

local obstacle2 = display.newCircle( 100, 250, 10 )
physics.addBody( obstacle2, "static", {radius=10})