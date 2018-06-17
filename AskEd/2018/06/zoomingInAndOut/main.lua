io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
-- =====================================================
-- EXAMPLE BELOW
-- =====================================================
local physics = require "physics"
physics.start()
physics.setGravity(0,0)

local layers = ssk.display.quickLayers( nil, 
      "underlay",
      "world",
         { "circles", "player" },
      "overlay" )

layers.world.x = centerX
layers.world.y = centerY
local back = ssk.display.newImageRect( layers.underlay, centerX, centerY,  
	                                    "protoBackX.png", { w = 720, h = 1386 } )

local centerMarker = ssk.display.newRect( layers.underlay, centerX, centerY, { size = 90, fill = _O_ } )

for i = 1, 5000 do
   ssk.display.newCircle( layers.circles, 
              math.random( -4 * fullw, 4 * fullw ),
              math.random( -4 * fullh, 4 * fullh ),
              { size = math.random( 20,40 ), alpha = 0.5,
                fill = ssk.colors.pastelRGB( ssk.colors.randomRGB() ) } )
end

local player = ssk.display.newImageRect( layers.player, 0, 0, 
	                                      "smiley.png", 
	                                      { size = 80 } ) 
ssk.camera.tracking( player, layers.world, { disableSubPixel = false } )

local function onUpScale()
	layers.world.xScale = layers.world.xScale + 0.1
	layers.world.yScale = layers.world.yScale + 0.1
	return true
end
local function onDownScale()
	layers.world.xScale = layers.world.xScale - 0.1
	layers.world.yScale = layers.world.yScale - 0.1
	return true
end
ssk.easyIFC:presetPush( layers.overlay, "default", centerX - 60, bottom - 100, 50, 50, "+", onUpScale)
ssk.easyIFC:presetPush( layers.overlay, "default", centerX + 60, bottom - 100, 50, 50, "-", onDownScale)
