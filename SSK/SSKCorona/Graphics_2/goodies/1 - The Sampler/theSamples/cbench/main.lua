-- Project: HorseSprite
--
-- Date: September 27, 2010
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Code type: Game Edition Sample Code
--
-- Author: Japan Corona Group
--
-- Demonstrates: Use of optimized sprite sheets, loaded using newSpriteSheetFromData
--
-- File dependencies: none
--
-- Target devices: Simulator (results in Console)
--
-- Limitations:
--
-- Update History:
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------


display.setStatusBar(display.HiddenStatusBar)

local oldSprites = false
local loops = 0
local time = 300
local sprite
local uma
local spriteSet

local umaSheet
local spriteOptions


local function spriteCB( self, event )
	--print(event.phase)
	return true
end

if( oldSprites ) then

	-- The following uses the old sprite API (the prepare() call is commented out below):
	sprite = require "sprite"

	uma = sprite.newSpriteSheetFromData( "uma.png", require("uma_old").getSpriteSheetData() )
	spriteSet = sprite.newSpriteSet(uma,1,8)
	sprite.add(spriteSet,"uma",1,8,time,loops)
else

	-- The following demonstrates using the new image sheet data format 
	-- where uma_old.lua has been migrated to the new format (uma.lua)
	local options =
	{
		frames = require("uma").frames,
	}

	-- The new sprite API
	umaSheet = graphics.newImageSheet( "uma.png", options )
	spriteOptions = { name="uma", start=1, count=8, time=time, loopCount = loops }
end

local function buildInstance()

	local instanceGroup = display.newGroup()

	local spriteInstance

	-- The following uses the old sprite API (the prepare() call is commented out below):
	if( oldSprites ) then
		spriteInstance = sprite.newSprite(spriteSet)
		spriteInstance:prepare("uma")

	else
		-- The new sprite API
		spriteInstance = display.newSprite( umaSheet, spriteOptions )
	end

	instanceGroup:insert(spriteInstance)

--EFM G2	spriteInstance:setReferencePoint(display.BottomRightReferencePoint)
	spriteInstance.x = 480
	spriteInstance.y = 320

	spriteInstance.sprite = spriteCB
	spriteInstance:addEventListener( "sprite", spriteInstance )


	spriteInstance:play()



	return instanceGroup
end

local ig = buildInstance()

print(ig.width, ig.height)

ig.xScale = 0.5
ig.yScale = 0.5


local ig2 = buildInstance()
ig2.xScale = 0.5
ig2.yScale = 0.5
ig2.x = ig.x + 240
