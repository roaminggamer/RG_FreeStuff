-- This file is for use with Corona SDK
--
-- It is intended for use with the image sheet and sprite API's
-- 
-- This module writes no global values, not even the module table
--
-- Usage example:
--			local options =
--			{
--				frames = require("uma").frames,
--			}
-- 			local imageSheet = graphics.newImageSheet( "uma.png", options )
-- 			local spriteOptions = { name="uma", start=1, count=8, time=1000 }
-- 			local spriteInstance = display.newSprite( imageSheet, spriteOptions )
-- 

local sheetData = {}

sheetData.frames = {
	{
		x = 2,
		y = 155,
		width = 219,
		height = 155,
		sourceX = 0,
		sourceY = 4,
		sourceWidth = 227,
		sourceHeight = 161,
	},

	{
		x = 430,
		y = 155,
		width = 208,
		height = 159,
		sourceX = 5,
		sourceY = 1,
		sourceWidth = 226,
		sourceHeight = 161,
	},

	{
		x = 229,
		y = 2,
		width = 203,
		height = 147,
		sourceX = 12,
		sourceY = 2,
		sourceWidth = 227,
		sourceHeight = 161,
	},

	{
		x = 640,
		y = 155,
		width = 204,
		height = 162,
		sourceX = 11,
		sourceY = 0,
		sourceWidth = 226,
		sourceHeight = 162,
	},

	{
		x = 223,
		y = 155,
		width = 205,
		height = 159,
		sourceX = 12,
		sourceY = 2,
		sourceWidth = 227,
		sourceHeight = 161,
	},

	{
		x = 660,
		y = 2,
		width = 216,
		height = 151,
		sourceX = 2,
		sourceY = 10,
		sourceWidth = 226,
		sourceHeight = 161,
	},

	{
		x = 2,
		y = 2,
		width = 225,
		height = 140,
		sourceX = 1,
		sourceY = 20,
		sourceWidth = 227,
		sourceHeight = 162,
	},

	{
		x = 434,
		y = 2,
		width = 224,
		height = 148,
		sourceX = 0,
		sourceY = 12,
		sourceWidth = 226,
		sourceHeight = 162,
	},		
}

return sheetData
