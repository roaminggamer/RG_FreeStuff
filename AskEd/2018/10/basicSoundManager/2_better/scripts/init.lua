-- =============================================================
-- Initialize sound manager and other game stuff all at once ...
-- =============================================================

local soundMgr 	= require "scripts.soundMgr"
soundMgr.addMusic( "soundtrack", "sounds/music/Kick Shock.mp3" )

soundMgr.addEffect( "count_1", "sounds/sfx/counting/count_1.mp3" )
soundMgr.addEffect( "count_2", "sounds/sfx/counting/count_2.mp3" )
soundMgr.addEffect( "count_3", "sounds/sfx/counting/count_3.mp3" )
soundMgr.addEffect( "count_4", "sounds/sfx/counting/count_4.mp3" )
soundMgr.addEffect( "count_5", "sounds/sfx/counting/count_5.mp3" )
soundMgr.addEffect( "count_6", "sounds/sfx/counting/count_6.mp3" )
soundMgr.addEffect( "count_7", "sounds/sfx/counting/count_7.mp3" )
soundMgr.addEffect( "count_8", "sounds/sfx/counting/count_8.mp3" )
soundMgr.addEffect( "count_9", "sounds/sfx/counting/count_9.mp3" )

-- Set Music Volume Low
soundMgr.setVolume( "music", 0.25 )

-- Start Soundtrack
post( "onSound", { sound = "soundtrack", loops = -1, fadein = 3000 } )
