onKey = function( event )
	print(event.keyName, event.phase )
    return false
end

timer.performWithDelay(100, function() Runtime:addEventListener( "key", onKey ) end )
