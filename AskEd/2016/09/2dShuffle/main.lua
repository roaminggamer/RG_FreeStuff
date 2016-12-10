io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            debugLevel 				= 0 } )

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
