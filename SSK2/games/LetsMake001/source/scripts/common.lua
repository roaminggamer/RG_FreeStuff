-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- common.lua - Common Settings Module
-- =============================================================
local common = {}

-- Game Logic Settings
common.gameIsRunning 			= false
common.creationStartCount 		= 6

common.cellSize					= 40
common.cols 		  				= 21
common.rows 		  				= 14

common.gemTime 					= 10000
common.enemyTime 					= 6000

common.enemySize 					= 70
common.enemyAnimTime				= 100
common.enemySpeed 				= 125
common.enemyTurnRate 			= 180
common.enemyDirectionTime 		= 250
common.enemyDirectionEasing	= easing.linear

-- Various Game Metrics & Settings
common.score 						= 0
common.coins 						= 0
common.coinSize					= 20
common.coinTime					= 5000

common.enemies = {}

-- World Settings
common.gravityX 					= 0
common.gravityY 					= 0

-- Player Settings
common.playerSize 				= 60
common.playerAnimTime			= 100
common.playerSpeed 				= 175
common.playerTurnRate 			= 180
common.playerDirectionTime 	= 250
common.playerDirectionEasing	= easing.linear
common.playerFirePeriod 		= 100
common.playerBulletSpeed 		= common.playerSpeed * 4
common.playerBulletLife			= 4000
common.bulletType 				= 1
common.bulletColors				= { hexcolor("#c61c08"), 
                                  hexcolor("#2bbc00"), 
                                  hexcolor("#b5aeb5") }
common.bulletTrailColors		= { hexcolor("#c61c0880"), 
                                  hexcolor("#2bbc0080"), 
                                  hexcolor("#b5aeb580") }
common.bulletNames				= { "Fire", "Poison", "Lightning" }
common.poisonTime 				= 1500
common.lightningDistance 		= 150

return common
