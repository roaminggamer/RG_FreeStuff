require "extensions.string"
require "extensions.table"
require "extensions.io"


local settings = {}

settings.volume = 0.5
settings.score = 10
settings.name = "Bob"
settings.inventory = { "eggs", "bacon" }

table.dump( settings )
table.print_r( settings )

table.save( settings, "settings.json",  system.DocumentsDirectory )

settings = nil -- clearing to prove it loads

settings = table.load( "settings.json",  system.DocumentsDirectory )

table.dump( settings )
table.print_r( settings )

