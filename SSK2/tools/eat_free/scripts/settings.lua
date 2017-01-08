-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Eds Awesome Tool (a free SSK2 PRO co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
-- =============================================================
-- =============================================================
-- =============================================================
-- ==
--    Localizations
-- ==
-- Corona & Lua
--
local mAbs = math.abs;local mRand = math.random;local mDeg = math.deg;
local mRad = math.rad;local mCos = math.cos;local mSin = math.sin;
local mAcos = math.acos;local mAsin = math.asin;local mSqrt = math.sqrt;
local mCeil = math.ceil;local mFloor = math.floor;local mAtan2 = math.atan2;
local mPi = math.pi
local pairs = pairs;local getInfo = system.getInfo;local getTimer = system.getTimer
local strFind = string.find;local strFormat = string.format;local strFormat = string.format
local strGSub = string.gsub;local strMatch = string.match;local strSub = string.sub
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
-- Forward Declarations
local RGFiles = ssk.files
-- =============================================================
-- =============================================================
-- =============================================================
local settings = {}

settings.debugEn = false

settings.EATFolder 		= "EATFrameworks"
settings.EATStorage 	= RGFiles.desktop.getMyDocumentsPath( settings.EATFolder )
settings.EATDBPath 		= RGFiles.desktop.getMyDocumentsPath( settings.EATFolder .. "/projectDB.json" )
settings.EATGenFolder 	= RGFiles.desktop.getDesktopPath( "EATOutput")

RGFiles.util.mkFolder( settings.EATGenFolder )

print(">>> ", settings.EATFolder )
print(">>> ", settings.EATStorage )
print(">>> ", settings.EATDBPath )
print(">>> ", settings.EATGenFolder )

--settings.genPath = "X:\\Work\\00_CurentProjects\\Corona\\EATSuite\\experiments\\EATEngine\\step8_generative5\\projectDB.txt"
--settings.genPath = "X:/Work/00_CurentProjects/Corona/EAT/apps/EatGenTest/projectDB.txt"

settings.normalFont		= "fonts/Lato-Regular.ttf"
settings.boldFont		= "fonts/Lato-Black.ttf"
--settings.normalFont		= native.systemFont
--settings.boldFont		= native.systemFontBold

settings.color1   		= hexcolor("#1a1a1a")

settings.color2        	= hexcolor("#797979")
--settings.color2   		= hexcolor("#00FF00")

settings.color3   		= hexcolor("#515151")
settings.color3   		= hexcolor("#333333")

settings.color4   		= hexcolor("#111111")

settings.color5   		= hexcolor("#00aeef")
settings.color6   		= hexcolor("#ff6932")
settings.color6a   		= hexcolor("#ff693240")

settings.defaultFont 		= settings.normalFont
settings.defaultFontSize 	= 16
settings.defaultFontColor 	= _W_
settings.defaultStrokeColor = settings.color2

-- Background 
settings.backgroundColor					= settings.color1

settings.shadowAlpha 						= 0.4
settings.shadowW 							= 2

settings.mapLinkColor						= settings.color5
settings.mapLinkStrokeWidth					= 3
settings.selectorStrokeFill					= settings.color5
settings.selectorStrokeWidth				= 2


-- Menu Bar
settings.menuBarH							= 28
settings.menuBarFill						= settings.color3
settings.menuBarFont 						= settings.boldFont
settings.menuBarFontSize					= 14
settings.menuBarFontColor					= { 1, 1, 1, 0.9 }
settings.menuBarHButtonTween 				= 1
settings.menuBarHLabelBuffer				= 40
settings.menuBarHShortcutOffsetX			= 10
settings.menuBarHButtontHoverFill 			= settings.color2
settings.menuBarHButtonTouchFill 			= settings.color2

settings.menuBarChildFont 					= settings.boldFont
settings.menuBarChildFontSize				= 15
settings.menuBarChildFontColor				= settings.menuBarFontColor
settings.menuBarChildLabelIndent 			= 20
settings.menuBarChildButtonH 				= 26
settings.menuBarChildTrayBuffer				= 25
settings.menuBarChildTrayFill 				= settings.color3
settings.menuBarChildButtonHoverFill 		= settings.color2


-- Edit Pane
settings.editPaneCommonTitleFont 			= settings.boldFont
settings.editPaneCommonTitleFontColor 		= _W_
settings.editPaneCommonTitleFontSize 		= 32

settings.editPaneCommonLabelFont 			= settings.boldFont
settings.editPaneCommonLabelFontColor 		= _W_
settings.editPaneCommonLabelFontSize 		= 18

settings.editPaneCommonTextFieldFont		= settings.boldFont
settings.editPaneCommonTextFieldFontSize	= 16
settings.editPaneCommonTextFieldHeight		= settings.editPaneCommonTextFieldFontSize + 12
settings.editPaneCommonTextFieldWidth		= 360 / 2


settings.editPaneFill						= settings.color1
settings.editPaneMenuFont 					= settings.boldFont
settings.editPaneMenuFontSize				= 15
settings.editPaneMenuFontColor				= _W_
settings.editPaneMenuLabelIndent			= 10
settings.editPaneMenuButtonH 				= 28
settings.editPaneMenuTrayBuffer				= 4
settings.editPaneMenuTrayFill 				= settings.color4
settings.editPaneMenuButtonHoverFill 		= settings.color2

settings.mapUIBodyFill						= _DARKGREY_
settings.mapUIHeaderFill					= settings.color5
settings.mapWorldBodyFill					= _DARKGREY_
settings.mapWorldHeaderFill					= settings.color6
settings.mapFont							= settings.boldFont
settings.mapFontSize						= 14
settings.mapFontColor 						= _K_




-- http://www.colourlovers.com/palettes/search/new
-- https://color.adobe.com/create/color-wheel/ 
-- https://color.adobe.com/Star-Shade-color-theme-7548239/
settings.backColor   		= hexcolor("#313131")

return settings