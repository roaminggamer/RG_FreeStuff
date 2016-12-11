-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- myCC.lua - Collision Settings
-- =============================================================
local myCC = ssk.cc:newCalculator()

myCC:addNames( "player", "wall", "trigger", "coin", "pbullet", "ebullet", "enemy", "gem" )

myCC:collidesWith( "player", { "wall", "trigger", "coin", "ebullet", "gem" } )

myCC:collidesWith( "enemy", { "player", "pbullet" } )

return myCC
