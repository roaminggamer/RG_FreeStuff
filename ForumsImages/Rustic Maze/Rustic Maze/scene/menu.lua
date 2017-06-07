local composer = require "composer";

local scene = composer.newScene();

function scene:create(event)
	local sceneGroup = self.view;
	
	local prev = composer.getSceneName("previous");
	
	if prev ~= nil then
		composer.removeScene(prev);
	end
	
	local titleText = display.newText{text = "Rustic Maze", x = display.contentCenterX, y = display.contentCenterY - 128, font = system.nativeFont, fontSize = 48};
	local startButton = display.newText{text = "Press to Start", x = display.contentCenterX, y = display.contentCenterY + 96, font = system.nativeFont, fontSize = 18};
	
	function startButton:tap(event)
		--composer.gotoScene("scene.game", {effect = "crossFade", time = 400});
		composer.gotoScene("scene.levelSelect", {effect = "crossFade", time = 400, params = {}});
	end
	
	startButton:addEventListener("tap");
	
	sceneGroup:insert(titleText);
	sceneGroup:insert(startButton);
end

function scene:show(event)
	local sceneGroup = self.view;
	local phase = event.phase;

	if phase == "will" then

	elseif phase == "did" then

	end
end
 
function scene:hide(event)
	local sceneGroup = self.view;
	local phase = event.phase;

	if phase == "will" then

	elseif phase == "did" then

	end
end

function scene:destroy(event)
	local sceneGroup = self.view;
end

scene:addEventListener("create", scene);
scene:addEventListener("show", scene);
scene:addEventListener("hide", scene);
scene:addEventListener("destroy", scene);

return scene