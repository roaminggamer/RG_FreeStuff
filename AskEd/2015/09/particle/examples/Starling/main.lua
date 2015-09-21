-- ==
--		One By One Design (Starling Format) Examples
-- ==
local pex = require "pex"


-- ==========================================
-- 1. Use default particle supplied with example
-- ==========================================
local emitter1 = pex.loadStarling( nil, 150, 200, 
						     "emitters/Starling/particle3.pex",
						      { texturePath = "emitters/Starling/" } )
emitter1.rotation = -45

-- ==========================================
-- 2. Use alternative image in same folder and emitter data
-- ==========================================
local emitter2 = pex.loadStarling( nil, 330, 200, 
						     "emitters/Starling/particle3.pex",
						      { texturePath = "emitters/Starling/",
						      altTexture = "splat.png" } )
emitter2.rotation = 45


-- ==========================================
-- 3. Use alternative image in separate folder
-- ==========================================
local emitter3 = pex.loadStarling( nil, 240, 150,
						     "emitters/Starling/particle3.pex",
						      { altTexture = "images/star.png" } )
