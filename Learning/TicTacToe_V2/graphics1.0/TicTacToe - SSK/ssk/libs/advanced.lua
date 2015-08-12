-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Advanced Utilities
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================

local advanced

if( not _G.ssk.advanced ) then
	_G.ssk.advanced = {}
end

advanced = _G.ssk.advanced

-- ==
--    ssk.advanced.addCustom_removeSelf( obj, custom_removeSelf )
--
--    Caches a display object's old removeSelf() function and attaches a new one.  
--    This feature allows one display object to have multiple stacked removeSelf() 
--    functions that get called in the reverse-order that they were attached.
--
--    obj - The display object whose removeSelf() function is being cached and stacked.
--    custom_removeSelf - A pointer to the new removeSelf() function to attach to obj.
-- ==
function advanced.addCustom_removeSelf( obj, custom_removeSelf )

	-- If this is the first time, 
	
	if( not obj._cache_removeSelf ) then

		--  A. Create a cache to store custom removeSelf() functions
		obj._cache_removeSelf = {}
		
		--  B. Add the Corona removeSelf function to the cache
		obj._cache_removeSelf[1] = obj.removeSelf

		--  C. Create a custom removeSelf that will call all cached functions and do some other
		--  helpful stuff
		local function removeSelf( self )
			-- 1. Grab the cache of custom removeSelf functions
			local theCache = self._cache_removeSelf
			
			-- 2. Call the custom removeSelf functions in reverse order
			for i=#theCache, 1, -1 do
				self.func = theCache[i]
				if(self.func) then
					self:func()
				end
			end

			-- 3. Clear the cache
			theCache = {}
			self._cache_removeSelf = {}

			-- 4. Assign a dummy catch function which will warn you if removeSelf() is
			--   incorrectly called again
			local function dummy()
				print("WARNING: removeSelf() called twice on same object!" )
			end

			self.removeSelf = dummy
		end

		obj.removeSelf = removeSelf
	end

	obj._cache_removeSelf[#obj._cache_removeSelf+1] = custom_removeSelf
end

-- EFM ALL BELOW WIP
-- EFM ALL BELOW WIP
-- EFM ALL BELOW WIP
-- EFM ALL BELOW WIP

--[[ EFM Finish later and consider using to replace above
function advanced.stackMethods( obj, methodName, newFunc)

	local caches 
	if( not obj.__caches ) then
		obj.__caches = {}
	end

	caches = obj.__caches

	local thisCache 
	if( not caches[methodName] ) then
		caches[methodName] = {}
	end

	thisCache = caches[methodName]


		-- Cache this method if it exists (not necessary that it does)
		if(obj[methodName]) then
			caches[methodName][1] = obj[methodName]
		end


	-- If this is the first time, 
	
	if( not obj._cache_removeSelf ) then

		--  A. Create a cache to store custom removeSelf() functions
		obj._cache_removeSelf = {}
		
		--  B. Add the Corona removeSelf function to the cache
		obj._cache_removeSelf[1] = obj.removeSelf

		--  C. Create a custom removeSelf that will call all cached functions and do some other
		--  helpful stuff
		local function removeSelf( self )
			-- 1. Grab the cache of custom removeSelf functions
			local theCache = self._cache_removeSelf
			
			-- 2. Call the custom removeSelf functions in reverse order
			for i=#theCache, 1, -1 do
				self.func = theCache[i]
				if(self.func) then
					self:func()
				end
			end

			-- 3. Clear the cache
			theCache = {}
			self._cache_removeSelf = {}

			-- 4. Assign a dummy catch function which will warn you if removeSelf() is
			--   incorrectly called again
			local function dummy()
				print("WARNING: removeSelf() called twice on same object!" )
			end

			self.removeSelf = dummy
		end

		obj.removeSelf = removeSelf
	end

	obj._cache_removeSelf[#obj._cache_removeSelf+1] = newFunc
end
--]]
