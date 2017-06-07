local composer = require "composer";
local scene = composer.newScene(); --create the sccene

function scene:create(event)
	local sceneGroup = self.view;
	local tmp = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, 10000, 1000)
	
	-- Change Color To Whatever You Want
	tmp:setFillColor( 0, 1, 0 )

end


function scene:show(event)
	local sceneGroup = self.view;
	local phase = event.phase;
	if phase == "will" then
	elseif phase == "did" then
		print("SHOWED REFRESH")
		composer.gotoScene("scene.game");
	end
end
 

scene:addEventListener("create", scene);
scene:addEventListener("show", scene);

return scene