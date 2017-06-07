local composer = require "composer";
local loadsave = require "scene.loadsave";

_usesKeys = false;
_graphicsPath = "scene/graphics/";

if (system.getInfo("platform") == "win32") or (system.getInfo("platform") == "macos") then
	_usesKeys = true;
end

if (system.getInfo("environment") == "simulator") then
	_usesKeys = true;
end

display.setStatusBar(display.HiddenStatusBar);

if not _usesKeys then
	if (system.getInfo("androidApiLevel")) and (system.getInfo("androidApiLevel") < 19) then
		native.setProperty("androidSystemUiVisibility", "lowProfile");
	else
		native.setProperty("androidSystemUiVisibility", "immersiveSticky");
	end
end

if loadsave.loadTable("data-save.json") == nil then
	print("started save file");
	
	local baseData = {stars = 0}
	
	for i = 1, 6 do
		local first = 0;
		
		if i == 1 then
			first = 1;
		end
	
		table.insert(baseData, {states = {first, 0, 0, 0, 0, 0, 0, 0, 0}, normalStars = {0, 0, 0, 0, 0, 0, 0, 0, 0}, reverseStars = {0, 0, 0, 0, 0, 0, 0, 0, 0}});
	end
	
	loadsave.saveTable(baseData, "data-save.json");
end

if loadsave.loadTable("data-settings.json") == nil then
	print("started settings file");
	
	local defaultSettings = {};
	defaultSettings.tutorialIsOn = true;
	defaultSettings.sfxIsOn = true;
	defaultSettings.musicIsOn = true;
	
	loadsave.saveTable(defaultSettings, "data-settings.json");
end

composer.gotoScene("scene.menu");
