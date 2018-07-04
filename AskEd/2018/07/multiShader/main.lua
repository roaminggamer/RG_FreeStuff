io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2

--
-- NO SHADERS
--
local img1 = display.newRect( cx - 150, cy - 300, 200, 200 )
img1.fill = { type = "image", filename = "img1.png" }

local img2 = display.newRect( cx + 150, cy - 300, 200, 200 )
img2.fill = { type = "image", filename = "img2.png" }

--
-- SHADER FROM ARTICLE
--
----[[
local kernel = {}
kernel.language = "glsl"
kernel.category = "filter"
kernel.name = "fromArticle"
kernel.graph =
{
   nodes = {
      horizontal = { effect="filter.blurHorizontal", input1="paint1" },
      vertical = { effect="filter.blurVertical", input1="horizontal" },
   },
   output = "vertical",
}
graphics.defineEffect( kernel )

local img1 = display.newRect( cx - 150, cy, 200, 200 )
img1.fill = { type = "image", filename = "img1.png" }
img1.fill.effect = "filter.custom.fromArticle"
img1.fill.effect.horizontal.blurSize = 8
img1.fill.effect.vertical.blurSize = 8


local img2 = display.newRect( cx + 150, cy, 200, 200 )
img2.fill = { type = "image", filename = "img2.png" }
img2.fill.effect = "filter.custom.fromArticle"
img2.fill.effect.horizontal.blurSize = 1
img2.fill.effect.vertical.blurSize = 16


--
-- CUSTOM SHADER
--
local kernel = {}
kernel.category = "filter"
kernel.name = "myBrighten"
 
kernel.fragment =
[[
P_COLOR vec4 FragmentKernel( P_UV vec2 texCoord )
{
    P_COLOR float brightness = 0.5;
    P_COLOR vec4 texColor = texture2D( CoronaSampler0, texCoord );
 
    // Pre-multiply the alpha to brightness
    brightness = brightness * texColor.a;
 
    // Add the brightness
    texColor.rgb += brightness;
 
    // Modulate by the display object's combined alpha/tint
    return CoronaColorScale( result );
}
]]

graphics.defineEffect( kernel )

local img1 = display.newRect( cx - 150, cy + 300, 200, 200 )
img1.fill = { type = "image", filename = "img1.png" }
img1.fill.effect = "filter.custom.myBrighten"


local img2 = display.newRect( cx + 150, cy + 300, 200, 200 )
img2.fill = { type = "image", filename = "img2.png" }
img2.fill.effect = "filter.custom.myBrighten"
