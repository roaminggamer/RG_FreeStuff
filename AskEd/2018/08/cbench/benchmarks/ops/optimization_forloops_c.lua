-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
local benchtype = "ops" -- Measures Raw Operations Per Second
local name = "Optimization: Better For Loops - pairs(myTable)"
local benchOuter = 30 -- Times to run benchmark
local benchInner = 10000 -- Number of innner loops to run



local myTable 

-- Any prep work you need to do before starting the benchmark  (not measured)
local function prep( group )
	myTable = {}
	for i = 1, 100 do
		myTable[i] = i 
	end
end

-- Any cleanup work you need to do after the benchmark (not measured)
local function cleanup( group )
	myTable = nil
end



-- The actual benchmark (measured)
local function bench( numOps, group  )
	local fpairs = ipairs
	for i = 1, numOps do
		for j,v in fpairs(myTable) do
		end
	end
end

-- DO NOT EDIT BELOW THIS LINE
local public = {}
public.benchtype = benchtype
public.name = name
public.prep = prep
public.cleanup = cleanup
public.bench = bench
public.iterations = benchOuter
public.numOps = benchInner

return public