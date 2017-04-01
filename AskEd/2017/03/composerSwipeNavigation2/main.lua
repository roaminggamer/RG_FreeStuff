--require "ssk.loadSSK"
-- =============================================================
-- main.lua
-- =============================================================

require "composerExt"  -- Require once befor first loading or using composer

local composer 	= require "composer" 

io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)  

--system.activate("multitouch") 

-- List scenes in order you want them linked
local sampleScenes = 
	{ 
		"scenes.apple",  
		"scenes.banana", 
		"scenes.cherry",
	}
composer.initSwipe( sampleScenes, 
					{ loop = true,
					  swipeDist = 10,
					  maxVertical = 20,
					  --nextOptions = { effect = "fromRight", time = 250, },
					  --prevOptions = { effect = "fromLeft", time = 250, },					
					  --alwaysTo = "front",
					  --alwaysTo = "back",
					} )

--local swiper = composer.createSwipe()
--display.remove(swiper)

composer.gotoScene( "scenes.apple" )
--composer.gotoScene( "ifc.mainMenu" )
