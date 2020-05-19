-- Generate source textures by copying 3 unique textures to random file names
--

local textureList = table.load("textureList.txt") or {}

local function genTextures()

	for i = 1, 100 do
		local oldName = "ninjaGirlIdle.png" 
		local newName = "ninjaGirlIdle" .. i .. ".png"
		ssk.files.util.cpFile( ssk.files.resource.getPath(oldName), ssk.files.temporary.getPath(newName) )
		textureList[#textureList+1] = { textureNum, newName }
	end

	table.save( textureList, "textureList.txt" )
end


if( #textureList < 100 ) then
	print("Generating textures...")
	genTextures()
end
