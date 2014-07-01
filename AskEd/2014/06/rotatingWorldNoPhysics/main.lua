-- =============================================================
-- main.lua
-- =============================================================
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar


require "RGMath2D"

-- SSK Forward Declarations
local angle2Vector 		= ssk.math2d.angle2Vector
local vector2Angle 		= ssk.math2d.vector2Angle
local scaleVec 			= ssk.math2d.scale
local addVec 			= ssk.math2d.add
local subVec 			= ssk.math2d.sub
local getNormals 		= ssk.math2d.normals
local lenVec			= ssk.math2d.length
local normVec			= ssk.math2d.normalize

-- Lua and Corona Forward Declarations
local mRand 			= math.random
local getTimer 			= system.getTimer

local planetRadius = 800

local layers = display.newGroup()
layers.world = display.newGroup()
layers:insert(layers.world)
layers.clouds = display.newGroup()
layers.world:insert(layers.clouds)

-- Create Planet
local planet = display.newImageRect( layers.world, "earth.png", planetRadius * 2, planetRadius * 2 )

-- Create Clouds
for i = 0, 359, 15 do
	local vec = angle2Vector( i, true )
	local scale = planetRadius * mRand( 105, 130) / 100
	vec = scaleVec( vec, scale )
	print(scale, vec.x, vec.y)
	local cloudImg = "cloud" .. mRand(1,3) .. ".png"
	local scale = mRand(55,70)/100
	local tmp = display.newImageRect( layers.clouds, "cloud1.png", 129, 71 )
	tmp.x = vec.x
	tmp.y = vec.y
	tmp.rotation = i
	tmp:scale( scale, scale )

end

-- Center the 'world' and rotate it
layers.world.x = centerX
layers.world.y = display.contentHeight + 700
layers.world.rotRate = 0.05

layers.world.enterFrame = function( self, event )
	self.rotation = self.rotation - self.rotRate
	if(self.rotation < 0 ) then self.rotation = self.rotation + 360 end
end
Runtime:addEventListener( "enterFrame", layers.world )
