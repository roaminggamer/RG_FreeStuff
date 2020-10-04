-- Extensions from SSK2 (https://roaminggamer.github.io/RGDocs/pages/SSK2/extensions/)
require "extensions.io"
require "extensions.string"
require "extensions.table"

-- Module to do encrypted save/load of table
local tableEncrypt = require "tableEncrypt"


-- Test
local originalTable = {
   version = 4,
   playerLevel = 100,
   music = 0,
   sfx = 0,
}
tableEncrypt.saveEncryptedTable( originalTable, "data4.json", "myPassword" )
local myTable = tableEncrypt.restoreEncryptedTable( "data4.json", "myPassword" )
local version = display.newText( myTable.version, 100, 100, native.systemFont, 20)
