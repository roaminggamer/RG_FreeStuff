-------------------------------------------------
--
-- dog.lua
--
-- Example "dog" class for Corona SDK tutorial.
--
-------------------------------------------------

local dogClass = {}
local dog = {}
local dog_mt = { __index = dog }	-- metatable

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

local function getDogYears( realYears )	-- local; only visible in this module
	return realYears * 7
end

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function dogClass:new( name, ageInYears )	-- constructor
		
	--print(name,ageInYears)
	local newDog = {
		name = name or "Unnamed",
		age = ageInYears or 2
	}
	
	return setmetatable( newDog, dog_mt )
end

-------------------------------------------------

function dog:rollOver()
	print( self.name .. " rolled over." )

	local dummy = { "a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", }

	for k,v in pairs(dummy) do
		print(k)
	end

end

-------------------------------------------------

function dog:sit()
	print( self.name .. " sits down in place." )
	local dummy = { "a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", }

	for k,v in pairs(dummy) do
		print(k)
	end
end

-------------------------------------------------

function dog:bark()
	print( self.name .. " says \"woof!\"" )
	local dummy = { "a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", }

	for k,v in pairs(dummy) do
		--print(k)
	end

end

-------------------------------------------------

function dog:printAge()
	print( self.name .. " is " .. getDogYears( self.age ) .. " in dog years." )
	local dummy = { "a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", 
					"a", "a", "a", "a", "a", "a", }

	for k,v in pairs(dummy) do
		print(k)
	end
end

-------------------------------------------------

return dogClass
