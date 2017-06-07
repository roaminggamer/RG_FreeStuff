local composer = require "composer";
local json = require "json";
local physics = require "physics";

--local constants

local DIR_NONE = 0;
local DIR_UP = 1;
local DIR_RIGHT = 2;
local DIR_DOWN = 3;
local DIR_LEFT = 4;

--global variable
_passedOver = {};

--local variables

local playerData;
local playerObj;
local direction = DIR_NONE;
local desiredDirection;
local isAligned = false;
local stallCounter = 0;
local collectedGems = 0;
local opacity = 0.9;
local up = false;
local gemText;
local isPaused = false;
local isDead = false;
local hasWon = false;
local world;
local level;

local collides = {};
local willCollide = {};

for i = DIR_UP, DIR_LEFT do
	collides[i] = 0;
	willCollide[i] = false;
end

local colliders = {};
local gemData = {};
local gems = {};
local queuedTiles = {};
local queuedGems = {};
local static = {};
local worldExtensions = {"ruins", "desert", "clouds", "jungle", "ghost", "lava"};

local function toMenu()
	isPaused = true;
	
	composer.showOverlay("scene.pause",
		{isModal = true,
			effect = "fade",
			time = 400,
			params = {deadState = isDead,
				winState = hasWon,
				worldNum = world,
				levelNum = level}
		}
	);
end

local scene = composer.newScene(); --create the sccene

local function keyEvent(event)
	if (_usesKeys) and (not isPaused) then --main.lua determines the value of _usesKeys; runs accordingly
		local phase = event.phase;
		local name = event.keyName;
		
		if phase == "down" then
			if direction == DIR_NONE then
				if (name == "up") and (not willCollide[DIR_UP]) then
					direction = DIR_UP;
				elseif (name == "right") and (not willCollide[DIR_RIGHT]) then
					direction = DIR_RIGHT;
				elseif (name == "down") and (not willCollide[DIR_DOWN]) then
					direction = DIR_DOWN;
				elseif (name == "left") and (not willCollide[DIR_LEFT]) then
					direction = DIR_LEFT;
				end
				
				print(name, direction);
			else
				if name == "up" then
					desiredDirection = DIR_UP; --set the desired direction of the player (then check for collisions and alignment later)
				elseif name == "right" then
					desiredDirection = DIR_RIGHT;
				elseif name == "down" then
					desiredDirection = DIR_DOWN;
				elseif name == "left" then
					desiredDirection = DIR_LEFT;
				end
			end
		elseif (phase == "up") and (name == "escape") then
			--composer.gotoScene("scene.menu");
			toMenu();
		end
	end
end

local function touchEvent(event)
	if (not _usesKeys) and (not isPaused) then --main.lua determines the value of this _usesKeys; runs accordingly
		if event.phase == "moved" then
			if (event.y < event.yStart - 128) and (event.x >= event.xStart - 32) and (event.x <= event.xStart + 32) then --checks for a swipe upwards
				if direction > DIR_NONE then
					desiredDirection = DIR_UP; --set the desired direction of the player (then check for collisions and alignment later)
				elseif not willCollide[DIR_UP] then
					direction = DIR_UP; --can set the player's direction immediately at the beginning
				end
			elseif (event.x > event.xStart + 128) and (event.y >= event.yStart - 32) and (event.y <= event.yStart + 32) then --swipe right
				if direction > DIR_NONE then
					desiredDirection = DIR_RIGHT;
				elseif not willCollide[DIR_RIGHT] then
					direction = DIR_RIGHT;
				end
			elseif (event.y > event.yStart + 128) and (event.x >= event.xStart - 32) and (event.x <= event.xStart + 32) then --swipe downwards
				if direction > DIR_NONE then
					desiredDirection = DIR_DOWN;
				elseif not willCollide[DIR_DOWN] then
					direction = DIR_DOWN;
				end
			elseif (event.x < event.xStart - 128) and (event.y >= event.yStart - 32) and (event.y <= event.yStart + 32) then --swipe left
				if direction > DIR_NONE then
					desiredDirection = DIR_LEFT;
				elseif not willCollide[DIR_LEFT] then
					direction = DIR_LEFT;
				end
			end
		end
	end
end

