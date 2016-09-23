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

-- Note 1: This is a bad way to store data that is related
-- Note 2: It is better to tightly couple related data in a single table.
--
local saveData = {}
saveData.names = {}
saveData.amounts = {}
saveData.totalAmount = 0

saveData.names[1] = "Bram"
saveData.names[2] = "Zeno"
saveData.names[3] = "Lucas"
saveData.amounts[1] = 20
saveData.amounts[2] = 5
saveData.amounts[3] = 10


-- Hack to sort 'uncoupled', but related data.
--
-- WARNING: WILL ERROR OUT IF ALL TABLES DO NOT HAVE SAME NUMBER OF ENTRIES
--
local function uncoupledSort( tbl, keys, sortKey )

	-- Count entries
	local entries = #tbl[keys[1]]

	-- Temporarily Couple data
	local tmp = {}	
	for i = 1, entries do
		local tmp2 = {}
		tmp[i] = tmp2
		for k,v in pairs( keys ) do
			print(i,v)
			tmp2[v] = tbl[v][i]
		end
	end

	-- Sort
	table.print_r( tmp )
	local function compare(a,b)
		return tostring(a[sortKey]) < tostring(b[sortKey])
	end
	table.sort( tmp, compare )
	table.print_r( tmp )

	--Decouple data

	for i = 1, #tmp do
		for k,v in pairs(tmp[i]) do
			tbl[k][i] = v
		end
	end
end


table.print_r( saveData )

uncoupledSort( saveData, { "names", "amounts" }, "names" )

table.print_r( saveData )






-- =============================================
-- EXAMPLE END
-- =============================================
