
local function doit( task )
	if( task == "split" ) then
		local Hojadedatos =
		{
		   width = 767,
		   height = 148,
		   numFrames = 60,  
		   sheetContentWidth = 7670,
		   sheetContentHeight = 888,
		}

		local Hoja1 = graphics.newImageSheet( "presplit.png", Hojadedatos )

		for i = 1, 60 do
			local obj = display.newImageRect( Hoja1, i, 768, 148 )  
			obj.x = display.contentCenterX
			obj.y = display.contentCenterY
			timer.performWithDelay( i * 100, function()  display.save( obj, i .. ".png" ) end )
		end


	elseif( task == "orig" ) then
		local Hojadedatos =
		{
		    width = 767,
		   height = 148,
		   numFrames = 60,  
		   sheetContentWidth = 7670,
		   sheetContentHeight = 888,
		}

		local Hoja1 = graphics.newImageSheet( "HojaIntroAnimacion.png", Hojadedatos )

		local secuenciadedatos =
		{
		 name="AnimarIntro",
		 start = 1, 
		 count = 60,
		 time=3000,        
		 loopCount = 0,    
		 loopDirection = "forward",    
		}

		local function Reproducir( event )

		local Intro = display.newSprite(Hoja1,secuenciadedatos )
		Intro.x=500
		Intro.y=300
		Intro:setSequence( "AnimarIntro" )
		Intro:play()

		end
		  
		timer.performWithDelay( 5000, Reproducir )

	elseif( task == "updated" ) then
		local data    = require("smaller")
		
		local Hoja1 = graphics.newImageSheet( "smaller.png", data:getSheet() )
		
		local secuenciadedatos =
		{
		    name="AnimarIntro",
		    start=1,
		    count=60,
		    time=3000,
		    loopCount = 0, 
		    loopDirection = "forward"
		}

		local Intro = display.newSprite(Hoja1,secuenciadedatos )
		Intro.x=500
		Intro.y=300
		Intro:setSequence( "AnimarIntro" )
		Intro:play()

	end
end
doit( "updated" ) 