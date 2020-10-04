local timer = require( "timer" )
local composer = require( "composer" )
local json = require( "json" )
local ssl = require( "plugin.openssl" )
local cipher = ssl.get_cipher( "aes-256-cbc" )
local mime = require( "mime" )

local debugEn = true

local tableEncrypt = {}

--
-- saveEncryptedTable() 
--
tableEncrypt.saveEncryptedTable = function ( srcTable, fileName, password, baseDir  )
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
tableEncrypt.restoreEncryptedTable = function( fileName, password, baseDir )
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

return tableEncrypt