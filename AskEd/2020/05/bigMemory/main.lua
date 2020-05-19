-- 
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- 
require "ssk2.loadSSK"
_G.ssk.init()
-- 
ssk.meters.create_fps(true)
ssk.meters.create_mem(true)
-- 
local group = display.newGroup()
local sequenceData =
{
	name		= "idle",
   start		= 1,
   count 		= 10,
   time 		= 1000,
   loopCount 	= 0
}
local data   = require("ninjaGirlIdle")

local numSheets = 280

local textureList = table.load("textureList.txt") or {}
local function genTextures()
	for i = 1, numSheets do
		local oldName = "ninjaGirlIdle.png" 
		local newName = "ninjaGirlIdle" .. i .. ".png"
		ssk.files.util.cpFile( ssk.files.resource.getPath(oldName), ssk.files.temporary.getPath(newName) )
		textureList[#textureList+1] = { textureNum, newName }
	end
	table.save( textureList, "textureList.txt" )
end

if( #textureList < numSheets ) then
	print("Generating textures...")
	genTextures()
end

display.setDefault( "background", 0.25, 0.25, 0.25)

--
local function idleNinjaGirl( num )
	local sheet  = graphics.newImageSheet( "ninjaGirlIdle" .. num .. ".png", system.TemporaryDirectory, data.sheet  )
	local sprite = display.newSprite( sheet, sequenceData )
	sprite:scale(0.2,0.2)
	sprite:setSequence("idle")
	sprite:play()
	return sprite
end

local x = 100
local y = 100

for i = 1, numSheets do
	local tmp = idleNinjaGirl( i )
	x = x + 10
	if ( x > 900 ) then 
		x = 100 
		y = y + 50
	end
	tmp.x = x 
	tmp.y = y
end


-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------