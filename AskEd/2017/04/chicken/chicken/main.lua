
display.setStatusBar( display.HiddenStatusBar )


--EFM
_G.centerX = display.contentCenterX       -- Horizontal center of screen
_G.centerY = display.contentCenterY       -- Vertical center of screen
_G.w = display.contentWidth               -- Content width (specified in config.lua)
_G.h = display.contentHeight              -- Content height (specified in config.lua)
_G.fullw = display.actualContentWidth     -- May be wider or more narrow than content width.
_G.fullh = display.actualContentHeight    -- May be taller or shorter than content height.
_G.left = centerX - fullw/2               -- True left-edge of screen
_G.right = left + fullw                   -- True right-edge of screen
_G.top = centerY - fullh/2                -- True top-edge of screen
_G.bottom = top + fullh                   -- True bottom-edge of screen

local physics = require "physics"
physics.start() --EFM
physics.setGravity(0,0) --EFM


local composer = require( "composer" )
print("entering gotoScene")
composer.gotoScene( "game2" )
print("out from gotoScene")
