require "physics"
physics.start( )
require "ssk2.loadSSK"
_G.ssk.init( { launchArgs  = ..., 
           gameFont  = "Raleway-Light.ttf",
           measure  = true,
           math2DPlugin  = false,
           enableAutoListeners  = true,
           exportColors  = true,
           exportCore  = true,
           exportSystem  = true,
           debugLevel  = 0 } )


print("Done")


ssk.display.newImageRect( group, centerX - 100 , centerY - 50,
              "assets/elephant.png", 
              { size = 40 }, 
              { radius = 20, bounce = 1, gravityScale = 0.2 } ) 


ssk.display.newImageRect( group, centerX - 100, centerY + 100, 
              "assets/giraffe.png", 
              { size = 40 }, 
              { bodyType = "static" } ) 