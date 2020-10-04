local timer = require( "timer" )
local composer = require( "composer" )
local json = require( "json" )
local ssl = require( "plugin.openssl" )
local cipher = ssl.get_cipher( "aes-256-cbc" )
local mime = require( "mime" )

local testString = {
  version = version,
  playerLevel = playerLevel,
  music = music,
  sfx = sfx,
}
local pass = "somePass"

testString = json.encode( testString )

local encryptedData = mime.b64( cipher:encrypt( testString, pass ) )

local path = system.pathForFile( "data.json", system.ResourseDirectory )

local file = io.open( path, "w" )

if file then
  file:write( encryptedData )
  io.close( file )
end

function LoadData(fileName)
  local path = system.pathForFile(fileName, system.ResourseDirectory)
  local contents = ""
  local myTable  = {}
  local file = io.open(path, "r")
  if(file) then
    contents = file:read()
    print("encrypted "..contents)
    contents = cipher:decrypt( mime.unb64( contents ), pass )
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

local version = display.newText(version, 510, 340, native.systemFont, 20)
