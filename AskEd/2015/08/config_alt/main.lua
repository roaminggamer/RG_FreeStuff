
-- ==
--    round(val, n) - Rounds a number to the nearest decimal places. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to round.
--    n - Number of decimal places to round to.
-- ==
function _G.round(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end

local function calcMeasurementSpacing( debugEn )
	_G.w 				= display.contentWidth
	_G.h 				= display.contentHeight
	_G.centerX 			= display.contentCenterX
	_G.centerY 			= display.contentCenterY
	_G.fullw			= display.actualContentWidth 
	_G.fullh			= display.actualContentHeight
	_G.unusedWidth		= _G.fullw - _G.w
	_G.unusedHeight		= _G.fullh - _G.h
	_G.deviceWidth		= math.floor((fullw/display.contentScaleX) + 0.5)
	_G.deviceHeight 	= math.floor((fullh/display.contentScaleY) + 0.5)
	_G.left				= 0 - unusedWidth/2
	_G.top 				= 0 - unusedHeight/2
	_G.right 			= w + unusedWidth/2
	_G.bottom 			= h + unusedHeight/2


	_G.w 				= round(w)
	_G.h 				= round(h)
	_G.left				= round(left)
	_G.top				= round(top)
	_G.right			= round(right)
	_G.bottom			= round(bottom)
	_G.fullw			= round(fullw)
	_G.fullh			= round(fullh)

	_G.orientation  	= ( w > h ) and "landscape"  or "portrait"
	_G.isLandscape 		= ( w > h )
	_G.isPortrait 		= ( h > w )

	_G.left 			= (left>=0) and math.abs(left) or left
	_G.top 				= (top>=0) and math.abs(top) or top
	
	if( debugEn ) then
		print("\n---------- calcMeasurementSpacing() @ " .. system.getTimer() )	
		print( "     w       = " 	.. w )
		print( "     h       = " 	.. h )
		print( "     centerX = " 	.. centerX )
		print( "     centerY = " 	.. centerY )
		print( "     fullw   = " 	.. fullw )
		print( "     fullh   = " 	.. fullh )
		print( "     left    = " 	.. left )
		print( "     right   = " 	.. right )
		print( "     top     = " 	.. top )
		print( "     bottom  = " 	.. bottom )
		print( "orientation  = " 	.. orientation )
		print("---------------\n\n")
	end
end

print("\n----------------------------")
calcMeasurementSpacing( true )