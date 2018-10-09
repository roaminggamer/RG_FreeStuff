
Hojadedatos =
{
    width = 767,
   height = 148,
   numFrames = 60,  
   sheetContentWidth = 7670,
   sheetContentHeight = 888,
}

Hoja1 = graphics.newImageSheet( "HojaIntroAnimacion.png", Hojadedatos )

secuenciadedatos =
{
 name="AnimarIntro",
 start = 1, 
 count = 60,
 time=3000,        
 loopCount = 0,    
 loopDirection = "forward",    
}

local function Reproducir( event )

Intro = display.newSprite(Hoja1,secuenciadedatos )
Intro.x=500
Intro.y=300
Intro:setSequence( "AnimarIntro" )
Intro:play()

end
  
timer.performWithDelay( 5000, Reproducir )