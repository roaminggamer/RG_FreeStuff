-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2016
-- =============================================================
-- 
-- =============================================================
-- ==
--    Localizations
-- ==
-- Corona & Lua
--
local mAbs = math.abs;local mRand = math.random;local mDeg = math.deg;
local mRad = math.rad;local mCos = math.cos;local mSin = math.sin;
local mAcos = math.acos;local mAsin = math.asin;local mSqrt = math.sqrt;
local mCeil = math.ceil;local mFloor = math.floor;local mAtan2 = math.atan2;
local mPi = math.pi
local pairs = pairs;local getInfo = system.getInfo;local getTimer = system.getTimer
local strFind = string.find;local strFormat = string.format;local strFormat = string.format
local strGSub = string.gsub;local strMatch = string.match;local strSub = string.sub
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale


local RGFiles        = ssk.RGFiles

-- Uncomment following line to count currently decalred locals (can't have more than 200)
--ssk.misc.countLocals(1)
-- =================================================================
--  MODULE CODE BEGINS HERE
-- =================================================================
local androidIcons = 
{
   {"Icon-xxxhdpi.png", 192 },
   {"Icon-xxhdpi.png", 144 },
   {"Icon-xhdpi.png", 96 },
   {"Icon-hdpi.png", 72 },
   {"Icon-mdpi.png", 48 },
   {"Icon-ldpi.png", 36 },
}
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

local iconFolder = "icons"

local iconGen = {}

function iconGen.run()

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
         --print( "A", curdir )
         --print( "B", lfs.chdir( "C:\\Program Files\\ImageMagick-6.9.3-Q16"  ) )
         --print( "B", lfs.chdir( lastSettings.pathtoImageMagick  ) )
         local curdir2 = lfs.currentdir()
         --print( "C", curdir2 )

         local src2 = RGFiles.resource.getPath( src )
         local dst2 = RGFiles.documents.getPath( dst )

         --print(src2)
         --print(dst2)

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
   ----[[
   for i = 1, #iosIcons do
     --genIcon( "images/rg1024.png", iosIcons[i][1], iosIcons[i][2], (i-1) * 250 )
     local size = iosIcons[i][2]
     genIcon( "images/rg1024.png", iconFolder .. "/" .. iosIcons[i][1], size, (i-1) * 250 )
     --genIcon( "test.png", iconFolder .. "/" .. "image_" .. size .. "_" .. iosIcons[i][1], size, (i-1) * 250 )
     --genIcon( "test.png", iosIcons[i][1], iosIcons[i][2], (i-1) * 250 )
   end
   --]]

end

function iconGen.run2()
   local function genIcons( src  )      
      print( src, dst, size, calibrationScale, delay )
      delay = delay or 0
      local lfs = require "lfs"
      local initialDir = lfs.currentdir()
      lfs.chdir( lastSettings.pathtoImageMagick )
      local src2 = RGFiles.resource.getPath( src )

      local command = ""

      for i = 1, #iosIcons do
         local name = iosIcons[i][1]
         local size = iosIcons[i][2]
         local dst2 = RGFiles.documents.getPath( RGFiles.util.repairPath( iconFolder .. "/" .. name ) )

         local scale = tostring( (100 * size)/1024 )
         if( command:len() > 0 ) then 
            command = command .. "\n"
            command = command .. "convert.exe " .. '"' .. src2 .. '"' .. " -resize " .. scale .. "% " .. '"' .. dst2 .. '"'
         else
            command = command .. "convert.exe " .. '"' .. src2 .. '"' .. " -resize " .. scale .. "% " .. '"' .. dst2 .. '"'
         end
      end

      print(command)
      print( "Success =? " .. tostring( os.execute( command ) == 0) )

      lfs.chdir( initialDir )
   end
   genIcons( "images/rg1024.png" )
   --[[
   for i = 1, #iosIcons do
     --genIcon( "images/rg1024.png", iosIcons[i][1], iosIcons[i][2], (i-1) * 250 )
     local size = iosIcons[i][2]
     genIcon( "images/rg1024.png", iconFolder .. "/" .. iosIcons[i][1], size, (i-1) * 250 )
     --genIcon( "test.png", iconFolder .. "/" .. "image_" .. size .. "_" .. iosIcons[i][1], size, (i-1) * 250 )
     --genIcon( "test.png", iosIcons[i][1], iosIcons[i][2], (i-1) * 250 )
   end
   --]]

end

function iconGen.run3( genAndroid, genIOS, onComplete)
   local function genIcon( src, dst, size, srcSize, delay, cb )
      dst = RGFiles.util.repairPath( dst )
      delay = delay or 0
      timer.performWithDelay( delay,
      function()
         local src2 = RGFiles.resource.getPath( src )
         local dst2 = RGFiles.documents.getPath( dst )
         local scale = tostring( (100 * size) / srcSize  )
         local command = "convert.exe " .. '"' .. src2 .. '"' .. " -resize " .. scale .. "% " .. '"' .. dst2 .. '"'
         --print(command)
         print( "Success =? " .. tostring( os.execute( command ) == 0) )
         if( cb ) then
            timer.performWithDelay( delay, cb )
         end
       end )
   end


   local listToGen = {}

   if( genAndroid ) then
      for i = 1, #androidIcons do
         listToGen[#listToGen+1] = androidIcons[i]         
      end
   end

   if( genIOS ) then
      for i = 1, #iosIcons do
         listToGen[#listToGen+1] = iosIcons[i]         
      end
   end


   for i = 1, #listToGen do
      local name = listToGen[i][1]
      local size = listToGen[i][2]
      if( i == #listToGen ) then
         genIcon( "images/rg1024.png", iconFolder .. "/" .. name, size, 1024, (i-1) * 1, onComplete )
      else
         genIcon( "images/rg1024.png", iconFolder .. "/" .. name, size, 1024, (i-1) * 1 )
      end
   end

end

return iconGen