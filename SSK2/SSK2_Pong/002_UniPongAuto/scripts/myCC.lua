-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- myCC.lua - Collision Settings
-- =============================================================
local myCC = ssk.cc:newCalculator()

myCC:addNames( "ball", "paddle", "wall", "trigger" )

myCC:collidesWith( "ball", { "paddle", "wall", "trigger" } )


return myCC
