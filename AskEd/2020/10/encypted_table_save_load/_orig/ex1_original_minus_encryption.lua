local timer = require( "timer" )
local composer = require( "composer" )
local json = require( "json" )
local ssl = require( "plugin.openssl" )
local cipher = ssl.get_cipher( "aes-256-cbc" )
local mime = require( "mime" )

-- This is WRONG.  If there variables version, playeLevel, music, and sfx are all 'nil', the table fields for those
-- entries will not get set and you'll have an empty table.
-- local testString = {
--   version = version,
--   playerLevel = playerLevel,
--   music = music,
--   sfx = sfx,
-- }
-- Added dummy version for test
local testString = {
  version = 1,
  playerLevel = 2,
  music = 3,
  sfx = 4,
}



local pass = "somePass"

testString = json.encode( testString )
print("original encoded table:", testString)

--local encryptedData = mime.b64( cipher:encrypt( testString, pass ) )

-- local path = system.pathForFile( "data.json", system.ResourseDirectory ) -- THIS IS WRONG!  MISPELLED AND YOU CANNOT SAVE TO RESOURCE DIRECTORY
local path = system.pathForFile( "data.json", system.DocumentsDirectory ) -- THIS IS WRONG!  MISPELLED AND YOU CANNOT SAVE TO RESOURCE DIRECTORY

local file = io.open( path, "w" )

if file then
  file:write( testString )
  io.close( file )
end

function LoadData(fileName)
  local path = system.pathForFile(fileName, system.DocumentsDirectory)  -- Changed to DOCUMENTS directory to match change above
  local contents = ""
  local myTable  = {}
  local file = io.open(path, "r")
  if(file) then
    contents = file:read()
    -- print("encrypted "..contents)
    -- contents = cipher:decrypt( mime.unb64( contents ), pass )
    print("decrypted "..contents)
    myTable = json.decode( contents )
    print(myTable)

    io.close(file)
    return myTable
  end
  return nil
end

local data = LoadData("data.json")
if(data) then
  version = data.version
  playerLevel = data.playerLevel
  music = data.music
  sfx = data.sfx
end

-- BAD FOR EXAMPLE. Make sure to use x,y every device has
-- local version = display.newText(version, 510, 340, native.systemFont, 20)
local version = display.newText(version, 100, 100, native.systemFont, 20)



