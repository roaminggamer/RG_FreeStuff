-- ==
--		One By One Design (Starling Format) Examples
-- ==
local pex = require "pex"

-- ==========================================
-- 1. Load an emitter exported/sent from Roaming Gamer Particle Editor (link here)
-- ==========================================
local emitter1 = pex.loadRG( nil, 100, 160, 
						     "emitters/RG/emitter16178.rg",
						      { texturePath = "emitters/RG/" } )


-- ==========================================
-- 2. Use alternative image in same folder and emitter data
-- ==========================================
local emitter2 = pex.loadRG( nil, 380, 160, 
						     "emitters/RG/emitter16178.rg",
						      { texturePath = "emitters/RG/",
						      altTexture = "particle78348.png" } )


-- ==========================================
-- 3. Use alternative image in separate folder
-- ==========================================
local emitter3 = pex.loadRG( nil, 240, 150,
						     "emitters/RG/emitter16178.rg",
						       { altTexture = "images/star.png" } )
