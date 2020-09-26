-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Global Variables
-- =============================================================

-- =============================================================
-- Display
-- =============================================================
_G.w             	= display.contentWidth
_G.h             	= display.contentHeight
_G.centerX       	= display.contentCenterX
_G.centerY       	= display.contentCenterY
_G.fullw         	= display.actualContentWidth 
_G.fullh         	= display.actualContentHeight
_G.unusedWidth   	= _G.fullw - _G.w
_G.unusedHeight  	= _G.fullh - _G.h
_G.left	        	= 0 - _G.unusedWidth/2
_G.top           	= 0 - _G.unusedHeight/2
_G.right         	= _G.w + _G.unusedWidth/2
_G.bottom        	= _G.h + _G.unusedHeight/2

_G.w 					= round(_G.w)
_G.h 					= round(_G.h)
_G.left          	= round(_G.left)
_G.top           	= round(_G.top)
_G.right         	= round(_G.right)
_G.bottom        	= round(_G.bottom)
_G.fullw         	= round(_G.fullw)
_G.fullh         	= round(_G.fullh)

_G.orientation  	= ( _G.w > _G.h ) and "landscape"  or "portrait"
_G.isLandscape 	= ( _G.w > _G.h )
_G.isPortrait 		= ( _G.h > _G.w )

_G.left 				= (_G.left>=0) and math.abs(_G.left) or _G.left
_G.top           	= (_G.top>=0) and math.abs(_G.top) or _G.top


-- =============================================================
-- System
-- =============================================================

-- platformName is deprecated; 
-- However, I need to use it till there is a way to tell current OS simulator is running under
local platformName            = system.getInfo("platformName") 

-- This returns the simulator skin target, or current DEVICE os:
local platform                = system.getInfo("platform")
local platformEnvironment     = system.getInfo("environment")
local targetAppStore          = system.getInfo("targetAppStore")
local architectureInfo        = system.getInfo("architectureInfo")
local model                   = system.getInfo("model")

-- =============================================================
-- Actual Running Environment
-- =============================================================
_G.onSimulator        = platformEnvironment == "simulator"
_G.onDevice           = platformEnvironment == "device"
_G.oniOS              = platformName == "iPhone OS"
_G.onAndroid          = platformName == "Android"
_G.onOSX              = platformName == "Mac OS X"
_G.onAppleTV          = platformName == "tvOS"
local la = _G.ssk.launchArgs or {}
_G.onAndroidTV        = ( la and la.android and 
                                la.android.intent and la.android.intent.category and
                                la.android.intent.category.LEANBACK_LAUNCHER )

_G.onWin              = platformName == "Win"
_G.onNook             = targetAppStore == "nook"
_G.onAmazon           = (targetAppStore == "amazon") or (string.find( system.getInfo("model"), "Fire" ) ~= nil)
_G.onDesktop          = _G.onOSX or _G.onWin

-- =============================================================
-- Targeted Environment
-- =============================================================
_G.targetiOS             = platform == "ios"
_G.targetAndroid         = platform == "android"
_G.targetOSX             = platform == "macos"
_G.targetAppleTV         = platform == "tvos"
_G.targetWin             = platform == "win32"
_G.targetDesktop         = _G.targetOSX or _G.targetWin
_G.targetDevice          = not _G.targetDesktop