local function frameEvent(event)
	print(tostring(hasWon));

	if (playerObj.x ~= nil) and (not isPaused) then

		--player logic
	
		if direction > DIR_NONE then
			if isAligned then --if the player is aligned to a 32x32 floor tile
				for k, v in pairs(willCollide) do
					if v then
						willCollide[k] = false;
						print(k);
						collides[k] = collides[k] + 1; --record that another tile is colliding in that direction
					end
				end
			
				if (desiredDirection ~= nil) and (collides[desiredDirection] == 0) then --if there are no tiles colliding in the desired direction
					direction = desiredDirection; --the direction is changed to the desired direction
					print("changed direction");
				end
			end
			
			if collides[direction] == 0 then --only increment the player's x and y-coords of they are not colliding in the direction travelled		
				if (direction == DIR_UP) then
					--playerObj.y = playerObj.y - 2;
					playerObj:translate(0, -2);

					for _, w in pairs(colliders) do
						--w.y = w.y - 2; --move the added player colliders
						w:translate(0, -2);
					end
				elseif (direction == DIR_RIGHT) then
					--playerObj.x = playerObj.x + 2;
					playerObj:translate(2, 0);

					for _, w in pairs(colliders) do
						--w.x = w.x + 2;
						w:translate(2, 0);
					end
				elseif (direction == DIR_DOWN) then
					--playerObj.y = playerObj.y + 2;
					playerObj:translate(0, 2);

					for _, w in pairs(colliders) do
						--w.y = w.y + 2;
						w:translate(0, 2);
					end
				else
					--playerObj.x = playerObj.x - 2;
					playerObj:translate(-2, 0);

					for _, w in pairs(colliders) do
						--w.x = w.x - 2;
						w:translate(-2, 0);
					end
				end
			end
		end
		
		if ((math.ceil(playerObj.x) - 16)%32 == 0) and ((math.ceil(playerObj.y))%32 == 0) then --check if the player is aligned to a 32x32 floor tile
			isAligned = true;
			stallCounter = stallCounter + 1; --increments as long as the player is not moving
		else
			isAligned = false;
			stallCounter = 0;
		end
		
		--floor tile logic
		
		for k, v in pairs(queuedTiles) do --if a tile is queued (has collided with the player)
			if ((direction == DIR_UP) and
				(v.x == math.ceil(playerObj.x)) and
				(v.y == math.ceil(playerObj.y + 32))) or
				((direction == DIR_RIGHT) and
				(v.y == math.ceil(playerObj.y)) and
				(v.x == math.ceil(playerObj.x - 32))) or
				((direction == DIR_DOWN) and
				(v.x == math.ceil(playerObj.x)) and
				(v.y == math.ceil(playerObj.y - 32))) or
				((direction == DIR_LEFT) and
				(v.y == math.ceil(playerObj.y)) and
				(v.x == math.ceil(playerObj.x + 32))) then --if the tile is offset behind the player based on their current direction
					table.remove(queuedTiles, k); --it is removed from the queue
					table.insert(_passedOver, v); --record for later that the tile has been passed over
					v.isVisible = false;
					break; --only one tile can be directly behind the player each frame, so after one is removed from the queue the loop can be broken
			elseif (v.x == math.ceil(playerObj.x)) and (v.y == math.ceil(playerObj.y)) and (stallCounter == 150) then --if the player has stalled over a queued tile
				table.remove(queuedTiles, k);
				table.insert(_passedOver, v);
				v.isVisible = false;
			end
		end

		for _, w in pairs(_passedOver) do
			if (w.x == math.ceil(playerObj.x)) and (w.y == math.ceil(playerObj.y)) then --if the player is overtop of a passed over tile for 150 frames (~5s)
				--error("player is dead!"); --kill the player
				isDead = true;
				toMenu();
			end
		end
		
		--gem logic
		
		for k, v in pairs(queuedGems) do
			if (v.x == math.ceil(playerObj.x)) and (v.y == math.ceil(playerObj.y)) then --if the player is directly over a gem
				v.isVisible = false;
				collectedGems = collectedGems + 1;
				gemText.text = collectedGems.."/"..#gems; --update the gem text
				print("ta-da");
				table.remove(queuedGems, k); --it is removed from the queue
				break; --only one gem can be directly under the player each frame, so after one is removed from the queue the loop can be broken
			end
		end

		if up then --if the opacity (alpha) of the gems should increase
			opacity = opacity + 0.01;
		else
			opacity = opacity - 0.01;
		end
		
		if opacity >= 0.9 then --if the opacity (alpha) is greater than or equal to 0.9
			up = false; --the opacity should now decrease
		elseif opacity <= 0.4 then --if the opacity is less than or equal to 0.4
			up = true; --the opacity should now increase
		end
		
		for _, w in pairs(gems) do
			w.alpha = opacity; --update the alpha value of all gems
		end
		
		if collectedGems == #gems then --if the player has collected all of the gems
			--error("player has won!"); --trigger the win state
			hasWon = true;
			toMenu();
		end
	end
