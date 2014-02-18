module(...)


-- This file is for use with Corona Game Edition
--
-- The function getSpriteSheetData() returns a table suitable for importing using sprite.newSpriteSheetFromData()
--
-- Usage example:
--			local zwoptexData = require "ThisFile.lua"
-- 			local data = zwoptexData.getSpriteSheetData()
--			local spriteSheet = sprite.newSpriteSheetFromData( "Untitled.png", data )
--
-- For more details, see http://www.coronalabs.com/links/content/game-edition-sprite-sheets

function getSpriteSheetData()

	local sheet = {
		frames = {
		
			{
				name = "01.png",
				spriteColorRect = { x = 0, y = 4, width = 219, height = 155 }, 
				textureRect = { x = 2, y = 155, width = 219, height = 155 }, 
				spriteSourceSize = { width = 227, height = 161 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "02.png",
				spriteColorRect = { x = 5, y = 1, width = 208, height = 159 }, 
				textureRect = { x = 430, y = 155, width = 208, height = 159 }, 
				spriteSourceSize = { width = 226, height = 161 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "03.png",
				spriteColorRect = { x = 12, y = 2, width = 203, height = 147 }, 
				textureRect = { x = 229, y = 2, width = 203, height = 147 }, 
				spriteSourceSize = { width = 227, height = 161 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "04.png",
				spriteColorRect = { x = 11, y = 0, width = 204, height = 162 }, 
				textureRect = { x = 640, y = 155, width = 204, height = 162 }, 
				spriteSourceSize = { width = 226, height = 162 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "05.png",
				spriteColorRect = { x = 12, y = 2, width = 205, height = 159 }, 
				textureRect = { x = 223, y = 155, width = 205, height = 159 }, 
				spriteSourceSize = { width = 227, height = 161 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "06.png",
				spriteColorRect = { x = 2, y = 10, width = 216, height = 151 }, 
				textureRect = { x = 660, y = 2, width = 216, height = 151 }, 
				spriteSourceSize = { width = 226, height = 161 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "07.png",
				spriteColorRect = { x = 1, y = 20, width = 225, height = 140 }, 
				textureRect = { x = 2, y = 2, width = 225, height = 140 }, 
				spriteSourceSize = { width = 227, height = 162 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "08.png",
				spriteColorRect = { x = 0, y = 12, width = 224, height = 148 }, 
				textureRect = { x = 434, y = 2, width = 224, height = 148 }, 
				spriteSourceSize = { width = 226, height = 162 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
		}
	}

	return sheet
end