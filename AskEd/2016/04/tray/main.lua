local trayParent = display.newGroup()
local tray       = display.newGroup()

tray.openY   = 0
tray.closedY = tray.y - display.actualContentHeight

tray.y       = tray.closedY
tray.open    = false

trayParent:insert(tray)

-- Make some random objects for demo
for i = 1, 5 do
   local obj = display.newRect( tray, i * 50, display.contentCenterY, 40, 20 )
end

-- Make a 'button'
local button = display.newRect( trayParent, display.contentCenterX, display.contentCenterY + display.actualContentHeight/2 - 40, 300, 50 )
button.label = display.newText( trayParent, "Click Me", button.x, button.y )
button.label:setFillColor(0,0,0)


function button.touch( self, event )
   if( event.phase == "ended" ) then
      if( tray.open ) then
         tray.open = false
         transition.cancel( tray )
         transition.to( tray, { y = tray.closedY } )
      else
         tray.open = true
         transition.cancel( tray )
         transition.to( tray, { y = tray.openY } )
      end

   end
end
button:addEventListener( "touch" )