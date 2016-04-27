-- =============================================================
-- b_mover_dpad.lua 
-- Mover Behavior - Drag Object (Self)
-- Behavior Type: Instance
-- =============================================================
--
-- =============================================================
--[[ 
     FUNCTIONS IN THIS FILE
--]]

local touchHandler

function createMover( dpadImage, width, height, x, y, group )
	print(dpadImage)
	local mover = display.newImageRect( group, dpadImage, width, height)
	mover.x = x
	mover.y = y
	return mover
end

function attachMover( moverObj, inputObj )
	moverObj._inputObj = inputObj	

	function moverObj:touch( event )
		local inputObj = event.target
		local moverObj = self
		return touchHandler( inputObj, moverObj, event )
	end

	inputObj:addEventListener( "touch", moverObj )
end

function detachMover( moverObj )
	local inputObj = moverObj._inputObj

	inputObj:removeEventListener( "touch", moverObj )
end



touchHandler = function( inputObj, moverObj, event )
	print("Touched " .. event.phase)

	moverObj.x = event.x
	moverObj.y = event.y

	return true
end
 

