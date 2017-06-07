local json = require "json";
local composer = require "composer";
local loadsave = require "scene.loadsave";

local STATE_LOCKED = 0;
local STATE_NEW = 1;
local STATE_COMPLETE = 2;

local STAR_INCOMPLETE = 0;
local STAR_NORMAL = 1;
local STAR_REVERSE = 2;

local spacingX = (display.actualContentWidth - 3*32)/2;
local spacingY = (display.actualContentHeight - 160)/3;
local world;

local levelStates = {};
local levelFilenames = {[STATE_LOCKED] = "locked", [STATE_NEW] = "new", [STATE_COMPLETE] = "complete"};
local levelCoords = {};
local starStates = {};
local starFilenames = {[STAR_INCOMPLETE] = "new", [STAR_NORMAL] = "complete", [STAR_REVERSE] = "reverse"};

for k, v in pairs(levelFilenames) do
	levelFilenames[k] = _graphicsPath.."level-"..v..".png";
end

local function enterLevel(level)
	composer.gotoScene("scene.game", {effect = "crossFade", time = 400, params = {levelNum = level, worldNum = world}});
end

local scene = composer.newScene();

function scene:create(event)
	local sceneGroup = self.view;
	
	local prev = composer.getSceneName("previous");
	
	if prev ~= nil then
		composer.removeScene(prev);
	end
	
	local params = event.params;
	world = params.currentWorld or 1;

	--local saveData = json.decodeFile(system.pathForFile("scene/data/data-save.json", system.ResourceDirectory));
	local saveData = loadsave.loadTable("data-save.json");
	local worldData = json.decodeFile(system.pathForFile("scene/data/data-world.json", system.ResourceDirectory));
	
	local backgroundRect = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight);
	backgroundRect:setFillColor(worldData[world].r, worldData[world].g, worldData[world].b);

	local worldText = display.newText{text = "World "..world..": "..worldData[world].name,
		x = display.contentCenterX,
		y = display.screenOriginY + 32,
		font = native.systemFont,
		fontSize = 24};
	
	local backButton = display.newImageRect(sceneGroup, _graphicsPath.."back.png", 32, 32);
	backButton.x = display.contentCenterX;
	backButton.y = display.actualContentHeight - 32;
	
	function backButton:tap(event)
		composer.gotoScene("scene.menu", {effect = "crossFade", time = 400});
	end
	
	backButton:addEventListener("tap");

	for i = 1, 9 do
		local worldIndex = saveData[tostring(world)];
	
		--table.insert(levelStates, saveData[tostring(world)].states[i]);
		--print(saveData[tostring(world)].states[i]);
		table.insert(levelStates, worldIndex.states[i]);
		table.insert(starStates, {worldIndex.normalStars[i], worldIndex.reverseStars[i]});
	end
	
	local specialGraphic;
	
	if levelStates[9] == STATE_LOCKED then
		specialGraphic = "locked-special";
	elseif levelStates[9] == STATE_NEW then
		specialGraphic = "new-special";
	else
		specialGraphic = "complete";
	end
	
	for j = 1, 3 do
		for k = 1, 3 do
			local coords = {};
			
			coords.x = display.contentCenterX - spacingX + spacingX*(k - 1);
			coords.y = display.screenOriginY + 128 + spacingY*(j - 1);
			
			print(coords.x, coords.y);
			
			table.insert(levelCoords, coords);
		end
	end
	
	local level1 = display.newImageRect(sceneGroup, levelFilenames[levelStates[1]], 32, 32);
	--level1.x = display.contentCenterX - spacingX;
	--level1.y = display.screenOriginY + 128;
	
	local level2 = display.newImageRect(sceneGroup, levelFilenames[levelStates[2]], 32, 32);
	--level2.x = display.contentCenterX;
	--level2.y = display.screenOriginY + 128;
	
	local level3 = display.newImageRect(sceneGroup, levelFilenames[levelStates[3]], 32, 32);
	--level3.x = display.contentCenterX + spacingX;
	--level3.y = display.screenOriginY + 128;
	
	local level4 = display.newImageRect(sceneGroup, levelFilenames[levelStates[4]], 32, 32);
	--level4.x = display.contentCenterX - spacingX;
	--level4.y = display.screenOriginY + 128 + spacingY;
	
	local level9 = display.newImageRect(sceneGroup, _graphicsPath.."level-"..specialGraphic..".png", 32, 32);
	--level9.x = display.contentCenterX;
	--level9.y = display.screenOriginY + 128 + spacingY;
	
	local level5 = display.newImageRect(sceneGroup, levelFilenames[levelStates[5]], 32, 32);
	--level5.x = display.contentCenterX + spacingX;
	--level5.y = display.screenOriginY + 128 + spacingY;

	local level6 = display.newImageRect(sceneGroup, levelFilenames[levelStates[6]], 32, 32);
	--level6.x = display.contentCenterX - spacingX;
	--level6.y = display.screenOriginY + 128 + 2*spacingY;
	
	local level7 = display.newImageRect(sceneGroup, levelFilenames[levelStates[7]], 32, 32);
	--level7.x = display.contentCenterX;
	--level7.y = display.screenOriginY + 128 + 2*spacingY;
	
	local level8 = display.newImageRect(sceneGroup, levelFilenames[levelStates[8]], 32, 32);
	--level8.x = display.contentCenterX + spacingX;
	--level8.y = display.screenOriginY + 128 + 2*spacingY;
	
	function level1:tap(event)
		if levelStates[1] > STATE_LOCKED then
			enterLevel(1);
		end
	end
	
	function level2:tap(event)
		if levelStates[2] > STATE_LOCKED then
			enterLevel(2);
		end
	end
	
	function level3:tap(event)
		if levelStates[3] > STATE_LOCKED then
			enterLevel(3);
		end
	end
	
	function level4:tap(event)
		if levelStates[4] > STATE_LOCKED then
			enterLevel(4);
		end
	end
	
	function level9:tap(event)
		if levelStates[9] > STATE_LOCKED then
			enterLevel(9);
		end
	end
	
	function level5:tap(event)
		if levelStates[5] > STATE_LOCKED then
			enterLevel(5);
		end
	end
	
	function level6:tap(event)
		if levelStates[6] > STATE_LOCKED then
			enterLevel(6);
		end
	end
	
	function level7:tap(event)
		if levelStates[7] > STATE_LOCKED then
			enterLevel(7);
		end
	end
	
	function level8:tap(event)
		if levelStates[8] > STATE_LOCKED then
			enterLevel(8);
		end
	end
	
	level1:addEventListener("tap");
	level2:addEventListener("tap");
	level3:addEventListener("tap");
	level4:addEventListener("tap");
	level9:addEventListener("tap");
	level5:addEventListener("tap");
	level6:addEventListener("tap");
	level7:addEventListener("tap");
	level8:addEventListener("tap");
	
	local levels = {level1, level2, level3, level4, level9, level5, level6, level7, level8};
	
	for k, v in pairs(levels) do
		local xCoord = levelCoords[k].x;
		local yCoord = levelCoords[k].y;
		
		local num;
		
		if k < 5 then
			num = k;
		elseif k == 5 then
			num = 9;
		else
			num = k - 1;
		end
		
		local newText = display.newText{text = num, x = xCoord, y = yCoord, font = native.systemFont, fontSize = 12};

		v.x = xCoord;
		v.y = yCoord;

		local star1 = display.newImageRect(sceneGroup, _graphicsPath.."star-"..starFilenames[starStates[k][1]]..".png", 18, 18);
		--local star1 = display.newImageRect(sceneGroup, _graphicsPath.."star-new.png", 18, 18);
		star1.x = xCoord - 10;
		star1.y = yCoord + 16;
		
		local star2 = display.newImageRect(sceneGroup, _graphicsPath.."star-"..starFilenames[starStates[k][2]]..".png", 18, 18);
		--local star2 = display.newImageRect(sceneGroup, _graphicsPath.."star-new.png", 18, 18);
		star2.x = xCoord + 10;
		star2.y = yCoord + 16;

		sceneGroup:insert(newText);
	end

	sceneGroup:insert(worldText);
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