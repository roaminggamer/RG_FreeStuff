io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================


local bingoCard = require "bingoCard"

bingoCard.create( nil, centerX, centerY, 
                  { 	cellColor1 = hexcolor("404080"), 
	               	cellColor2 = hexcolor("808040"),
	               	strokeColor = hexcolor("FF8040"),
	               	numberColor = hexcolor("80DDFF"),  
	               	bingoColor = hexcolor("FFFFFF"),
	               	randomize = true, 
	               } )

