io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- Include SSK Core (Features I just can't live without.)
require("ssk_core.globals.variables")
require("ssk_core.globals.functions")
require("ssk_core.extensions.display")
require("ssk_core.extensions.io")
require("ssk_core.extensions.math")
require("ssk_core.extensions.string")
require("ssk_core.extensions.table")
require("ssk_core.extensions.transition_color")


-- =============================================
-- EXAMPLE BEGIN
-- =============================================
local letters = "abcdefghijklmnopqrstuvwxyz01234567890"

local row_col = 3 -- small to make this easily examine in console

-- Blank start
local myTable = {}

local count = 1
for col = 1, row_col do
	myTable[col] = {}
	for row = 1, row_col do
		local obj = { name = string.sub( letters, count, count ) }
		myTable[col][row] = obj
		count = count + 1
	end
end

local function shuffle2d( array )
	local flat = {}

	-- Step 1 - Pull elements out in specfic order into flat array
	for i = 1, #array do
		local subArray = array[i]
		for j = 1, #subArray do
			flat[#flat+1] = subArray[j]
		end
	end

	-- Step 2 - Shuffle the array
	table.shuffle( flat )

	-- Step 3 - Re-insert the shuffle flat elements into the 2d array in the 
	--          same order they were extracted.
	local count = 1
	for i = 1, #array do
		local subArray = array[i]
		for j = 1, #subArray do
			subArray[j] = flat[count]  
			count = count + 1
		end
	end
end


-- Dump the original table
table.print_r( myTable)

-- Shuffle the 2d array
shuffle2d( myTable )

-- Dump the shuffled table
table.print_r( myTable)






-- =============================================
-- EXAMPLE END
-- =============================================
