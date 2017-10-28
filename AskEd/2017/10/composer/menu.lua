-- =============================================================
-- Your Copyright Statement Here, YYYY-YYYY
-- =============================================================
-- Main Menu
-- =============================================================
local composer       = require( "composer" )
local scene          = composer.newScene()

----------------------------------------------------------------------
--                      LOCALS                        --
----------------------------------------------------------------------
-- Variables
local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Forward Declarations
local gotoGame
local gotoHighScores

----------------------------------------------------------------------
--  Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create(event) 
   local sceneGroup = self.view
   local background = display.newImageRect( sceneGroup, "protoBack2.png", 380*2, 570*2 )
   background.x = centerX
   background.y = centerY
end
 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function scene:show( event )
  local sceneGroup = self.view
  local phase = event.phase
  if ( phase == "will" ) then
  elseif ( phase == "did" ) then
  end
end
 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function scene:hide( event )
  local sceneGroup = self.view
  local phase = event.phase
   if ( phase == "will" ) then
  elseif ( phase == "did" ) then
  end
end
 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function scene:destroy( event )
  local sceneGroup = self.view
end
 

----------------------------------------------------------------------
-- LOCAL FUNCTION DEFINITIONS (forward declared at top)
----------------------------------------------------------------------
gotoGame = function() 
end

gotoHighScores = function() 
   composer.gotoScene("highscores")
end


--------------------------------------------------------------------------------
-- Listener setup
--------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
--------------------------------------------------------------------------------
return scene