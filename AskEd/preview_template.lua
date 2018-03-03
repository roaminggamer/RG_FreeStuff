-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local root 	  = "answerpath"
local baseDir = system.DocumentsDirectory
-- =============================================================
local hCommon		= require "scripts.common" -- Harness Common
local physics 		= require "physics"

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua Functions
local getTimer          = system.getTimer
local mRand					= math.random
local mAbs					= math.abs
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

local RGTiled = ssk.tiled
local newText = display.newText

-- =============================================================
-- Locals
-- =============================================================
local layers
local lastTimer
local isRunning 

-- =============================================================
-- Module Begins
-- =============================================================
local game = {}

function game.create( group, params )
	group = group or display.currentStage
	params = params or {}
	--
	isRunning = false
	--
	display.remove( layers )
	--
	layers = quickLayers( group, "background", "content", "enemies", "player", "interfaces" )
	--
	--physics.start()
	--physics.setGravity( 0, 0 )
	--physics.setDrawMode("normal")
	--physics.setDrawMode("hybrid")
	--
	--local tmp = newImageRect( layers.player, centerX, centerY, "images/misc/kenney1.png", { baseDir = baseDir, size = playerSize } )
	--
	
	--physics.pause()
end

function game.start()
	isRunning = true
	--physics.start()
end

function game.stop()
	isRunning = false
	--physics.pause()
end

function game.destroy()
	game.stop()
	--
	if( lastTimer ) then
		timer.cancel(lastTimer)
		lastTimer = nil
	end	
	--
	display.remove( layers )
	layers = nil
end

return game



