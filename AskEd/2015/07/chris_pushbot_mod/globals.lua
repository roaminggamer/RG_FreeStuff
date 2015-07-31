
-- Prints all contents of a Lua table to the log.
local function printTable(table, stringPrefix)
	if not stringPrefix then
		stringPrefix = "### "
	end
	if type(table) == "table" then
		for key, value in pairs(table) do
			if type(value) == "table" then
				print(stringPrefix .. tostring(key))
				print(stringPrefix .. "{")
				printTable(value, stringPrefix .. "   ")
				print(stringPrefix .. "}")
			else
				print(stringPrefix .. tostring(key) .. ": " .. tostring(value))
			end
		end
	end
end

local globals = {}

globals.printTable = printTable

return globals

