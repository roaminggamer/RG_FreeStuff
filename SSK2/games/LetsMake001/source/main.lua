-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua
-- =============================================================
-- Lets Make 001
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            gameFont 				= "AdelonSerial.ttf",
	            debugLevel 				= 0 } )
-- =============================================================
-- Optionally enable meters to check FPS and Memory usage.
-- =============================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
-- =============================================================
local common 		= require "scripts.common"
local game 			= require "scripts.game"
local factoryMgr 	= require "scripts.factories.factoryMgr"
local soundMgr		= ssk.soundMgr

--
-- Initialize Sound
--
if( soundMgr ) then
	soundMgr.setDebugLevel(1)
	soundMgr.enableSFX(true)
	soundMgr.enableMusic(true)
	soundMgr.setVolume( 0.25, "music" )
	soundMgr.addEffect( "coin", "sounds/sfx/coin.wav")
	soundMgr.addEffect( "gate", "sounds/sfx/gate.wav")
	soundMgr.addEffect( "died", "sounds/sfx/died.wav")
	soundMgr.addMusic( "soundTrack", "sounds/music/Rocket.mp3")
	post( "onSound", { sound = "soundTrack", fadein = 750, loops = -1 } )
end

--
-- Register Factories
--
factoryMgr.register( "room", "scripts.factories.room" )
factoryMgr.register( "player", "scripts.factories.player" )

factoryMgr.register( "enemy1", "scripts.factories.enemy1" )
factoryMgr.register( "enemy2", "scripts.factories.enemy2" )

factoryMgr.register( "coin", "scripts.factories.coin" )
factoryMgr.register( "gem", "scripts.factories.gem" )
factoryMgr.register( "coinsHUD", "scripts.factories.coinsHUD" )
factoryMgr.register( "weaponHUD", "scripts.factories.weaponHUD" )
factoryMgr.register( "timeHUD", "scripts.factories.timeHUD" )

--
-- Initialize Game & Start
--
game.init()
game.start( nil, { debugEn = false } )
