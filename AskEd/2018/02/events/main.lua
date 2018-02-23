-- =============================================================
--  main.lua
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

local function touch( self, event )
	if( event.phase == "ended") then
		Runtime:dispatchEvent( { name = "onScore", value = self.value } )
	   display.remove(self)	   
	end
end

for i = 1, 5 do
	local obj = display.newImageRect( "balloon" .. i .. ".png", 295/2, 482/2 )
	
	obj.x = display.contentCenterX - display.actualContentWidth/2 + (i-1) * 200 + 75
	obj.y = display.contentCenterY
	obj.value = i * 10

	obj.touch = touch
	obj:addEventListener( "touch" )
end

local scoreLabel = display.newText( 0, 100, 50 )

function scoreLabel.onScore( self , event ) 
	self.text = tonumber(self.text) + event.value  
end
Runtime:addEventListener("onScore",scoreLabel)