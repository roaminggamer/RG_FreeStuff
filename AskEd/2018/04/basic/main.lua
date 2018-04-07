io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local tmp = display.newImageRect( "back.png", 720, 1386 )
tmp.x = display.contentCenterX
tmp.y = display.contentCenterY

local label = display.newText( "", tmp.x, tmp.y )

function label.timer( self )
	self.text = math.floor(system.getTimer()/1000)
end;
timer.performWithDelay( 250, label, -1)
