-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
-- DO NOT MODIFY BELOW (Used In Framework); EXPERTS ONLY
-- DO NOT MODIFY BELOW (Used In Framework); EXPERTS ONLY
-- DO NOT MODIFY BELOW (Used In Framework); EXPERTS ONLY

local debugEn = false


-- =============================================================
-- Measurement and Spacing
-- =============================================================
local mFloor = math.floor
local function round(val, n)
  if (n) then
    return mFloor( (val * 10^n) + 0.5) / (10^n)
  else
    return mFloor(val+0.5)
  end
end


local function calcMeasurementSpacing()
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
		print( "w       = " 	.. w )
		print( "h       = " 	.. h )
		print( "centerX = " .. centerX )
		print( "centerY = " .. centerY )
		print( "fullw   = " 	.. fullw )
		print( "fullh   = " 	.. fullh )
		print( "left    = " 	.. left )
		print( "right   = " 	.. right )
		print( "top     = " 	.. top )
		print( "bottom  = " 	.. bottom )
		print("---------------\n\n")
	end
end
local lastResize
local resizePeriod = 100
local function resize( event ) 
	if( lastResize ) then 
		timer.cancel( lastResize )		
	end
	lastResize = timer.performWithDelay( resizePeriod,  
		function()
			calcMeasurementSpacing()			
		end )
end
if( ssk and ssk.__desktopMode ) then
	Runtime:addEventListener( "resize", calcMeasurementSpacing )
end

calcMeasurementSpacing()


-- =============================================================
-- Environment
-- =============================================================
_G.onSimulator = system.getInfo( "environment" ) == "simulator"
_G.oniOS = ( system.getInfo("platformName") == "iPhone OS") 
_G.onAndroid = ( system.getInfo("platformName") == "Android") 
_G.onOSX = ( system.getInfo("platformName") == "Mac OS X")
_G.onWin = ( system.getInfo("platformName") == "Win")

-- =============================================================
-- Device
-- =============================================================
_G.oniPad        = ( string.find( system.getInfo("architectureInfo"), "iPad" ) ~= nil )
_G.oniPhone4     = ( string.find( system.getInfo("architectureInfo"), "iPhone4" ) ~= nil )
_G.oniPhone5     = ( string.find( system.getInfo("architectureInfo"), "iPhone5" ) ~= nil )
_G.oniPhone5s     = ( string.find( system.getInfo("architectureInfo"), "iPhone6" ) ~= nil )
_G.oniPhone6     = ( string.find( system.getInfo("architectureInfo"), "iPhone7,2" ) ~= nil )
_G.oniPhone6Plus = ( string.find( system.getInfo("architectureInfo"), "iPhone7,1" ) ~= nil )
_G.onAndroidTablet = ( (system.getInfo( "androidDisplayWidthInInches" ) or 0) > 5 or
                        (system.getInfo( "androidDisplayHeightInInches" ) or 0) > 5 ) 
_G.onTablet = onAndroidTablet or oniPad 

-- =============================================================
-- Easy Colors
-- =============================================================
_G.colorNames = {}
_G.allColors = {}
_G._TRANSPARENT_ = {0, 0, 0, 0}; _G.colorNames[_TRANSPARENT_] = "TRANSPARENT"
_G._WHITE_ = {1, 1, 1, 1}; _G.colorNames[_WHITE_] = "WHITE";_G.allColors[#_G.allColors+1] = _G._WHITE_
_G._BLACK_ = {  0,   0,   0, 1}; _G.colorNames[_BLACK_] = "BLACK";_G.allColors[#_G.allColors+1] = _G._BLACK_
_G._GREY_      = {0.5, 0.5, 0.5, 1}; _G.colorNames[_GREY_] = "GREY";_G.allColors[#_G.allColors+1] = _G._GREY_
_G._DARKGREY_  = { 0.25,  0.25,  0.25, 1}; _G.colorNames[_DARKGREY_] = "DARKGREY";_G.allColors[#_G.allColors+1] = _G._DARKGREY_
_G._DARKERGREY_  = { 0.125,  0.125,  0.125, 1}; _G.colorNames[_DARKERGREY_] = "DARKERGREY";_G.allColors[#_G.allColors+1] = _G._DARKERGREY_
_G._LIGHTGREY_ = {0.753, 0.753, 0.753, 1}; _G.colorNames[_LIGHTGREY_] = "LIGHTGREY";_G.allColors[#_G.allColors+1] = _G._LIGHTGREY_
_G._RED_   = {1, 0, 0, 1}; _G.colorNames[_RED_] = "RED";_G.allColors[#_G.allColors+1] = _G._RED_
_G._GREEN_ = {0, 1, 0, 1}; _G.colorNames[_GREEN_] = "GREEN";_G.allColors[#_G.allColors+1] = _G._GREEN_
_G._BLUE_  = {0, 0, 1, 1}; _G.colorNames[_BLUE_] = "BLUE";_G.allColors[#_G.allColors+1] = _G._BLUE_
_G._CYAN_  = {0, 1, 1, 1}; _G.colorNames[_CYAN_] = "CYAN";_G.allColors[#_G.allColors+1] = _G._CYAN_
_G._YELLOW_       = {1, 1, 0, 1}; _G.colorNames[_YELLOW_] = "YELLOW";_G.allColors[#_G.allColors+1] = _G._YELLOW_
_G._ORANGE_       = {1, 0.398, 0, 1}; _G.colorNames[_ORANGE_] = "ORANGE";_G.allColors[#_G.allColors+1] = _G._ORANGE_
_G._BRIGHTORANGE_ = {1, 0.598, 0, 1}; _G.colorNames[_BRIGHTORANGE_] = "BRIGHTORANGE";_G.allColors[#_G.allColors+1] = _G._BRIGHTORANGE_
_G._PURPLE_       = {0.625, 0.125, 0.938, 1}; _G.colorNames[_PURPLE_] = "PURPLE";_G.allColors[#_G.allColors+1] = _G._PURPLE_
_G._PINK_         = {1, 0.430, 0.777, 1}; _G.colorNames[_PINK_] = "PINK";_G.allColors[#_G.allColors+1] = _G._PINK_

-- Short Names
_G._T_ 	= _TRANSPARENT_
_G._W_ 	= _WHITE_
_G._K_ 	= _BLACK_
_G._R_  = _RED_
_G._G_ 	= _GREEN_
_G._B_  = _BLUE_
_G._Y_  = _YELLOW_
_G._O_  = _ORANGE_
_G._P_  = _PINK_
_G._C_  = _CYAN_


_G.gameFont = _G.gameFont or native.systemFont
