local composer = require "composer";
local loadsave = require "scene.loadsave";
local json = require "json";

local buttonName;
local winning = false;
local delay = -1;
local tileCounter = 0;
local counterText;
local counterDelay = 2;
local saveData;
local level;
local world;
local sceneGroup;
local yellowStar;
local purpleStar;

local comments = {"Awesome", "Great job", "Success", "Well done", "Good work", "Nice", "Excellent", "Amazing", "Fantastic"};

math.randomseed(os.time());

local function exitMenu(button)
	local fadeTime = 400;
	
	if button.restart then
		buttonName = "restart";
	elseif button.levelSelect then
		buttonName = "levelSelect";
	elseif button.play then
		fadeTime = 100;
		buttonName = "play";
	else
		buttonName = "next";
	end

	composer.hideOverlay(true, "fade", fadeTime);
end

local function frameEvent()
	if (counterText.text ~= nil) and (winning) then
		if delay > 0 then
			delay = delay - 1;
		end

		if delay == 0 then
			if counterDelay > 0 then
				counterDelay = counterDelay - 1;
			else
				local worldData = json.decodeFile(system.pathForFile("scene/data/data-world.json", system.ResourceDirectory));

				counterDelay = 2;
				counterText.text = tonumber(counterText.text) + 1;
				
				if tonumber(counterText.text) == #_passedOver then
					delay = -1;
				end

				--print(type(worldData), type(worldData[world]));
				--print(type(worldData[world].normalStarScores), type(worldData[world].normalStarScores[level]));
				
				if tonumber(counterText.text) == tonumber(worldData[world].normalStarScores[level]) then
					saveData[tostring(world)].normalStars[level] = 1;
					yellowStar.alpha = 1;
				end
			end
		end
	end
end

local scene = composer.newScene();

function scene:create(event)
	local sceneGroup = self.view;
	
	local params = event.params;
	local showPlayButton = false;
	local y = display.actualContentHeight - 96;
	level = params.levelNum;
	world = params.worldNum;
	
	if params.deadState == params.winState then
		showPlayButton = true;
	end
	
	local menuRect = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, 240, display.actualContentHeight);
	menuRect:setFillColor(0, 0, 0);
	menuRect.alpha = 1;
	
	local shadeRect = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight);
	shadeRect:setFillColor(0, 0, 0);
	shadeRect.alpha = 0.4;
	
	local menuText = display.newText{text = "", x = display.contentCenterX, y = display.screenOriginY + 96, font = native.systemFont, fontSize = 24};
	
	counterText = display.newText{text = "0", x = display.contentCenterX, y = display.contentCenterY, font = native.systemFont, fontSize = 18};
	counterText.alpha = 0;
	
	local restartButton = display.newImageRect(sceneGroup, _graphicsPath.."restart.png", 32, 32);
	restartButton.y = y;

	local levelSelectButton = display.newImageRect(sceneGroup, _graphicsPath.."level-select.png", 32, 32);
	levelSelectButton.y = y;

	function restartButton:tap(event)
		exitMenu{restart = true};
	end
	
	function levelSelectButton:tap(event)
		exitMenu{levelSelect = true};
	end

	restartButton:addEventListener("tap");
	levelSelectButton:addEventListener("tap");
	
	local bigStar = display.newImageRect(sceneGroup, "scene/graphics/big-star.png", 34, 32);
	bigStar.x = display.contentCenterX;
	bigStar.y = display.contentCenterY - 32;
	bigStar.alpha = 0;
	
	yellowStar = display.newImageRect(sceneGroup, "scene/graphics/star-reached.png", 34, 32);
	yellowStar.x = display.contentCenterX;
	yellowStar.y = display.contentCenterY - 32;
	yellowStar.alpha = 0;
	
	--[[purpleStar = display.newImageRect(sceneGroup, "scene/graphics/star-reverse-reached.png", 34, 32);
	purpleStar.x = display.contentCenterX;
	purpleStar.y = display.contentCenterY - 32;
	purpleStar.alpha = 0;]]--
	
	
	if (showPlayButton) or (params.winState) then
		if showPlayButton then
			local playButton = display.newImageRect(sceneGroup, _graphicsPath.."play.png", 32, 32);
			playButton.x = display.contentCenterX + 64;
			playButton.y = y;
			
			function playButton:tap(event)
				exitMenu{play = true};
			end
			
			playButton:addEventListener("tap");
		else
			local nextButton = display.newImageRect(sceneGroup, _graphicsPath.."next.png", 32, 32);
			nextButton.x = display.contentCenterX + 64;
			nextButton.y = y;
			
			function nextButton:tap(event)
				exitMenu{next = true};
			end
			
			nextButton:addEventListener("tap");
		end
		
		restartButton.x = display.contentCenterX - 64;
		levelSelectButton.x = display.contentCenterX;
	else
		restartButton.x = display.contentCenterX - 32;
		levelSelectButton.x = display.contentCenterX + 32;
	end
	
	if params.deadState then
		menuText.text = "Uh-oh";
	elseif params.winState then
		menuText.text = comments[math.random(#comments)].."!";
		
		saveData = loadsave.loadTable("data-save.json");
		
		if level < 6 then
			saveData[tostring(world)].states[level + 1] = 1;		
		end
		
		winning = true;
		counterText.alpha = 1;
		bigStar.alpha = 1;
		
		print("win state");
	else
		menuText.text = "Paused";
	end
	
	sceneGroup:insert(menuText);
	sceneGroup:insert(counterText);
end

function scene:show(event)
	local sceneGroup = self.view;
	local phase = event.phase;

	if phase == "will" then
		delay = 30;
		
		Runtime:addEventListener("enterFrame", frameEvent);
	elseif phase == "did" then

	end
end
 
function scene:hide(event)
	local sceneGroup = self.view;
	local phase = event.phase;

	if phase == "will" then
		local parent = event.parent;
		
		if saveData ~= nil then
			loadsave.saveTable(saveData, "data-save.json");
		end

		parent:resume(buttonName);
	elseif phase == "did" then
		Runtime:removeEventListener("frame", frameEvent);
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