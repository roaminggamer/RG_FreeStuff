io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
--ssk.easyIFC.generateButtonPresets( nil, true )
-- =====================================================

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua & Corona Functions
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs; local mFloor = math.floor; local mCeil = math.ceil
local strGSub = string.gsub; local strSub = string.sub
-- Common SSK Features
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
local RGTiled = ssk.tiled; local files = ssk.files
local factoryMgr = ssk.factoryMgr; local soundMgr = ssk.soundMgr
-- =====================================================
-- EXAMPLE BEGINS HERE
-- =====================================================
ssk.android.easyAndroidUIVisibility()
display.setDefault( "background", 1, 0, 1 )
local group = display.newGroup()
newRect( group, centerX, centerY, { w = fullw, h = fullh, fill = _K_, alpha = 0.95 })

--
-- It is known, that opening a native dialog box in Android wil re-show the navigation bar if it was hidden.
--
-- This code provides a way to show a dialog and the dialog gives you the option to re-hide the nav bar so
-- we can investigate what happens with scaling.
--
local function reHide()
    ssk.android.easyAndroidUIVisibility()
end

local function openDialog( )
	easyAlert( "Roaming Gamer Says...", 
	            "Yo!  Navigation bar should be showing.  Want to re-hide it?",
	             { { "Yes!", reHide }, {"Never Mind", nil } } )
end

ssk.easyIFC:presetPush( group, "default", centerX, centerY, 200, 60, "Open Dialog", openDialog )



