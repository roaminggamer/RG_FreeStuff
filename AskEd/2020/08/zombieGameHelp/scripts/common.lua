-- Scratch pad module shared by all other modules to store common data, tables, etc.

local directions = { "left", "right", "up", "down" }

local common = {}

	common.zombies = {}

	common.movePlayerZombie = function( obj, dir )
		-- print("movePlayerZombie", dir )

		if( dir == "random" ) then
			dir = directions[math.random(1,4)]
		end

		if( dir == "left" ) then
			obj.rotation = 180
			if( obj.x > left + obj.contentWidth * 2 ) then
				obj.x = obj.x - obj.contentWidth
			end
		elseif( dir == "right" ) then
			obj.rotation = 0
			if( obj.x < right - obj.contentWidth * 2 ) then
				obj.x = obj.x + obj.contentWidth
			end
		elseif( dir == "up" ) then
			obj.rotation = 270
			if( obj.y > top + obj.contentWidth * 2 ) then
				obj.y = obj.y - obj.contentWidth
			end
		elseif( dir == "down" ) then
			obj.rotation = 90
			if( obj.y < bottom - obj.contentWidth * 2 ) then
				obj.y = obj.y + obj.contentWidth
			end
		end
	end


return common