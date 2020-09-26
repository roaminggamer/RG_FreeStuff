-- =============================================================
-- A Few Extra 'Helper Functions'
-- =============================================================

-- If you are using SSK you don't need to do anything here because
-- SSK provides all these globals (and more) already.
--
if( _G.ssk ) then 
	return 

else

	_G.centerX  = display.contentCenterX
	_G.centerY  = display.contentCenterY
	_G.fullw  	= display.actualContentWidth
	_G.fullh  	= display.actualContentHeight
	_G.left   	= centerX - fullw/2
	_G.right  	= centerX + fullw/2
	_G.top    	= centerY - fullh/2
	_G.bottom 	= centerY + fullh/2
	_G.w 		= display.contentWidth
	_G.h 		= display.contentHeight

	-- Shortand for 'Runtime:addEventListener'
	_G.listen = function( name, listener ) 
		Runtime:addEventListener( name, listener ) 
	end

	-- Shortand for 'Runtime:removeEventListener'
	_G.ignore = function( name, listener ) 
		Runtime:removeEventListener( name, listener ) 
	end

	-- Simplification of 'Runtime:dispatchEvent'
	_G.post = function( name, params )
	   params = params or {}
	   local event = {}
	   for k,v in pairs( params ) do event[k] = v end
	   event.time = event.time or system.getTimer()
	   event.name = name
	   Runtime:dispatchEvent( event )
	end

	-- Add rudimentary table.dump too
	function table.dump( self )
		for k,v in pairs(self) do
			print( k, v)
		end
	end

	display.isValid = function ( obj )
		return ( obj and obj.removeSelf and type(obj.removeSelf) == "function" )
	end
end