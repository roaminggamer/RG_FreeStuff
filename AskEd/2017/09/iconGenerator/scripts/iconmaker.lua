local RGFiles        = ssk.RGFiles


-- ImageMagick http://www.imagemagick.org/script/index.php
local iconFolder = "icons"
--local iconsFolder = RGFiles.documents.getPath( iconFolder )
--RGFiles.util.rmFolder( iconsFolder )
--RGFiles.util.mkFolder( iconsFolder )

-- WORKED
--[[
local src1 = RGFiles.resource.getPath( "images/rg1024.png" )
local src2 = RGFiles.documents.getPath( "test.png" )
local dst = RGFiles.documents.getPath( "test2.png" )

print(src)
print(dst)

RGFiles.util.cpFile( src1, src2 )

--local command = '"' .. "C:\\Program Files\\ImageMagick-6.9.3-Q16\\convert.exe" .. '" '  .. '"' .. src2 .. '"' .. " -resize 16.31% " .. '"' .. dst .. '"'
local command = 'cd "' .. "C:\\Program Files\\ImageMagick-6.9.3-Q16" .. '"'
print(command)
print( "Success =? " .. tostring( os.execute( command ) == 0) )


local command = "convert.exe " .. '"' .. src2 .. '"' .. " -resize 16.31% " .. '"' .. dst .. '"'
print(command)
print( "Success =? " .. tostring( os.execute( command ) == 0) )
--]]

-- Also successful
--[[
local lfs = require "lfs"
local curdir = lfs.currentdir()
print( "A", curdir )
print( "B", lfs.chdir( "C:\\Program Files\\ImageMagick-6.9.3-Q16"  ) )

local curdir2 = lfs.currentdir()
print( "C", curdir2 )


local src1 = RGFiles.resource.getPath( "images/rg1024.png" )
local src2 = RGFiles.documents.getPath( "test.png" )
local dst = RGFiles.documents.getPath( "test2.png" )

print(src)
print(dst)

RGFiles.util.cpFile( src1, src2 )

local command = "convert.exe " .. '"' .. src2 .. '"' .. " -resize 16.31% " .. '"' .. dst .. '"'
print(command)
print( "Success =? " .. tostring( os.execute( command ) == 0) )


print( "D", lfs.chdir( curdir ) )

local curdir = lfs.currentdir()
print( "E", curdir )
--]]


local iosIcons = 
{
   {"Icon-167.png", 167},
   {"Icon-60@3x.png", 180},
   {"Icon-Small-40@3x.png", 120},
   {"Icon-Small@3x.png", 87},
   {"Icon-60.png", 60},
   {"Icon-60@2x.png", 120},
   {"Icon-76.png", 76},
   {"Icon-76@2x.png", 152},
   {"Icon-Small-40.png", 40},
   {"Icon-Small-40@2x.png", 80},
   {"Icon.png", 57},
   {"Icon@2x.png", 114},
   {"Icon-72.png", 72},
   {"Icon-72@2x.png", 144},
   {"Icon-Small-50.png", 50},
   {"Icon-Small-50@2x.png", 100},
   {"Icon-Small.png", 29},
   {"Icon-Small@2x.png", 58},
}


local function genIcon( src, dst, size, delay )
  dst = RGFiles.util.repairPath( dst )
  print( src, dst, size, calibrationScale, delay )
  --if( true ) then return end
  delay = delay or 0

  --if( true ) then return end
  timer.performWithDelay( delay,
    function()
      local lfs = require "lfs"
      local curdir = lfs.currentdir()
      print( "A", curdir )
      print( "B", lfs.chdir( "C:\\Program Files\\ImageMagick-6.9.3-Q16"  ) )

      local curdir2 = lfs.currentdir()
      print( "C", curdir2 )


      local src2 = RGFiles.documents.getPath( src )
      local dst2 = RGFiles.documents.getPath( dst )

      print(src2)
      print(dst2)

      --RGFiles.util.cpFile( src2, src2 )

      --local command = "convert.exe " .. '"' .. src2 .. '"' .. " -resize 16.31% " .. '"' .. dst2 .. '"'
      local scale = tostring( (100 * size)/1024 )
      local command = "convert.exe " .. '"' .. src2 .. '"' .. " -resize " .. scale .. "% " .. '"' .. dst2 .. '"'
      print(command)
      print( "Success =? " .. tostring( os.execute( command ) == 0) )


      print( "D", lfs.chdir( curdir ) )

      local curdir = lfs.currentdir()
      print( "E", curdir )
    end )
end
--[[
for i = 1, #iosIcons do
  --genIcon( "images/rg1024.png", iosIcons[i][1], iosIcons[i][2], (i-1) * 250 )
  local size = iosIcons[i][2]
  genIcon( "test.png", iconFolder .. "/" .. iosIcons[i][1], size, (i-1) * 250 )
  --genIcon( "test.png", iconFolder .. "/" .. "image_" .. size .. "_" .. iosIcons[i][1], size, (i-1) * 250 )
  --genIcon( "test.png", iosIcons[i][1], iosIcons[i][2], (i-1) * 250 )
end
--]]