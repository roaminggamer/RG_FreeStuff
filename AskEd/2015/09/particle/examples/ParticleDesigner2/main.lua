-- ==
--		Particle Designer 2 Examples
-- ==
local pex = require "pex"


-- ==========================================
-- 1. Use default particle supplied with example
-- ==========================================
local emitter1 = pex.loadPD2( nil, 200, 100, 
						     "emitters/ParticleDesigner2/Comet.json",
						      { texturePath = "emitters/ParticleDesigner2/" } )
emitter1.rotation = 45


-- ==========================================
-- 2. Use alternative image in same folder and emitter data
-- ==========================================
local emitter2 = pex.loadPD2( nil, 280, 100, 
						     "emitters/ParticleDesigner2/Comet.json",
						      { texturePath = "emitters/ParticleDesigner2/",
						        altTexture = "texture.png" } )
emitter2.rotation = 215



-- ==========================================
-- 3. Use alternative image in separate folder
-- ==========================================
local emitter3 = pex.loadPD2( nil, 240, 200, 
						     "emitters/ParticleDesigner2/Comet.json", 
						     { altTexture = "images/star.png" } )
emitter3.rotation = -45
