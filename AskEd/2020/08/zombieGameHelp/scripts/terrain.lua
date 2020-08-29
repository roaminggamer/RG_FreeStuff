-- Terrain Module - Draws basic play area, grass, etc.
local terrain = {}

local common = require "scripts.common"
local gridSize = 40

terrain.create = function( group )
	local x = left
	local y = top

	-- Draw grass first
	while( y <= bottom ) do
		while( x <= right ) do
			local img_num = math.random(1,4)
			local filename =  "images/kenney/tile_0" .. tostring(img_num) .. ".png"
			-- print( i, img_num, filename )			
			local grass = display.newImageRect( group, filename, gridSize, gridSize )
			grass.x = x
			grass.y = y
			x  = x + gridSize
		end
		x = left
		y = y + gridSize
	end

	-- Place random debris
	local tile_nums = { 134, 235, 236, 237, 238, 262, 263, 264, 265, 266 }

	local max_debris = math.random(15, 25) 
	for i = 1, max_debris do
		local img_num = math.random(1,#tile_nums)
		local filename =  "images/kenney/tile_" .. tostring( tile_nums[img_num] ) .. ".png"
		-- print( i, img_num, filename )
		local debris = display.newImageRect( group, filename, gridSize, gridSize )
		debris.x = math.random( left, right )
		debris.y = math.random( top, bottom )
		debris.rotation = math.random(0,360)
	end
end

return terrain