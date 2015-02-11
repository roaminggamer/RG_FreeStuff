local bitLib = require( "plugin.bit" )

-- Make a table of masks (you could put this in a module and re-use it in multiple files)
--

local masks = {}

-- You have 32-bit to work with
masks.dog      = bit.lshift(1, 0) -- Shift left by 0 (creates a unique mask)
masks.cat      = bit.lshift(1, 1) -- Shift left by 1 (creates a unique mask)
masks.small    = bit.lshift(1, 2) -- ...
masks.medium   = bit.lshift(1, 3) -- ...
masks.big      = bit.lshift(1, 4) -- ...
-- ..
masks.hairless = bit.lshift(1, 28) -- ...
masks.hairy    = bit.lshift(1, 29) -- ...
masks.dirty    = bit.lshift(1, 30) -- ...
masks.clean    = bit.lshift(1, 31) -- Last possible shift value is 31 (not 32)

-- Tip: If you later change the above 'shifts' the code will still work as long as you use 
-- named masksd

-- Let's see the masks (will print in random order due to pairs())
for k,v in pairs(masks) do
	print( k, bit.tohex(v))
end

print("\n========================")

local animals = {
	{ 
		name = "Buddy",
		flag = bit.bor( masks.dog, masks.small, masks.clean, masks.hairy )
	},

	{ 
		name = "Gumbo",
		flag = bit.bor( masks.dog, masks.big, masks.dirty, masks.hairy )
	},

	{ 
		name = "Whiskers",
		flag = bit.bor( masks.cat, masks.small, masks.clean, masks.hairless )		
	},
}

-- Let's see the animal records
for i = 1, #animals do
	print( animals[i].name, bit.tohex(animals[i].flag) )
end

print("\n========================")


local function printCleanAnimals( list )
	for i = 1, #list do
		local animal = list[i]

		local isClean = bit.band( animal.flag, masks.clean )
		local isCat = bit.band( animal.flag, masks.cat )

		print("----------------------")
		print( i, isClean, isCat )
		print( i, bit.tohex(isClean), bit.tohex(isCat) )

		if( isClean ~= 0 ) then -- Will return 0 if animal is NOT clean dog
			if( isCat ~= 0 ) then
				print( animal.name .. " is a clean cat.\n\n"  )
			else
				print( animal.name .. " is a clean dog.\n\n" )
			end			
		end
	end
end

printCleanAnimals( animals )