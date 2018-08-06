-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
local benchtype = "op" -- Measures Raw Operations Per Second
local name = "Creation Time - display.newRect()"
local benchOuter = 1 -- Times to run benchmark
local benchInner = 5000 -- Number of innner loops to run, objects to create, etc.

local theGroup
local tmp
local mRand = math.random

-- Any prep work you need to do before starting the benchmark  (not measured)
local function prep( group )
	theGroup = group
	print(theGroup, group)
	tmp = {}
end

-- Any cleanup work you need to do after the benchmark (not measured)
local function cleanup(  )
	print(theGroup)
	tmp = nil
	theGroup = nil
end

-- The actual benchmark (measured)
local function bench( numOps, group  )
	local w = w - 10
	local h = h - 10
	for i = 1, numOps do
		local x = mRand( 10, w )
		local y = mRand( 10, h )
		display.newRect( theGroup,  x, y, 20, 40 )
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