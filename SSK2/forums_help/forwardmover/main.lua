require "ssk2.loadSSK"
_G.ssk.init( {} )

ssk.easyInputs.oneTouch.create( nil, { debugEn = true } )

local function enterFrame( self )
  if( self.isRotating ) then
    self.rotation = self.rotation + 90 * ssk.getDT() / 1000
    ssk.actions.move.forward( self, { rate = 0 } )
  else
    ssk.actions.move.forward( self, { rate = 100 } )
  end
end



local dude = ssk.display.newImageRect( nil, centerX, centerY, "dude.png", 
                                       { size = 80,
                                         isRotating = true, enterFrame = enterFrame })

function dude.onOneTouch( self, event )
  if(event.phase == "began") then
    self.isRotating = false
  elseif( event.phase == "ended") then
  self.isRotating = true
  end
end; listen("onOneTouch", dude)



