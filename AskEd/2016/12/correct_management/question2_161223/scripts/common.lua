-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- common.lua - Common Settings Module
-- =============================================================
local common = {}

-- Game Logic Settings
common.gameIsRunning 			= false
common.creationStartCount 		= 4
common.segmentWidth 		  		= w/2 

-- Various Game Metrics & Settings
common.score 						= 0
common.coins 						= 0
common.distance 					= 0
common.distanceUnits				= "meters"
common.pixelsToDistance 		= 100
common.coinFrequency				= 3
common.coinYOffset				= h/3

-- World Settings
common.gravityX 					= 0
common.gravityY 					= 20

-- Player Settings
common.playerVelocity 			= 250
common.playerImpulse 			= 13

-- Gate Settings
common.gateHeight 				= 120
common.gateWidth 					= 80
common.gateDelta					= fullh - 300

return common
