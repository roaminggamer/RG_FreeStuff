-- Quick pex importer for Corona

local M = {}

local function getFile( filename, base )
  if not base then base = system.ResourceDirectory; end
  local path = system.pathForFile( filename, base )
  local contents
  local file = io.open( path, "r" )
  if file then
     contents = file:read( "*a" )
     io.close( file )	-- close the file after using it
  else
    assert(filename .. " not found")
  end
  return contents
end

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

    
local function strip(s)
  local t = {}
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    if c ~= "/" then
      if label ~= "particleEmitterConfig" and label ~= "texture" then
        print("Found:", label)
        local args = {} 
        local k = 1
        for w in string.gmatch(xarg, "[%w%.%-]+") do args[k] = w; k = k + 1; end
        for k = 1, #args, 2 do
          sk, sv = args[k], args[k+1]
          print(sk,"=",sv)
          if sk == "value" then
            t[label] = tonumber(sv)
          elseif sk == "x" or sk == "y" then
            t[label..sk] = tonumber(sv)
          elseif sk == "data" then 
            --skip
          else  
            t[label..firstToUpper(sk)] = tonumber(sv)
          end
        end
      elseif label == "texture" then
        local args = {} 
        local k = 1
        for w in string.gmatch(xarg, "[%w%.%-]+") do args[k] = w; k = k + 1; end
          for k = 1, #args, 2 do
            sk, sv = args[k], args[k+1]
            if sk == "name" then t["textureName"] = sv
          end
        end
      end  
    end
    i = j+1
  end
  return t
end

function M.load(pexFile, textureFileName)
  local pexData = {}
  local pexXML = getFile( pexFile )
  pexData = strip(pexXML)
  -- lifespan fix
  if pexData.particleLifeSpan == 0 then pexData.particleLifeSpan = 1 end
  pexData.particleLifespan = pexData.particleLifeSpan
  -- get filename or override
  pexData.textureFileName = textureFileName or pexData.textureName  
  return pexData  
end

return M