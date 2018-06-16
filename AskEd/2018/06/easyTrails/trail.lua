-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- Player public
-- =============================================================
local common 	= require "scripts.common"
local myCC 		= require "scripts.myCC"
local physics 	= require "physics"

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua Functions
local getTimer          = system.getTimer
local mRand					= math.random
local mAbs					= math.abs
local mFloor				= math.floor
local mCeil					= math.ceil
local strGSub				= string.gsub
local strSub				= string.sub
local strMatch				= string.match
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
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale

local RGTiled = ssk.tiled; local files = ssk.files
local factoryMgr = ssk.factoryMgr; local soundMgr = ssk.soundMgr
--
local movep = ssk.actions.movep

-- =============================================================
-- Locals
-- =============================================================

-- =============================================================
-- Forward Declarations
-- =============================================================

-- =============================================================
-- public Module Begins
-- =============================================================
local trail = {}

function trail.line( obj, params )
	params = parms or {}
	local color = params.color or _K_
	local alpha = params.alpha or 0.8
	local width = params.width or 2
	local segmentLen = params.segmentLen or 0
	local group = params.group or obj.parent
	local anchorY = params.anchorY or 1
	local anchorX = params.anchorX or 0.5

	obj.myTrail = obj.myTrail or {}
	--
	local lastTrailVertex = obj.lastTrailVertex
	local vertex = { x = obj.x, y = obj.y }
	--
	if( not lastTrailVertex ) then
		obj.lastTrailVertex = vertex
		return
	end
	--
	local vec = subVec( lastTrailVertex, vertex )
	local len = lenVec(vec)
	if( len > segmentLen ) then
		local angle = vector2Angle( vec )
		local segment = newImageRect( group, obj.x, obj.y, "images/fillW.png",
			{ w = width, h = len, fill = color, alpha = alpha,
			  anchorY = anchorY, anchorX = anchorX, rotation = angle } )
		--
		obj.lastTrailVertex = vertex
		return segment
	end
	return nil
end

return trail