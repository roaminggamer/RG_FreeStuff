-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Collision Calculator
-- =============================================================

local function rpad(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

local ccmgr

ccmgr = {}
	
-- ==
--    ssk.ccmgr:newCalculator() - Creates a blank (unconfigured) collision calculator.
--    val - The value to round.
--    n - Number of decimal places to round to.
--    Returns a collision calculator instance (myCC).
-- ==
function ccmgr:newCalculator()

	local collisionsCalculator = {}

	collisionsCalculator._colliderNum = {}
	collisionsCalculator._colliderCategoryBits = {}
	collisionsCalculator._colliderMaskBits = {}
	collisionsCalculator._knownCollidersCount = 0

	-- ==
	--    myCC:addName( colliderName ) - Add new 'named' collider type to known list of collider types, and 
	--    automatically assign a number to this collider type (16 Max).
	--
	--    colliderName - String containing name for new collider type.
	--
	--    Returns true if named type was successfully added to known colliders list, false otherwise.
	-- ==
	function collisionsCalculator:addName( colliderName )
		colliderName = string.lower(colliderName)

		if(not self._colliderNum[colliderName]) then
			-- Be sure we don't create more than 16 named collider types
			if( self._knownCollidersCount == 16 ) then
				return false
			end		

			local newColliderNum = self._knownCollidersCount + 1
		
			self._knownCollidersCount = newColliderNum
			self._colliderNum[colliderName] = newColliderNum
			self._colliderCategoryBits[colliderName] = 2 ^ (newColliderNum - 1)
			self._colliderMaskBits[colliderName] = 0
		end

		return true
	end

	function collisionsCalculator:addNames( ... )
		for key, value in ipairs(arg) do
        	self:addName( string.lower(value) )
			--print("Added name:", value)
		end
	end


	-- PRIVATE - DO NOT USE IN YOUR GAME CODE
	function collisionsCalculator:configureCollision( colliderNameA, colliderNameB )
		colliderNameA = string.lower(colliderNameA)
		colliderNameB = string.lower(colliderNameB)

		--
		-- Verify both colliders exist before attempting to configure them:
		--
		if( not self._colliderNum[colliderNameA] ) then
			print("Error: collidesWith() - Unknown collider: " .. colliderNameA)
			return false
		end
		if( not self._colliderNum[colliderNameB] ) then
			print("Error: collidesWith() - Unknown collider: " .. colliderNameB)
			return false
		end
		
		-- Add the CategoryBit for A to B's collider mask and vice versa
		-- Note: The if() statements encapsulating this setup work ensure
		--       that the faked bitwise operation is only done once 
		local colliderCategoryBitA = self._colliderCategoryBits[colliderNameA]
		local colliderCategoryBitB = self._colliderCategoryBits[colliderNameB]
		if( (self._colliderMaskBits[colliderNameA] % (2 * colliderCategoryBitB) ) < colliderCategoryBitB ) then
			self._colliderMaskBits[colliderNameA] = self._colliderMaskBits[colliderNameA] + colliderCategoryBitB
		end
		if( (self._colliderMaskBits[colliderNameB] % (2 * colliderCategoryBitA) ) < colliderCategoryBitA ) then
			self._colliderMaskBits[colliderNameB] = self._colliderMaskBits[colliderNameB] + colliderCategoryBitA
		end

		return true
	end


	-- ==
	--    myCC:collidesWith( colliderNameA, ... ) - Automatically configure named collider A to collide with one or more 
	--    other named colliders.  
	--
	--    Note: The algorithm used is fully associative, so configuring typeA to collide with typeB 
	--    automatically configures typeB too.
	--
	--    colliderNameA - A string containing the name of the collider that is being configured.
	--              ... - One or more strings identifying previously added collider types that collide with colliderNameA.
	--
	--     Returns true if named type was successfully added to known colliders list, false otherwise.
	-- ==
	function collisionsCalculator:collidesWith_legacy( colliderNameA, ... )
		for key, value in ipairs(arg) do
        	self:configureCollision( colliderNameA, value )
		end
	end

	function collisionsCalculator:collidesWith( colliderName, otherColliders )
		for key, value in ipairs(otherColliders) do
        	self:configureCollision( colliderName, value )
		end
	end

	-- ==
	--    myCC:getCategoryBits( colliderName  ) - Get category bits for the named collider.
	--
	--    Note: Rarely used.  Use the getCollisionFilter() function instead.
	--
	--    colliderName - A string containing the name of the collider you want the CategoryBits for.
	--
	--    Returns a number representing the CategoryBits for the named collider.
	-- ==
	function collisionsCalculator:getCategoryBits( colliderName )
		colliderName = string.lower(colliderName)
		return self._colliderMaskBits[colliderName] 
	end

	-- ==
	--    myCC:getMaskBits( colliderName  ) - Get mask bits for the named collider.
	--
	--    Note: Rarely used.  Use the getCollisionFilter() function instead.
	--    colliderName - A string containing the name of the collider you want the MaskBits for.
	--
	--    Returns a number representing the MaskBits for the named collider.
	-- ==
	function collisionsCalculator:getMaskBits( colliderName )
		colliderName = string.lower(colliderName)
		return self._colliderCategoryBits[colliderName] 
	end

	-- ==
	--    myCC:getCollisionFilter( colliderName  ) - Get collision filter for the named collider.
	--
	--    colliderName - A string containing the name of the collider you want the CollisionFilter for.
	--
	--    Returns CategoryBits and the MaskBits.
	-- ==
	function collisionsCalculator:getCollisionFilter( colliderName )
		colliderName = string.lower(colliderName)
		local collisionFilter =  
		{ 
	   	categoryBits = self._colliderCategoryBits[colliderName],
	   	maskBits     = self._colliderMaskBits[colliderName], 
		}  

		return collisionFilter
	end


	-- ==
	--    myCC:dump() - (Debug Feature) Prints collider names, numbers, category bits, and masks.
	-- ==
	function collisionsCalculator:dump()
		print("*********************************************\n")
		print("Dumping collision settings...")
		print("name           | num | cat bits | col mask")
		print("-------------- | --- | -------- | --------")
		for colliderName, colliderNum in pairs(self._colliderNum) do
			print(rpad(colliderName,15,' ') .. "| ".. 
		      	rpad(tostring(colliderNum),4,' ') .. "| ".. 
			  	rpad(tostring(self._colliderCategoryBits[colliderName]),9,' ') .. "| ".. 
			  	rpad(tostring(self._colliderMaskBits[colliderName]),8,' '))
		end

		print("\n*********************************************\n")
	end

	return collisionsCalculator
end

_G.ssk.cc = ccmgr

return ccmgr