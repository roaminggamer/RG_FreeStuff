-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- SSK Tester
-- =============================================================
-- This is a quick test of the current library.
--
-- Warning: Not all features are tested here!
-- =============================================================

require "ssk.RGExtensions"

local tmp = {}
tmp.name = "bob"
tmp.age = 21
tmp.favoriteSDK = "Corona"


table.dump2( tmp )

local rgen = math.prand.new()

rgen:seed("edo")

print(rgen:randInt())
print(rgen:randInt())
print(rgen:randInt())

print(rgen:randInt(1000, 1255))

print(rgen:randInt(1000))

