



local objA = display.newCircle( 100, 100, 20 )
objA.myName = "a"

local objB = display.newRect( 100, 200, 40, 40 )
objB.myName = "b"

local function onTouch( self, event )
	if( event.phase == "ended" ) then
		print( self.myName, event.target.myName )
	end		
end

objB.touch = onTouch

objA:addEventListener("touch", objB )

-- touch A, sends touch to B (self is B, target is A)
