-- =============================================================
-- Initialize sound manager and other game stuff all at once ...
-- =============================================================
-- Print to console immediately.
--
io.output():setvbuf("no") 

-- Hide that pesky bar
--
display.setStatusBar(display.HiddenStatusBar)  

-- Load globals right away
require "scripts.globals"

-- Load OOP buttons
require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"

-- Turn on debug output for composer + Various other settings
--
local composer 	= require "composer" 
composer.isDebug = true
--composer.recycleOnLowMemory = false
--composer.recycleOnSceneChange = true


-- Need multi-touch?  Enable it now.
--
--system.activate("multitouch") 

--local physics = require "physics"
--physics.setGravity( 0, 10 )
--physics.setDrawMode( "hybrid" )


--
-- Initialize sound library
--
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

