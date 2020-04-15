-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2020 (All Rights Reserved)
-- =============================================================

local stringSplit
local readFileToTable
local tableLoad
local sort

local lib = {}


local texturePacker = {}
lib.texturePacker = texturePacker

function texturePacker.getFrameDefinitions( params ) 
	local data = require(params.definition)
	return data
end

function texturePacker.newImageSheet( params ) 
	local baseDir = params.baseDir or system.ResourceDirectory
	local data = require(params.definition)
	print('boing',data)
	return graphics.newImageSheet( params.image, baseDir, data.sheet )	
end

function texturePacker.newImage( params ) 
	local baseDir = params.baseDir or system.ResourceDirectory
	local sheet = params.sheet
	if( not sheet ) then
		local data = require(params.definition)
		sheet = graphics.newImageSheet( params.image, baseDir, data.sheet   )
	end
	local group = params.parent or display.currentStage
	local x = params.x or 0
	local y = params.y or 0
	local frameIndex = params.frameIndex or 1
	return display.newImage( group, sheet, frameIndex, x, y )
end

function texturePacker.newSprite( params, seqData ) 
	local baseDir = params.baseDir or system.ResourceDirectory
	local sheet = params.sheet
	if( not sheet ) then
		local data = require(params.definition)
		sheet = graphics.newImageSheet( params.image, baseDir, data.sheet )
	end
	local group = params.parent or display.currentStage
	local x = params.x or 0
	local y = params.y or 0
	local out = display.newSprite( group, sheet, seqData )
	out.x = x
	out.y = y
	return out
end

