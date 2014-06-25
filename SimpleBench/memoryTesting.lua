local bench = require "simpleBench"
local round = bench.round

--
-- Test cost of table with 1,000,000 integer entries
-- 

-- Call once to prepare memory count
local mem,delta = bench.getMemCount()
print( "Starting memory usage == " .. round(mem,2) .. " KB")

-- Build and fill the table
local tmp = {}

for i = 1, 1000000 do
	tmp[i] = i 
end

-- Get current memory usage and delta since last measurement (in KB)
local mem,delta = bench.getMemCount()
print( "Current memory usage == " .. round(mem,2) .. " KB")
print( "Delta memory usage == " .. round(delta/1024,2) .. " MB (cost of 1,000,000 entry table)")
