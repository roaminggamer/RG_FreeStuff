-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- common.lua - Common Settings Module
-- =============================================================
local common = {}

-- Game Logic Settings
common.gameIsRunning 			= false

-- Various Game Metrics & Settings
common.score 						= 0

-- Ball and Paddle Settings
common.ballSpeed					= 300
common.paddleSpeed 				= 800
common.paddleSnapDist			= 15
common.paddleMinY					= top + 80
common.paddleMaxY					= bottom - 80

-- World Settings
common.gravityX 					= 0
common.gravityY 					= 0


-- Colors (player and gate)
common.green						= hexcolor("#4bcc5a")
common.pink							= hexcolor("#d272b4")
common.red							= hexcolor("#ff452d")
common.yellow						= hexcolor("##ffcc00")
common.colors 						= { common.green, common.pink, common.red, common.yellow }
-- Colors (Level and Interface)
common.backFill1					= hexcolor("#49432b")
common.backFill2					= hexcolor("#171717")
return common
