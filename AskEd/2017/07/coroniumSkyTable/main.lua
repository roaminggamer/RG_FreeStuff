-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015 
-- =============================================================
-- main.lua
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( )


local skytable = require "skytable.client"

skytable:init({
  user = "roaminggamer",
  password = "corona",
  base = "app1",
  host = "http://45.55.96.234:7173",
  key = "ab34b95ef9cc8b024bd184",
  debug = true
})

local profile = skytable:open("profile")

local function onSet( event )
	table.dump(event)
end
profile:set("age", 23, onSet)

local function onGet( event )
	table.dump(event)
end
profile:get("age", onGet)
