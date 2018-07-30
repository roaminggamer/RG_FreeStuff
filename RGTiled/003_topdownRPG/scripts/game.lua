-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local common 		= require "scripts.common"
local physics 		= require "physics"

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
local behaviors = ssk.behaviors
--if( ssk.misc.countLocals ) then ssk.misc.countLocals(1) end

-- =============================================================
--physics.setDrawMode("hybrid")
-- =============================================================
local builders = {}
local layers
local onLevelComplete
local onKillPlayer

-- =============================================================
-- Module
-- =============================================================
local game = {}

function game.create( group, params )
	group = group or display.currentStage
	params = params or {}
	--	
	local level = params.level or 1
	local maxLevels = params.maxLevels or 1

	game.destroy()

	game.nextLevel( group, level )

	onLevelComplete = function ( event )
		nextFrame( function() 
			level = level + 1 
			if( level > maxLevels ) then 
				level = 1
			end
			game.nextLevel( group, level ) 
		end )
	end; listen("onLevelComplete", onLevelComplete)

	onKillPlayer = function ( event )
		nextFrame( function() game.nextLevel( group, level ) end )
	end; listen("onKillPlayer", onKillPlayer)

end

function game.nextLevel( group, num ) 
	levelToLoad = "level" .. num 

	display.remove(layers)

	layers = quickLayers( group, 
		"underlay",
		"world",
			{ "background", "content", "foreground" },
		"overlay")

	--
	-- Load and process level records
	--
	local loader = RGTiled.getLevel( levelToLoad, { levelPath = "levels" } )

	--
	-- Process Logic Records (if any)
	--
	local function processLogicRecord( rec )
		--
		-- Easy Input Helpers
		--
		if( loader.getProperty( rec, "easyInput") ) then
			local helper = string.lower(loader.getProperty( rec, "easyInput"))
			local debugEn = loader.getProperty( rec, "debugEn")
			local keyboardEn = loader.getProperty( rec, "keyboardEn")
			local doNorm = loader.getProperty( rec, "doNorm")

			if( helper == "onetouch" ) then
				ssk.easyInputs.oneTouch.create(layers.underlay, { debugEn = debugEn, keyboardEn = keyboardEn } )

			elseif( helper  == "twotouch" ) then
				ssk.easyInputs.twoTouch.create(layers.underlay, { debugEn = debugEn, keyboardEn = keyboardEn } )
			
			elseif( helper  == "onestick" ) then
				ssk.easyInputs.oneStick.create( layers.underlay, { debugEn = debugEn, joyParams = { doNorm = doNorm } } )
			
			elseif( helper  == "twostick" ) then
				ssk.easyInputs.twoStick.create( layers.underlay, { debugEn = debugEn, joyParams = { doNorm = doNorm } } )
			
			elseif( helper  == "onestickonetouch" ) then				
				ssk.easyInputs.oneStickOneTouch.create( layers.underlay, { debugEn = debugEn, joyParams = { doNorm = doNorm } } )

			else
				print("Unknown 'easyInput' Helper: ", helper )
			end
		end
	end
	loader.forEachLogic( processLogicRecord )

	--
	-- Draw Level
	--
	loader.draw( layers, 
					{ ox = -unusedWidth/2, oy = unusedHeight/2,
					builders = builders, behaviors = behaviors,
					showGID = false, num = index, numberFill = _G_ } )	
end

function game.destroy()
	if( onLevelComplete ) then
		ignore( "onLevelComplete", onLevelComplete )
		onLevelComplete = nil 
	end
	if( onKillPlayer ) then
		ignore( "onKillPlayer", onKillPlayer )
		onKillPlayer = nil 
	end
end

return game
