-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local mod = {}

function mod.new( settings )	
	local behavior = {}
	behavior.ll = {} -- local listeners   obj:event() )   ==> ex: obj:addEventListener( "collision" )
	behavior.gl = {} -- global listeners  Runtime:event() ==> ex: Runtime:addEventListener( "enterFrame", obj )
	--
	function behavior.ll.touch( self, event ) 
		if( event.phase == "began" ) then
			behavior._isFocus = true
			display.getCurrentStage():setFocus( self, event.id )
		elseif( behavior._isFocus ) then
			if( event.phase == "ended" ) then
				timer.performWithDelay( 1,
					function()
						behavior._isFocus = false
						display.getCurrentStage():setFocus( self, nil )
					end )
			end
		end
		return true
	end
	--
	return behavior
end


return mod