-- ============================================================================
-- Helpers for Shoe Box (http://renderhjs.net/shoebox/)
-- ============================================================================
local shoeBox = {}
lib.shoeBox = shoeBox

function shoeBox.getFrameDefinitions( params ) 
	local data = require(params.definition)
	data.sheet = data.sheetData
	data.sheet = nil
	return data
end

function shoeBox.newImageSheet( params )
	local baseDir = params.baseDir or system.ResourceDirectory
	local data = require(params.definition)
	return graphics.newImageSheet( params.image, baseDir, data.sheetData  )	
end

function shoeBox.newImage( params ) 
	local baseDir = params.baseDir or system.ResourceDirectory
	local sheet = params.sheet
	if( not sheet ) then
		local data = require(params.definition)
		sheet = graphics.newImageSheet( params.image, baseDir, data.sheetData  )
	end
	local group = params.parent or display.currentStage
	local x = params.x or 0
	local y = params.y or 0
	local frameIndex = params.frameIndex or 1
	return display.newImage( group, sheet, frameIndex, x, y )
end

function shoeBox.newSprite( params, seqData ) 
	local baseDir = params.baseDir or system.ResourceDirectory
	local sheet = params.sheet
	if( not sheet ) then
		local data = require(params.definition)
		sheet = graphics.newImageSheet( params.image, baseDir, data.sheetData  )
	end
	local group = params.parent or display.currentStage
	local x = params.x or 0
	local y = params.y or 0
	local out = display.newSprite( group, sheet, seqData )
	out.x = x
	out.y = y
	return out
end


-- ============================================================================
-- Helpers for Free Texture Packer (http://free-tex-packer.com/)
-- ============================================================================
local freeTexturePacker = {}
lib.freeTexturePacker = freeTexturePacker

function freeTexturePacker.getFrameDefinitions( params ) 
	local baseDir = params.baseDir or system.ResourceDirectory
	local jsonData = tableLoad(params.definition, baseDir )	
	table.sort(jsonData.frames, sort)
	local data = {}
	data.frames = {}
	for i = 1, #jsonData.frames do
		local inFrame = jsonData.frames[i]
		local frame = {}
		data.frames[i] = frame
		frame.x 					= inFrame.frame.x
		frame.y 					= inFrame.frame.y
		frame.width 			= inFrame.frame.w
		frame.height 			= inFrame.frame.h
		frame.sourceWidth 	= inFrame.sourceSize.w
		frame.sourceHeight	= inFrame.sourceSize.h
		frame.sourceX 			= inFrame.spriteSourceSize.x
		frame.sourceY			= inFrame.spriteSourceSize.y
	end
	local meta = jsonData.meta
	data.sheetContentWidth = meta.size.w
	data.sourceHeight = meta.size.h
	return data
end

function freeTexturePacker.newImageSheet( params )
	local baseDir = params.baseDir or system.ResourceDirectory
	local jsonData = tableLoad(params.definition, baseDir )	
	table.sort(jsonData.frames, sort)
	local data = {}
	data.frames = {}
	for i = 1, #jsonData.frames do
		local inFrame = jsonData.frames[i]
		local frame = {}
		data.frames[i] = frame
		frame.x 					= inFrame.frame.x
		frame.y 					= inFrame.frame.y
		frame.width 			= inFrame.frame.w
		frame.height 			= inFrame.frame.h
		frame.sourceWidth 	= inFrame.sourceSize.w
		frame.sourceHeight	= inFrame.sourceSize.h
		frame.sourceX 			= inFrame.spriteSourceSize.x
		frame.sourceY			= inFrame.spriteSourceSize.y
	end
	local meta = jsonData.meta
	data.sheetContentWidth = meta.size.w
	data.sourceHeight = meta.size.h
	return graphics.newImageSheet( params.image, data, baseDir )	
end

function freeTexturePacker.newImage( params ) 
	local baseDir = params.baseDir or system.ResourceDirectory
	local sheet = params.sheet
	if( not sheet ) then
		local jsonData = tableLoad(params.definition, baseDir )	
		table.sort(jsonData.frames, sort)
		local data = {}
		data.frames = {}
		for i = 1, #jsonData.frames do
			local inFrame = jsonData.frames[i]
			local frame = {}
			data.frames[i] = frame
			frame.x 					= inFrame.frame.x
			frame.y 					= inFrame.frame.y
			frame.width 			= inFrame.frame.w
			frame.height 			= inFrame.frame.h
			frame.sourceWidth 	= inFrame.sourceSize.w
			frame.sourceHeight	= inFrame.sourceSize.h
			frame.sourceX 			= inFrame.spriteSourceSize.x
			frame.sourceY			= inFrame.spriteSourceSize.y
		end
		local meta = jsonData.meta
		data.sheetContentWidth = meta.size.w
		data.sourceHeight = meta.size.h
		sheet = graphics.newImageSheet( params.image, data, baseDir )
	end
	local group = params.parent or display.currentStage
	local x = params.x or 0
	local y = params.y or 0
	local frameIndex = params.frameIndex or 1
	return display.newImage( group, sheet, frameIndex, x, y )
end

function freeTexturePacker.newSprite( params, seqData ) 
	local baseDir = params.baseDir or system.ResourceDirectory
	local sheet = params.sheet
	if( not sheet ) then
		local jsonData = tableLoad(params.definition, baseDir )	
		table.sort(jsonData.frames, sort)
		local data = {}
		data.frames = {}
		for i = 1, #jsonData.frames do
			local inFrame = jsonData.frames[i]
			local frame = {}
			data.frames[i] = frame
			frame.x 					= inFrame.frame.x
			frame.y 					= inFrame.frame.y
			frame.width 			= inFrame.frame.w
			frame.height 			= inFrame.frame.h
			frame.sourceWidth 	= inFrame.sourceSize.w
			frame.sourceHeight	= inFrame.sourceSize.h
			frame.sourceX 			= inFrame.spriteSourceSize.x
			frame.sourceY			= inFrame.spriteSourceSize.y
		end
		local meta = jsonData.meta
		data.sheetContentWidth = meta.size.w
		data.sourceHeight = meta.size.h
		sheet = graphics.newImageSheet( params.image, data, baseDir )
		end
		local group = params.parent or display.currentStage
	local x = params.x or 0
	local y = params.y or 0
	local out = display.newSprite( group, sheet, seqData )
	out.x = x
	out.y = y
	return out
end

-- ============================================================================
-- Helpers for Leshy Sprite Tool (https://www.leshylabs.com/apps/sstool/)
-- ============================================================================
local leshy = {}
lib.leshy = leshy

function leshy.getFrameDefinitions( params ) 
	local baseDir = params.baseDir or system.ResourceDirectory
	local dataTxt = readFileToTable( params.definition, baseDir )
	local data = {}
	data.frames = {}
   data.sheetContentWidth = params.sheetContentWidth
	data.sheetContentHeight = params.sheetContentHeight
	for i = 1, #dataTxt do 
		local frame = {}
		data.frames[i] = frame
		--		
		local parts = stringSplit(dataTxt[i],",")
		--		
		frame.x = tonumber(parts[2])
		frame.y = tonumber(parts[3])
		frame.width = tonumber(parts[4])
		frame.height = tonumber(parts[5])
		frame.sourceWidth = params.sourceWidth
		frame.sourceHeight = params.sourceHeight
	end
	return data
end

function leshy.newImageSheet( params ) 
	local baseDir = params.baseDir or system.ResourceDirectory
	local dataTxt = readFileToTable( params.definition, baseDir )
	local data = {}
	data.frames = {}
   data.sheetContentWidth = params.sheetContentWidth
	data.sheetContentHeight = params.sheetContentHeight
	for i = 1, #dataTxt do 
		local frame = {}
		data.frames[i] = frame
		--		
		local parts = stringSplit(dataTxt[i],",")
		--		
		frame.x = tonumber(parts[2])
		frame.y = tonumber(parts[3])
		frame.width = tonumber(parts[4])
		frame.height = tonumber(parts[5])
		frame.sourceWidth = params.sourceWidth
		frame.sourceHeight = params.sourceHeight
	end
	return graphics.newImageSheet( params.image, data, baseDir )	
end

function leshy.newImage( params ) 
	local baseDir = params.baseDir or system.ResourceDirectory
	local sheet = params.sheet
	if( not sheet ) then
		local dataTxt = readFileToTable( params.definition, baseDir )
		local data = {}
		data.frames = {}
	   data.sheetContentWidth = params.sheetContentWidth
		data.sheetContentHeight = params.sheetContentHeight
		for i = 1, #dataTxt do 
			local frame = {}
			data.frames[i] = frame
			--		
			local parts = stringSplit(dataTxt[i],",")
			--		
			frame.x = tonumber(parts[2])
			frame.y = tonumber(parts[3])
			frame.width = tonumber(parts[4])
			frame.height = tonumber(parts[5])
			frame.sourceWidth = params.sourceWidth
			frame.sourceHeight = params.sourceHeight
		end
		sheet = graphics.newImageSheet( params.image, data, baseDir )
	end
	local group = params.parent or display.currentStage
	local x = params.x or 0
	local y = params.y or 0
	local frameIndex = params.frameIndex or 1
	return display.newImage( group, sheet, frameIndex, x, y )
end

function leshy.newSprite( params, seqData ) 
	local baseDir = params.baseDir or system.ResourceDirectory
	local sheet = params.sheet
	if( not sheet ) then
		local dataTxt = readFileToTable( params.definition, baseDir )
		local data = {}
		data.frames = {}
	   data.sheetContentWidth = params.sheetContentWidth
		data.sheetContentHeight = params.sheetContentHeight
		for i = 1, #dataTxt do 
			local frame = {}
			data.frames[i] = frame
			--		
			local parts = stringSplit(dataTxt[i],",")
			--		
			frame.x = tonumber(parts[2])
			frame.y = tonumber(parts[3])
			frame.width = tonumber(parts[4])
			frame.height = tonumber(parts[5])
			frame.sourceWidth = params.sourceWidth
			frame.sourceHeight = params.sourceHeight
		end
		sheet = graphics.newImageSheet( params.image, data, baseDir )
	end
	local group = params.parent or display.currentStage
	local x = params.x or 0
	local y = params.y or 0
	local out = display.newSprite( group, sheet, seqData )
	out.x = x
	out.y = y
	return out
end

-- =============================================================
-- =============================================================
-- =============================================================
local json = require "json"
sort = function (a,b)
	return a.filename < b.filename 
end

stringSplit = function( str, tok )
	local t = {}  -- NOTE: use {n = 0} in Lua-5.0
	local ftok = "(.-)" .. tok
	local last_end = 1
	local s, e, cap = str:find(ftok, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = str:find(ftok, last_end)
	end
	if last_end <= #str then
		cap = str:sub(last_end)
		table.insert(t, cap)
	end
	return t
end

local function ioExists( fileName, base )
   local base = base or system.DocumentsDirectory	
   if( base ) then
      fileName = system.pathForFile( fileName, base )
   end   
   if not fileName then return false end
   local attr = lfs.attributes( fileName )
   return (attr and (attr.mode == "file" or attr.mode == "directory") )
end

readFileToTable = function( fileName, base )
   local base = base or system.DocumentsDirectory
   local fileContents = {}
   if( ioExists( fileName, base ) == false ) then
      return fileContents
   end
   local fileName = fileName
   if( base ) then
      fileName = system.pathForFile( fileName, base )
   end
   local f=io.open(fileName,"rb")
   if (f == nil) then 
      return fileContents
   end
   for line in f:lines() do
      fileContents[ #fileContents + 1 ] = line
   end
   io.close( f )
   return fileContents
end

tableLoad = function( fileName, base )
   local base = base or system.DocumentsDirectory
   local path = system.pathForFile( fileName, base )
   if(path == nil) then return nil end
   local fh, reason = io.open( path, "r" )
   if( fh) then
      local contents = fh:read( "*a" )
      io.close( fh )
      local newTable = json.decode( contents )
      return newTable
   else
      return nil
   end
end

return lib
