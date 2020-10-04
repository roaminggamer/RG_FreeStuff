
--
-- I moved the body of the code to modules so I could easily try different versions and keep them all
-- around so future readers can easily compare them.
-- 

-- Note: I added a few of the the SSK2 core.extensions, because:
-- 1. Really.  Why not use code that is known to work.
-- 2. You should always reduced common code to functions placed somewhere logical and easy to remember.
--    In this case, I extended the io.*, table.*, and string.* libraries/modules.
-- 
require "extensions.io"
require "extensions.string"
require "extensions.table"

--
-- 0 - Original
--
-- require "ex0_original"


--
-- 1 - Original - Minus Compression (verify basic save works)
--
-- require "ex1_original_minus_encryption"


--
-- 2 - Original - All fixed up
--
-- require "ex2_original_all_fixed"

--
-- 3 - Original - All fixed up
--
-- require "ex3_better_with_ssk"

--
-- 4 - All fixed and reduced using SSK then made into a module
--
--[[
local tableEncrypt = require "tableEncrypt"
local originalTable = {
   version = 4,
   playerLevel = 100,
   music = 0,
   sfx = 0,
}
tableEncrypt.saveEncryptedTable( originalTable, "data4.json", "myPassword" )
local myTable = tableEncrypt.restoreEncryptedTable( "data4.json", "myPassword" )
local version = display.newText( myTable.version, 100, 100, native.systemFont, 20)
--]]



