-- Generate source textures by copying 3 unique textures to random file names
--

local textureList = table.load("textureList.txt") or {}

local function genTextures()
	local fileManager = ssk.GGFile:new()
	
	local files = { "images/coronageek.jpg", "images/flavaed1.jpg", "images/flavaed2.jpg" }

	for i = 1, _G.numTextures do
		local newName  = getUID(12) .. ".jpg"
		local textureNum = math.random(#files)
		local oldName = files[textureNum]

		fileManager:copyBinary( oldName, system.ResourceDirectory, newName, system.TemporaryDirectory )
		textureList[#textureList+1] = { textureNum, newName }
	end

	table.save( textureList, "textureList.txt" )
	--textureList[i[]]	
end


if( #textureList <  _G.numTextures ) then
	print("Generating textures...")
	genTextures()
end