end

local function collisionEvent(event)
	local obj1 = event.object1; --generally useful event objects; these variables just shorten things a little later
	local obj2 = event.object2;

	--player logic
	
	local wall;
	local other;

	if obj1.type == "wall" then
		wall = obj1;
		other = obj2;
	elseif obj2.type == "wall" then
		other = obj1;
		wall = obj2;
	end

	if wall ~= nil then --if there is actually a wall colliding
		if other == colliders.topColliderRect then --if the wall is colliding with the top player collider
			if event.phase == "began" then
				print("collides above");
				willCollide[DIR_UP] = true;
			elseif event.phase == "ended" then
				collides[DIR_UP] = collides[DIR_UP] - 1; --remove the tile from the collision counter for that direction
			end
		elseif other == colliders.rightColliderRect then
			if event.phase == "began" then
				print("collides right");
				willCollide[DIR_RIGHT] = true;
			elseif event.phase == "ended" then
				collides[DIR_RIGHT] = collides[DIR_RIGHT] - 1;
			end
		elseif other == colliders.bottomColliderRect then
			if event.phase == "began" then
				print("collides below");
				willCollide[DIR_DOWN] = true;
			elseif event.phase == "ended" then
				collides[DIR_DOWN] = collides[DIR_DOWN] - 1;
			end
		elseif other == colliders.leftColliderRect then
			if event.phase == "began" then
				print("collides left");
				willCollide[DIR_LEFT] = true;
			elseif event.phase == "ended" then
				collides[DIR_LEFT] = collides[DIR_LEFT] - 1;
			end
		end
	end
	
	if event.phase == "began" then

		--floor tile logic
		
		local player;
		local fTile;
		
		if obj1.type == "floor" then
			fTile = obj1;
			player = obj2;
		elseif obj2.type == "floor" then
			player = obj1;
			fTile = obj2;
		end
		
		if (fTile ~= nil) and (player == playerObj) and (fTile.isVisible) then --if the player is colliding with a visible floor tile
			table.insert(queuedTiles, fTile); --it is added to the queue
		end
		
		--gem logic
		
		local other;
		local gem;
		
		if obj1.type == "gem" then
			gem = obj1;
			other = obj2;
		elseif obj2.type == "gem" then
			other = obj1;
			gem = obj2;
		end
		
		if (gem ~= nil) and
			(not gem.queued) and
			((other == colliders.topColliderRect) or
			(other == colliders.rightColliderRect) or
			(other == colliders.bottomColliderRect) or
			(other == colliders.leftColliderRect)) then --if a non-queued gem is colliding with a player collider
				print("queued!");
				gem.queued = true;
				table.insert(queuedGems, gem); --it is added to the queue
		end
	end
end

