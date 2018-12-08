-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local cover          = require "scripts.cover"

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
local allowClick = false
local content

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willShow( event )
	local sceneGroup = self.view
	--	   
   content = display.newGroup()
   sceneGroup:insert(content)
   
	-- Create a simple background
	local back = display.newImageRect( content, "images/protoBack.png", 380*2, 570*2 )
	back.x = centerX
	back.y = centerY
	if(fullw>fullh) then back.rotation = 90 end

	-- Create a label showing which scene this is
	local label = display.newEmbossedText( content, "Scene 2", centerX, centerY, native.systemFont, 60 )

   -- Add touch listener to background to switch scenes

   function back.touch ( self, event )
   	if( event.phase ~= "ended" ) then return false end
   	---
      if( allowClick == false ) then return false end
	   --   
	   allowClick = false
	   --
		local curtains = cover.new( { math.random(), math.random(), math.random()  } )

	   local function onComplete()
			allowClick = true
			local options =
			{
				params =
				{
					curtains = curtains
				}
			}
			composer.gotoScene( "scenes.scene1", options  )	
		end

		curtains:close(onComplete)
		return true
	end

	back:addEventListener("touch")

   -- Enable clicking
	allowClick = true
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didShow( event )
	local sceneGroup = self.view
	--
	if( event.params and event.params.curtains ) then 
		event.params.curtains:open()
	end	
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willHide( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didHide( event )
	local sceneGroup = self.view
	display.remove( content )
	content = nil
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
-- None

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willShow( event )
	elseif( willDid == "did" ) then
		self:didShow( event )
	end
end
function scene:hide( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willHide( event )
	elseif( willDid == "did" ) then
		self:didHide( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
