-- Demo project for ponyfont...

local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode("hybrid")


local ponyfont = require "com.ponywolf.ponyfont"
local options

display.setDefault("background", 0.4,0.4,0.4)

local subGroup = display.newGroup()

options = {
  text = "Hello World Yo Bongo", --, it's nice here. I'd love to stay a while...",     
  x = display.contentCenterX,
  y = display.contentCenterY - 150,
  --width = 400,
  font = "fonts/Orienta-Regular.fnt",
  fontSize = 52,
  align = "center",
}

-- Uses pretty much the same options as display.newText
local bmpText = ponyfont.newText(options)

subGroup:insert(bmpText.raw) -- use the .raw to get to the displaygroup for inserting

physics.addBody( bmpText.raw, "static" )

local marker = display.newRect( display.contentCenterX, display.contentCenterY - 150, bmpText.raw.contentWidth, 5 )
marker.alpha = 0.5


-- You can set the properties without calling any update() function
-- uncomment the lines below to see how the text reacts
--bmpText.text = "This is updated text in the same displayObject..."
--bmpText.fontSize = 60
--bmpText.align = "left"


-- Demo looping through each letter
for i = 1, bmpText.numChildren do
  transition.from ( bmpText[i], { delay = 1000 + (i*25), time = 250, xScale = 2, yScale = 2, alpha = 0, transition = easing.outBounce })
end

-- Show what the TTF verison of this text is like will the same options
options = {
  text = "Hello World, it's nice here. I'd love to stay a while...",     
  x = display.contentCenterX,
  y = display.contentCenterY + 150,
  width = 400,
  font = "fonts/Orienta-Regular.ttf", -- this
  fontSize = 52,
  align = "left",
}

local ttfText = display.newText(options)
