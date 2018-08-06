-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
local benchtype = "ops" -- Measures Raw Operations Per Second
local name = "SSK: math2d.squarelength() - Number args"
local benchOuter = 30 -- Times to run benchmark
local benchInner = 10000 -- Number of innner loops to run

-- Any prep work you need to do before starting the benchmark  (not measured)
local function prep( group )
end

-- Any cleanup work you need to do after the benchmark (not measured)
local function cleanup( group )
end

-- The actual benchmark (measured)
local function bench( numOps, group  )
	local m2dSquareLength = ssk.math2d.squarelength
	local vec = { x = 100, y = 100 }

	for i = 1, numOps do
		local len2 = m2dSquareLength( vec.x, vec.y )
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