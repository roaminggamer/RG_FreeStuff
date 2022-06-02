io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- Require these just once in main.lua
require "scripts.extensions.string"
require "scripts.extensions.io"
require "scripts.extensions.table"
require "scripts.extensions.math"
require "scripts.extensions.display"

-- =====================================================
-- =====================================================

-- 1 Initialize the local copy of the DB 
local user_db_module = require "scripts.user_db_module"
user_db_module.init() 


-- 1. Run this a few times first and add some names...
local example = require "scripts.example"

-- 2. ...then comment out above and run this....
-- Basic dump of names list to scrollview
-- local scroll_example = require "scripts.scroll_example"