function scene:create(event)
	local sceneGroup = self.view; --grab the scene parent object, which all added objects will be put into as children
	
	local prev = composer.getSceneName("previous");
	
	if prev ~= nil then
		composer.removeScene(prev);
	end
	
	local params = event.params;
	world = params.worldNum;
	level = params.levelNum;
	
	local file = "scene/levels/"..worldExtensions[world].."-"..level..".json";
	
	--composer.removeScene("scene.menu");
	
	local offsetX = (display.contentWidth - 320)/2 + 16; --declare an offset to position the board centered in the x-axis for all devices
	local offsetY = (display.contentHeight - 320)/2 - 16; --declare an offset to position the board near-centered in the y-axis for all devices
	
	local backgroundRect = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight);
	backgroundRect:setFillColor(0.620, 0.553, 0.235);
	
	--local level = json.decodeFile(system.pathForFile("scene/levels/ruins-1.json", system.ResourceDirectory));
	local level = json.decodeFile(system.pathForFile(file, system.ResourceDirectory)); --grab the .json level file and decode it into a .lua table
	
	for _, v in pairs(level) do
		if v.type == "wall" then --if the object is declared as a wall
			local wall = display.newImageRect(sceneGroup, _graphicsPath.."wall1.png", 32, 32); --draw a wall
			wall.x = v.x + offsetX;
			wall.y = v.y + offsetY;
			wall.type = "wall";

			table.insert(static, wall);
		elseif v.type == "floor" then
			local fTile = display.newImageRect(sceneGroup, _graphicsPath.."floor1.png", 32, 32);
			fTile.x = v.x + offsetX;
			fTile.y = v.y + offsetY;
			fTile.type = "floor";
			
			table.insert(static, fTile);
		elseif v.type == "gem" then
			table.insert(gemData, v); --gems must be drawn on top of floor tiles but behind the player, so they are drawn later
		elseif v.type == "player" then
			playerData = v; --there's only one player object so it can be immediately set to the one variable
		end
	end
	
	for _, w in pairs(gemData) do
		local gem = display.newImageRect(sceneGroup, _graphicsPath.."gem.png", 32, 32);
		gem.x = w.x + offsetX;
		gem.y = w.y + offsetY;
		gem.type = "gem";
		gem.queued = false;
		
		table.insert(gems, gem); --used to change opacity and determine the max. gems in a level
		table.insert(static, gem);
	end
	
	playerObj = display.newImageRect(sceneGroup, _graphicsPath.."player.png", 32, 32);
	playerObj.x = playerData.x + offsetX;
	playerObj.y = playerData.y + offsetY;
	
	colliders.topColliderRect = display.newRect(sceneGroup, playerObj.x, playerObj.y - 0.5*playerObj.height - 2, 8, 2); --add colliders that float around the player
	colliders.rightColliderRect = display.newRect(sceneGroup, playerObj.x + 0.5*playerObj.width, playerObj.y, 2, 8); --intended for pre-collision detection
	colliders.bottomColliderRect = display.newRect(sceneGroup, playerObj.x, playerObj.y + 0.5*playerObj.height, 8, 2); --incremented as the player moves
	colliders.leftColliderRect = display.newRect(sceneGroup, playerObj.x - 0.5*playerObj.width - 2, playerObj.y, 2, 8);
	
	local smallGem = display.newImage(_graphicsPath.."small-gem.png", display.contentCenterX - 15, display.contentCenterY + offsetY + 96); --gem counter icon
	gemText = display.newText{text = "0/"..#gems, x = display.contentCenterX + 10, y = display.contentCenterY + offsetY + 96, font = native.systemFont, fontSize = 18};
		--counter text

	sceneGroup:insert(smallGem);
	sceneGroup:insert(gemText);
end

function scene:show(event)
	local sceneGroup = self.view;
	local phase = event.phase;

	if phase == "will" then
		physics.start(); --start the physics engine
		physics.setGravity(0, 0); --no gravity is wanted; everything will be done via x/y-coord modifications

		for _, v in pairs(static) do
			physics.addBody(v, "static", {isSensor = true}); --add a static physics body that exerts no forces on other objects
		end
	
		physics.addBody(playerObj, "dynamic", {bounce = 0, friction = 0, density = 0}); --add a dynamic physics body that exerts no forces on other objects
	
		playerObj.isFixedRotation = true;
	
		for _, w in pairs(colliders) do
			physics.addBody(w, "dynamic", {density = 0, bounce = 0, friction = 0}); --add a dynamic physics body that exerts no forces on other objects
			w.isVisible = false;
		end
	
		Runtime:addEventListener("key", keyEvent); --add necessary listeners
		Runtime:addEventListener("touch", touchEvent);
		Runtime:addEventListener("enterFrame", frameEvent);
		Runtime:addEventListener("collision", collisionEvent);
	elseif phase == "did" then

	end
end
 
function scene:resume(buttonName)
	if buttonName == "restart" then
		composer.gotoScene("scene.refresh", {params = {worldNum = world, levelNum = level}});
		--scene:restart(level);
	elseif buttonName == "levelSelect" then
		composer.gotoScene("scene.levelSelect", {effect = "crossFade", time = 400, params = {currentWorld = world}});
	elseif buttonName == "play" then
		isPaused = false;
		print("not paused!");
	else
		if level < 6 then
			composer.gotoScene("scene.refresh", {params = {worldNum = world, levelNum = level + 1}});
		else
			composer.gotoScene("scene.levelSelect", {effect = "crossFade", time = 400, params = {currentWorld = world}});
		end
	end
end
 
function scene:hide(event)
	local sceneGroup = self.view;
	local phase = event.phase;

	if phase == "will" then

	elseif phase == "did" then
		Runtime:removeEventListener("key", keyEvent); --remove added listeners
		Runtime:removeEventListener("touch", touchEvent);
		Runtime:removeEventListener("frame", frameEvent);
		Runtime:removeEventListener("collision", collisionEvent);
		
	end
end

function scene:destroy(event)
	local sceneGroup = self.view;
	
	error("");
end

scene:addEventListener("create", scene);
scene:addEventListener("show", scene);
scene:addEventListener("hide", scene);
scene:addEventListener("destroy", scene);

return scene