-- =============================================================
-- Device 
-- https://www.theiphonewiki.com/wiki/Main_Page
-- http://www.everymac.com/ultimate-mac-lookup/
-- https://www.theiphonewiki.com/wiki/Models#iPhone
-- =============================================================
if( _G.onDevice ) then
   _G.oniPhone4       = ( string.find( architectureInfo, "iPhone4" ) ~= nil )
   _G.oniPhone5       = ( string.find( architectureInfo, "iPhone5,1" ) ~= nil ) or
                              ( string.find( architectureInfo, "iPhone5,2" ) ~= nil )
   _G.oniPhone5c      = ( string.find( architectureInfo, "iPhone5,3" ) ~= nil ) or
                              ( string.find( architectureInfo, "iPhone5,4" ) ~= nil )
   _G.oniPhone5s      = ( string.find( architectureInfo, "iPhone6" ) ~= nil )
   _G.oniPhone6       = ( string.find( architectureInfo, "iPhone7,2" ) ~= nil )
   _G.oniPhone6Plus   = ( string.find( architectureInfo, "iPhone7,1" ) ~= nil )
   _G.oniPhone6s      = ( string.find( architectureInfo, "iPhone8,1" ) ~= nil )
   _G.oniPhone6sPlus  = ( string.find( architectureInfo, "iPhone8,2" ) ~= nil )
   _G.oniPhone7       = ( string.find( architectureInfo, "iPhone9,1" ) ~= nil ) or
                              ( string.find( architectureInfo, "iPhone9,3" ) ~= nil )
   _G.oniPhone7Plus   = ( string.find( architectureInfo, "iPhone9,2" ) ~= nil ) or
                              ( string.find( architectureInfo, "iPhone9,4" ) ~= nil )
   _G.oniPhone8        = ( string.find( architectureInfo, "iPhone10,1" ) ~= nil ) or
                              ( string.find( architectureInfo, "iPhone10,4" ) ~= nil )
   _G.oniPhone8Plus   = ( string.find( architectureInfo, "iPhone10,2" ) ~= nil ) or
                              ( string.find( architectureInfo, "iPhone10,5" ) ~= nil )
   _G.oniPhoneX       = ( string.find( architectureInfo, "iPhone10,3" ) ~= nil ) or
                              ( string.find( architectureInfo, "iPhone10,6" ) ~= nil )
   _G.oniPhone        = _G.oniPhone4 or _G.oniPhone5 or
                              _G.oniPhone5c or _G.oniPhone5s or
                              _G.oniPhone6 or _G.oniPhone6Plus or
                              _G.oniPhone6s or _G.oniPhone6sPlus or
                              _G.oniPhone7 or _G.oniPhone7Plus or
                              _G.oniPhone8 or _G.oniPhone8Plus or
                              _G.oniPhoneX
   _G.oniPad          = ( string.find( architectureInfo, "iPad" ) ~= nil )
   _G.oniPadPro       = ( string.find( architectureInfo, "iPad6,7" ) ~= nil ) or
                              ( string.find( architectureInfo, "iPad6,8" ) ~= nil )
   _G.onAndroidTablet = ( (system.getInfo( "androidDisplayWidthInInches" ) or 0) > 5 or
                              (system.getInfo( "androidDisplayHeightInInches" ) or 0) > 5 ) 
   _G.onTablet        = _G.onAndroidTablet or _G.oniPad 
else
   local actualWidth = math.floor((display.actualContentWidth/display.contentScaleX)+0.5)
   local actualHeight = math.floor((display.actualContentHeight/display.contentScaleY)+0.5)
   local function matchesWH(width,height)
      return( (width == actualWidth and height == actualHeight) or (height == actualWidth and width == actualHeight) )
   end
   local function round(val, n)
      if (n) then
         return math.floor( (val * 10^n) + 0.5) / (10^n)
      else
         return math.floor(val+0.5)
      end
   end
   local function matchesAR(width,height)
      local ar1 = round(width/height,4)
      local ar2 = round(height/width,4)
      local ar3 = round(actualHeight/actualWidth,4)
      --print(ar1,ar2,ar3)
      return( ar3 == ar1 or ar3 == ar2 )
   end   
   _G.oniPhone4       = matchesWH(640,960)
   _G.oniPhone5       = matchesWH(640,1136)
   _G.oniPhone5c      = false -- SAME ASPECT RATIO AS oniPhone5
   _G.oniPhone5s      = false -- SAME ASPECT RATIO AS oniPhone5
   _G.oniPhone6       = matchesWH(740,1334)
   _G.oniPhone6Plus   = matchesWH(1080,1920)
   _G.oniPhone6s      = false -- SAME ASPECT RATIO AS oniPhone6P
   _G.oniPhone6sPlus  = false -- SAME ASPECT RATIO AS oniPhone6Plus
   _G.oniPhone7       = false -- SAME ASPECT RATIO AS oniPhone6P
   _G.oniPhone7Plus   = false -- SAME ASPECT RATIO AS oniPhone6Plus
   _G.oniPhone8       = false -- SAME ASPECT RATIO AS oniPhone6
   _G.oniPhone8Plus   = false -- SAME ASPECT RATIO AS oniPhone6Plus
   _G.oniPhoneX       = matchesWH(1125,2436)
   _G.oniPhone        = _G.oniPhone4 or _G.oniPhone5 or
                              _G.oniPhone5c or _G.oniPhone5s or
                              _G.oniPhone6 or _G.oniPhone6Plus or
                              _G.oniPhone6s or _G.oniPhone6sPlus or
                              _G.oniPhone7 or _G.oniPhone7Plus or
                              _G.oniPhone8 or _G.oniPhone8Plus or
                              _G.oniPhoneX
   _G.oniPadMini      = matchesWH(768,1024)
   _G.oniPadAir       = matchesWH(1536,2048)
   _G.oniPadPro       = matchesWH(1125,2436)
   _G.oniPad          = _G.oniPadMini or _G.oniPadAir or _G.oniPadPro or matchesAR(768,1024)
   _G.onAndroidTablet = false -- EFM detect this... but how?
   _G.onTablet        = _G.oniPadMini or _G.oniPad or _G.oniPadPro or _G.onAndroidTablet
end
