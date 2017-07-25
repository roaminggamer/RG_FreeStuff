-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--   Last Updated: 29 NOV 2016
--   Last Updated: 29 NOV 2016
-- =============================================================

_G.ssk = _G.ssk or {}
local ssk_system = {}
_G.ssk.system = ssk_system

-- =============================================================
-- Environment
-- =============================================================
ssk_system.onSimulator    = ( system.getInfo( "environment" ) == "simulator" )
ssk_system.oniOS          = ( system.getInfo("platformName") == "iPhone OS" ) 
ssk_system.onAndroid      = ( system.getInfo("platformName") == "Android" ) 
ssk_system.onWinPhone     = ( system.getInfo("platformName") == "WinPhone" )
ssk_system.onOSX          = ( system.getInfo("platformName") == "Mac OS X" )
ssk_system.onAppleTV      = ( system.getInfo("platformName") == "tvOS" )
--[[
ssk_system.onAndroidTV 	= ( (system.getInfo("androidDisplayDensityName") == "tvdpi") or
                      		    (tostring(system.getInfo("androidDisplayApproximateDpi")) == "213" ) ) 
--]]
local la = _G.ssk.launchArgs or {}
ssk_system.onAndroidTV	= ( la and la.android and 
                                la.android.intent and la.android.intent.category and
                                la.android.intent.category.LEANBACK_LAUNCHER )

ssk_system.onWin          = ( system.getInfo("platformName") == "Win" )
ssk_system.onNook         = ( system.getInfo("targetAppStore") == "nook" )
ssk_system.onAmazon       = ( system.getInfo("targetAppStore") == "amazon" or
	                            ( string.find( system.getInfo("model"), "Fire" ) ~= nil ) )
ssk_system.onDesktop      = ( ( ssk_system.onOSX or ssk_system.onWin ) and 
	                            not ssk_system.onSimulator )
ssk_system.onDevice       = ( ssk_system.onAndroid or 
	                            ssk_system.oniOS or 
	                            ssk_system.onAppleTVOS or 
	                            ssk_system.onAndroidTV  )

-- =============================================================
-- Device 
-- https://www.theiphonewiki.com/wiki/Main_Page
-- http://www.everymac.com/ultimate-mac-lookup/
-- =============================================================
ssk_system.oniPhone4       = ( string.find( system.getInfo("architectureInfo"), "iPhone4" ) ~= nil )
ssk_system.oniPhone5       = ( string.find( system.getInfo("architectureInfo"), "iPhone5,1" ) ~= nil ) or
                           ( string.find( system.getInfo("architectureInfo"), "iPhone5,2" ) ~= nil )
ssk_system.oniPhone5c      = ( string.find( system.getInfo("architectureInfo"), "iPhone5,3" ) ~= nil ) or
                           ( string.find( system.getInfo("architectureInfo"), "iPhone5,4" ) ~= nil )
ssk_system.oniPhone5s      = ( string.find( system.getInfo("architectureInfo"), "iPhone6" ) ~= nil )
ssk_system.oniPhone6       = ( string.find( system.getInfo("architectureInfo"), "iPhone7,2" ) ~= nil )
ssk_system.oniPhone6Plus   = ( string.find( system.getInfo("architectureInfo"), "iPhone7,1" ) ~= nil )
ssk_system.oniPhone6s      = ( string.find( system.getInfo("architectureInfo"), "iPhone8,1" ) ~= nil )
ssk_system.oniPhone6sPlus  = ( string.find( system.getInfo("architectureInfo"), "iPhone8,2" ) ~= nil )
ssk_system.oniPhone7       = ( string.find( system.getInfo("architectureInfo"), "iPhone9,1" ) ~= nil ) or
                           ( string.find( system.getInfo("architectureInfo"), "iPhone9,3" ) ~= nil )
ssk_system.oniPhone7Plus   = ( string.find( system.getInfo("architectureInfo"), "iPhone9,2" ) ~= nil ) or
                           ( string.find( system.getInfo("architectureInfo"), "iPhone9,4" ) ~= nil )
ssk_system.oniPhone        = ssk_system.oniPhone4 or 
                           ssk_system.oniPhone5 or ssk_system.oniPhone5s or ssk_system.oniPhone5c or 
                           ssk_system.oniPhone6 or ssk_system.oniPhone6s or ssk_system.oniPhone6Plus or ssk_system.oniPhone6sPlus or
                           ssk_system.oniPhone7 or ssk_system.oniPhone7Plus
ssk_system.oniPad          = ( string.find( system.getInfo("architectureInfo"), "iPad" ) ~= nil )
ssk_system.oniPadPro       = ( string.find( system.getInfo("architectureInfo"), "iPad6,7" ) ~= nil ) or
                           ( string.find( system.getInfo("architectureInfo"), "iPad6,8" ) ~= nil )
ssk_system.onAndroidTablet = ( (system.getInfo( "androidDisplayWidthInInches" ) or 0) > 5 or
                           (system.getInfo( "androidDisplayHeightInInches" ) or 0) > 5 ) 
ssk_system.onTablet        = ssk_system.onAndroidTablet or ssk_system.oniPad 

-- Export all system fields/functions as globals
function ssk_system.export()
  for k,v in pairs( ssk_system ) do
    if( k ~= "export" ) then
      _G[k] = v 
    end
  end
end


return ssk_system
