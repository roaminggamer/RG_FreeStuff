require "ssk2.loadSSK"
_G.ssk.init( {} )

local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode("hybrid")


local ballRadius = 50


local ball = ssk.display.newImageRect( nil, centerX, centerY, "rg256.png", 
   { size = ballRadius * 2 }, { radius = ballRadius, bounce = 1, friction = 0 } )


local ringRadius = 300


local ring = ssk.display.newCircle( nil, centerX, centerY, 
   { radius = ringRadius, stroke = _W_, strokeWidth = 8, fill = _T_ } )

ring.alpha = 0.2


local body = { chain = {}, connectFirstAndLastChainVertex = true, bounce = 1, friction = 0 }

local points = 50
local angle = 0
local dpa = 360/points

for i = 1, points do
   local vec = ssk.math2d.angle2Vector( (i-1) * dpa, true )
   vec = ssk.math2d.scale( vec, ringRadius ) 
   body.chain[#body.chain+1] = vec.x
   body.chain[#body.chain+1] = vec.y 
end

physics.addBody( ring, "static", body )


ball:setLinearVelocity( math.random( 300, 450), math.random( -200, 200 ) )