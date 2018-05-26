io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { } )
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local easyButton  = require "easyButton"
--
_G.fontN 	= "Roboto-Regular.ttf" --native.systemFont
_G.fontB 	= "TitanOne-Regular.ttf" --native.systemFontBold
--
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local fullw   = display.actualContentWidth
local fullh   = display.actualContentHeight
local left    = centerX - fullw/2
local right   = centerX + fullw/2
local top     = centerY - fullh/2
local bottom  = centerY + fullh/2
--
local group = display.newGroup()
--
local click = audio.loadSound( "click.wav" )
local coin = audio.loadSound( "coin.wav" )
local music = audio.loadStream( "Kick Shock.mp3" )

local button = display.newImageRect( group, "button1.png", 80, 80 )
button.x = centerX 
button.y = centerY - 360
easyButton.easyPush( button, function() audio.setVolume(1) end )
button.label = display.newText( group, "Set Volume 1", button.x, button.y + 55 , _G.fontN, 22)

local button = display.newImageRect( group, "button1.png", 80, 80 )
button.x = centerX 
button.y = centerY - 360 + 1 * 140
easyButton.easyPush( button, function() audio.setVolume(0) end )
button.label = display.newText( group, "Set Volume 0", button.x, button.y + 55 , _G.fontN, 22)

local button = display.newImageRect( group, "button1.png", 80, 80 )
button.x = centerX 
button.y = centerY - 360 + 2 * 140
easyButton.easyPush( button, function() audio.stop()  end )
button.label = display.newText( group, "Stop All", button.x, button.y + 55 , _G.fontN, 22)

local button = display.newImageRect( group, "button1.png", 80, 80 )
button.x = centerX 
button.y = centerY - 360 + 3 * 140
easyButton.easyPush( button, function() audio.play( click, { loops = -1 } )  end )
button.label = display.newText( group, "Play Click; loops == -1", button.x, button.y + 55 , _G.fontN, 22)

local button = display.newImageRect( group, "button1.png", 80, 80 )
button.x = centerX 
button.y = centerY - 360 + 4 * 140
easyButton.easyPush( button, function() audio.play( coin ) end )
button.label = display.newText( group, "Play Coin Once", button.x, button.y + 55 , _G.fontN, 22)

local button = display.newImageRect( group, "button1.png", 80, 80 )
button.x = centerX 
button.y = centerY - 360 + 5 * 140
easyButton.easyPush( button, function() audio.play( music, { fadein = 5000 } )  end )
button.label = display.newText( group, "Play Music; fadein == 5000", button.x, button.y + 55 , _G.fontN, 22)


