-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- =============================================================
local composer    = require "composer"
local easyButton  = require "easyButton"

-- =============================================================
-- Localizations
-- =============================================================
-- none

-- =============================================================
-- =============================================================
-- =============================================================

----------------------------------------------------------------------
-- Forward Declarations
----------------------------------------------------------------------
-- none

----------------------------------------------------------------------
-- Locals
----------------------------------------------------------------------
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local fullw   = display.actualContentWidth
local fullh   = display.actualContentHeight
local left    = centerX - fullw/2
local right   = centerX + fullw/2
local top     = centerY - fullh/2
local bottom  = centerY + fullh/2


----------------------------------------------------------------------
-- Module
----------------------------------------------------------------------
local mod = {}
function mod.createContent( group, num )
   local back = display.newImageRect( group, "back" .. num .. ".png", 720, 1386 )   
   back.x = centerX
   back.y = centerY
   back.rotation = (fullw>fullh) and 90 or 0
   local title =  display.newText( group, "SCENE " .. num , centerX, top + 30, _G.fontB, 50 )

   local excludeScene = num

   for i = 1, 4 do
      if( i ~= excludeScene ) then
         local button = display.newImageRect( group, "button1.png", 80, 80 )
         button.x = centerX 
         button.y = centerY - 360 + (i * 140)
         easyButton.easyPush( button, function() composer.gotoScene( "scene" .. i,  { time = 500, effect = "crossFade" } ) end )
         button.label = display.newText( group, "Go To Scene " .. i, button.x, button.y + 55 , _G.fontN, 22)
      end
   end

   local backButton = display.newImageRect( group, "button2.png", 80, 80 )
   backButton.x = left + 50 
   backButton.y = top + 50
   easyButton.easyPush( backButton, 
      function() 
         local prev = composer.getSceneName( "previous" )
         if( prev ) then
            composer.gotoScene( prev,  { time = 500, effect = "crossFade" } ) 
         end
      end )

end

return mod
