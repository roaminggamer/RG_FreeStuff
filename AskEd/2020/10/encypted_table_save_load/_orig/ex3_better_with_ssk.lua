local timer = require( "timer" )
local composer = require( "composer" )
local json = require( "json" )
local ssl = require( "plugin.openssl" )
local cipher = ssl.get_cipher( "aes-256-cbc" )
local mime = require( "mime" )

local debugEn = true

--
-- saveEncryptedTable() 
--
local function saveEncryptedTable( srcTable, fileName, password, baseDir  )
   password = password or "somePass"
   baseDir  = baseDir or system.DocumentsDirectory

   if(debugEn) then table.dump( srcTable, "(save) srcTable" ) end

   -- 1. JSON encode the table
   local encodedTable = json.encode( srcTable )
   if(debugEn) then print( '(save) encodedTable: ', encodedTable ) end

   -- 2. Encrypt the encoded data.
   local encryptedData = mime.b64( cipher:encrypt( encodedTable, password ) )
   if(debugEn) then print( '(save) encryptedData: ', encryptedData ) end

   -- 3. Write encrypted data to a file.
   io.writeFile( encryptedData, fileName, baseDir )

   return encryptedTable
end

--
-- restoreEncryptedTable() 
--
local function restoreEncryptedTable( fileName, password, baseDir )
   password = password or "somePass"
   baseDir  = baseDir or system.DocumentsDirectory

   -- 1. Load encrypted encrypted data from file.
   local encryptedData = io.readFile( fileName, baseDir )
   if(debugEn) then print( '(restore) encryptedData: ', encryptedData ) end

   -- 2. Decrypt to encoded JSON data.
   local encodedTable = cipher:decrypt( mime.unb64( encryptedData ), password )
   if(debugEn) then print( '(restore) encodedTable: ', encodedTable ) end

   -- 3. Decode JSON data to table.
   local restoredTable = json.decode(encodedTable)
   if(debugEn) then table.dump( restoredTable, "(restore) restoredTable" ) end


   return restoredTable   
end


--
-- TEST ABOVE CODE
-- 

-- A. Dummy test table
local originalTable = {
   version = 3,
   playerLevel = 100,
   music = 0,
   sfx = 0,
}

-- B. Save dummy table in encrypted format.
saveEncryptedTable( originalTable, "data3.json", "myPassword" )

-- C. Restore encrypted table from file.
local myTable = restoreEncryptedTable( "data3.json", "myPassword" )

-- D. Print 'version' to screen
local version = display.newText( myTable.version, 100, 100, native.systemFont, 20)



