-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- myCC.lua - Collision Settings
-- =============================================================
local myCC = ssk.cc:newCalculator()
myCC:addNames( "player", "wall", "trigger", "coin", "gate", "platform" )
myCC:collidesWith( "player", { "wall", "trigger", "coin", "gate", "platform" } )
return myCC
