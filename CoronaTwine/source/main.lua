
local coronaTwine = require "coronaTwine"

local ggcolor = require "GGColour"
local colorChart = ggcolor:new()

local params =
{
	font = "Consolas",
	fontSize = 16,
	fontColor = colorChart:fromName( "Tomato", true),
	spaceWidth = 2,
	lineHeight = 22,
	linkColor1 = colorChart:fromName( "Blue", true),
	linkColor2 = colorChart:fromName( "Purple", true),
}


coronaTwine.run( "twineSamples/sample1.txt", 40, 40, params )

-- Try the following instead to see default settings:
--
-- coronaTwine.run( "twineSamples/sample1.txt", 40, 40,  nil) 