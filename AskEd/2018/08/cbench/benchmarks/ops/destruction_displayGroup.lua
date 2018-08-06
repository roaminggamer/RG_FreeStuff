-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
local benchtype = "ops" -- Measures Raw Operations Per Second
local name = "Destruction Time - display.newGroup()"
local benchOuter = 1 -- Times to run benchmark
local benchInner = 50000 -- Number of innner loops to run, objects to create, etc.

local tmp

-- Any prep work you need to do before starting the benchmark  (not measured)
local function prep( group )
	tmp = {}

	for i = 1, benchInner do
		tmp[i] = display.newGroup()
	end
end

-- Any cleanup work you need to do after the benchmark (not measured)
local function cleanup( group )
	tmp = {}
end


-- The actual benchmark (measured)
local function bench( numOps, group  )
	for i = 1, numOps do
		tmp[i]:removeSelf()
	end
	tmp = {}
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