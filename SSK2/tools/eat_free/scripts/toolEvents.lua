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
local util 			= require "scripts.util"
local settings 		= require "scripts.settings"
local projectMgr 	= require "scripts.projectMgr"
local frameMaker 	= require "scripts.frameMaker"

-- =============================================================
local function onLoad()	
	print("LOAD PROJECT")
	projectMgr.load()
end; listen( "onLoadProject", onLoad )

local function onSave()
	print("SAVE PROJECT")
	projectMgr.save()
end; listen( "onSaveProject", onSave )

local function onGenerate( event )
	print("GENERATE PROJECT ", event.name )
	local generator = require "scripts.generation.generator"
	if( event.srcName ) then
		generator.runFixed( event.srcName, event.src, event.genType )
	else
		generator.run( )
	end
end; listen( "onGenerate", onGenerate )


local lastResizeTimer
function onResize( self, event ) 
	if( lastResizeTimer ) then
		timer.cancel( lastResizeTimer )
		lastResizeTimer = nil 
	end 
	lastResizeTimer = timer.performWithDelay( 500, 
		function()
			lastResizeTimer = nil
			--frame:setMode(frame:getMode() or "map") -- EDOCHI
		end )
end; listen("resize", onResize)
