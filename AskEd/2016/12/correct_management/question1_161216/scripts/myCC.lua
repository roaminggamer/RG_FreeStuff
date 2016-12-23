-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- myCC.lua - Collision Settings
-- =============================================================
local myCC = ssk.cc:newCalculator()

--
-- Generic Collision Calculator - Not all types used in all examples
--
--  player - The player object
--
--    wall - Any boundary object (collision with it typically kills player)
--
-- trigger - A sensor object used to activate the 'generate/load next segment' logic.
--
--    coin - An object to pick up.
--
--    gate - A sensor object used to activate some kind of game progression 
--           logic on collision.
--
--    platform - An object the player can collide with (typically will
--               not kill player).


myCC:addNames( "player", "wall", "trigger", "coin", "gate", "platform" )

myCC:collidesWith( "player", { "wall", "trigger", "coin", "gate", "platform" } )


return myCC
