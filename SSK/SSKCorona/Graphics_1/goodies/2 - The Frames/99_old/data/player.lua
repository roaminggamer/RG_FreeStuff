-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- player.lua
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
--
-- Load last player settings and list of known players
--
-- =============================================================

--
-- CURRENT PLAYER
--
function _G.saveCurrentPlayer()
	table.save(currentPlayer, "lastPlayer.txt", system.DocumentsDirectory )
	table.save(currentPlayer, currentPlayer.name .. "_data.txt", system.DocumentsDirectory )
end

function _G.loadCurrentPlayer( playerName )
	currentPlayer = table.load( playerName .. "_data.txt", system.DocumentsDirectory )
	saveCurrentPlayer()

	-- Configure sound effects and music
	ssk.sounds:stop("bouncing")

	ssk.sounds:setEffectsVolume(currentPlayer.effectsVolume)
	ssk.sounds:setMusicVolume(currentPlayer.musicVolume)

	if(currentPlayer.musicEnabled) then
		ssk.sounds:play("bouncing")
	end

end

function _G.initDefaults()
	currentPlayer.effectsEnabled = false
	currentPlayer.effectsVolume = 0.8
	currentPlayer.musicEnabled = false
	currentPlayer.musicVolume = 0.8
end

_G.currentPlayer = {}

if( io.exists( "lastPlayer.txt", system.DocumentsDirectory ) ) then
	currentPlayer = table.load( "lastPlayer.txt", system.DocumentsDirectory )
else
	currentPlayer.name = "Bob"

	initDefaults()

	saveCurrentPlayer()
end


--
-- KNOWN PLAYERS
--
-- Load list of known players
_G.knownPlayers = {}

function _G.saveKnownPlayers()
	table.save(knownPlayers, "knownPlayers.txt", system.DocumentsDirectory )
end

if( io.exists( "knownPlayers.txt", system.DocumentsDirectory ) ) then
	knownPlayers = table.load( "knownPlayers.txt", system.DocumentsDirectory )
	saveKnownPlayers()
end

if( not knownPlayers[currentPlayer.name] ) then
	knownPlayers[currentPlayer.name] = currentPlayer.name
	initDefaults()
	saveCurrentPlayer()
	saveKnownPlayers()
end














