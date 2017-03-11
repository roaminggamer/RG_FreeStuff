require "ssk2.loadSSK"
_G.ssk.init( {} )

local function test( x, y, numButtons, style, offsetAngle )
  local menu = require "menu"

  local myMenu = menu.create( nil, x, y, { size = 400, style = style, offsetDist = -32, offsetAngle = offsetAngle } )

  local letters = { "A", "B", "C", "D", "E" }

  for i = 1, numButtons do
    local letter = letters[i]
    local function myAction( self )
      print( "Hey!", letter )
    end

    myMenu:addButton( { img = "images/block" .. letter .. ".png", action = myAction, size = 36 } )
  end

  myMenu:draw()
end


test( centerX, centerY, 5, "full" )

test( left, centerY, 3, "right", 30 )

test( right, centerY, 4,  "left", 22.5 )