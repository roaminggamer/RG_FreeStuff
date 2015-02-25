-- 1. Write a single listener like this
local function onTouch( self, event )
   if(event.phase == "ended" ) then
      print("You touched: ", self.myName )
   end
   return true
end

--2. Create as many objects as you want and have them all use the same listener
--
local group = display.newGroup()
group.x = 240
group.y = 160
local tmp = display.newRect( group, 0, -80, 240, 80 )
tmp.touch = onTouch
tmp.myName = "Bob"
tmp.isHitMasked = true
tmp:setFillColor( 1, 0,  0)
tmp:addEventListener( "touch" )

local tmp = display.newRect( group, 0, 0, 240, 80 )
tmp.touch = onTouch -- uses same code as "Bob"
tmp.myName = "Bill"
tmp:setFillColor( 1, 1, 1 )
tmp.isHitMasked = true
tmp:addEventListener( "touch" )

local tmp = display.newRect( group, 0, 80, 240, 80 )
tmp.touch = onTouch -- uses same code as "Bob" and "Bill"
tmp.myName = "Sue"
tmp:setFillColor( 0, 0, 1)
tmp.isHitMasked = true
tmp:addEventListener( "touch" )

local mask = graphics.newMask( "mask.png" )
group:setMask( mask )
group.maskScaleX = 1.5
group.maskScaleY = 1.5

-- ...
