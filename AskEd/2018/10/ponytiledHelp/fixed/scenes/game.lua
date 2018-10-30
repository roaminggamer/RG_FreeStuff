local composer = require( "composer" )
local scene = composer.newScene()

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then

local tiled = require "com.ponywolf.ponytiled";
local physics = require "physics";
local json = require "json";

physics.start();

display.setDefault("magTextureFilter", "nearest");
display.setDefault("minTextureFilter", "nearest");

local mapData = json.decodeFile(system.pathForFile("maps/map2.json", system.ResourceDirectory));
local map = tiled.new(mapData, "maps");

map.xScale = 1.3;
map.yScale = 1.3;

local dragable = require "com.ponywolf.plugins.dragable";
map = dragable.new(map);

map:translate(-1200, -1000);

local sheetOptions =
{
   width = 32,
   height = 32,
   numFrames = 48
};

local sheetPlayer = graphics.newImageSheet("image/spritePlayer.png", sheetOptions);

local sequencesPlayer = {
    {
        name = "downRun",
        frames = {4,5,8},
        time = 200,
        loopCount = 0,
        loopDirection = "forward"
    },

    {
        name = "leftRun",
        frames = {16,17,18},
        time = 200,
        loopCount = 0,
        loopDirection = "forward"
    },

    {
        name = "rightRun",
        frames = {28,29,30},
        time = 200,
        loopCount = 0,
        loopDirection = "forward"
    },

    {
        name = "upRun",
        frames = {37,38,39},
        time = 200,
        loopCount = 0,
        loopDirection = "forward"
    }

};

local player = display.newSprite(sheetPlayer, sequencesPlayer);

player:setSequence("rightRun");

player.x, player.y = _W * 0.5, _H * 0.7;
player:scale(2, 2);

    end
end
 
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        composer.removeScene("scenes.game")
    end
end
 
scene:addEventListener("show", scene);
scene:addEventListener("hide", scene);
 
return scene