local public = {}
local private = {}

-- Forward Declarations

-- Useful Localizations
-- SSK
--
local isValid 			= display.isValid

-- Corona & Lua
--
local mAbs              = math.abs
local mRand             = math.random
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs

function public.load( levelName, layers, makers, params )
   
   
   params = params or {}
   local levelRoot = params.levelRoot or "levels."
   
   local level = require( levelRoot .. levelName )
   
   local layoutScale = params.layoutScale or tonumber(level.properties.layoutScale) or 1
   
   local srcSize  =  level.tilewidth * layoutScale -- level.tileheight Must be the same
   
   --print("EDO", srcSize, layoutScale)
   --table.dump( level )
   --table.dump( level.properties )
   local dstSize  = params.dstSize or srcSize

   -- Auto-center level based on grid width and height?
   --
   local ox = tonumber( centerX - (level.width * srcSize)/2 ) + srcSize
   local oy = tonumber( centerY - (level.height * srcSize)/2 ) - srcSize
   if( params.centerLevel ~= true ) then
      ox = 0
      oy = 0
   end

   -- Exclude objects not in bounds of grid?
   --
   local excludeObject
   if( params.excludeOutOfBounds == true ) then
      local minX = -srcSize
      local maxX = (level.width * level.tilewidth) + srcSize
      local minY = -srcSize
      local maxY = (level.height * level.tileheight)  + srcSize

      --print( minX, minY, maxX, maxY )

      excludeObject = function( obj )
         return ( obj.x < minX or obj.x > maxX or obj.y < minY or obj.y > maxY )
      end
   else
      excludeObject = function( ) return false end
   end


   -- Show center?
   --
   if( params.showCenter ) then
      display.newLine( layers.background, centerX - 40, centerY, centerX + 40, centerY )
      display.newLine( layers.background, centerX, centerY - 40, centerX, centerY + 40 )
   end

   for i = 1, #level.layers do 
      local layerData = level.layers[i]

      if( layerData.type == "tilelayer" ) then
         -- Nothing yet
      
      elseif( layerData.type == "objectgroup" ) then         
         local layer
         if( params.passAllLayers == true ) then
            layer = layers
         else
            layer = layers[layerData.name]
         end
         local objects = table.deepCopy( layerData.objects )
         for j = 1, #objects do
            --table.dump(objects[j],nil,"tiledLoader : " .. tostring(j))
            local otype = objects[j].type
            local gid = tonumber(objects[j].gid)
            print(gid)
               
            local maker = makers[gid]
            if( maker and not excludeObject( objects[j]) ) then 
               objects[j].x = dstSize * objects[j].x/srcSize
               objects[j].y = dstSize * objects[j].y/srcSize
               maker( layer, objects[j], { ox = ox, oy = oy } )
            end
         end
      end
   end
   
   return level
end

return public
