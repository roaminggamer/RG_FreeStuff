local mlText = require "mltext"

local myMLString = '<font size="22" color="ForestGreen">This is a test of</font><br><br>' ..
                   'MLText by <a href = "www.roaminggamer.com">Roaming Gamer, LLC.</a><br><br>' ..
				   '<font face = "Arial" size="26" color="red">This is some red size 26 Arial!</font><br><br>' ..
				   'And an image of a <a href = "www.roaminggamer.com"><img src="joker.png" alt="Smiley face" height="40" width="40" yOffset = "-12">Joker!</a>'


-- Base settings for text without <font> statements.
local params =
	{
		font = "Consolas",
		fontSize = 24,
		fontColor = { 255, 255, 128 },
		spaceWidth = 14,
		lineHeight = 22,
		linkColor1 = {0,0,255},
		linkColor2 = {255,0,255},
	}

lastTextGroup = mlText.newMLText( myMLString, 10, 60, params )
