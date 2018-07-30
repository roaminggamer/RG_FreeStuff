-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local physics 		= require "physics"

-- ==
--    Localizations
-- ==
local topInset, leftInset, bottomInset, rightInset = display.getSafeAreaInsets()
local getTimer = system.getTimer;local strGSub = string.gsub
local strMatch = string.match; local strFind = string.find;
local strSub = string.sub; local strFormat = string.format
local mFloor = math.floor; local mRand = math.random
local tSort = table.sort

-- ==
--    Locals & Helper Functions
-- ==
local levelsPath 	= "levels"
local assetsRoot 	= "levels"

-- Helpers taken from PonyTiled: 
-- https://github.com/ponywolf/ponytiled/blob/master/com/ponywolf/ponytiled.lua
local FlippedHorizontallyFlag   = 0x80000000
local FlippedVerticallyFlag     = 0x40000000
local FlippedDiagonallyFlag     = 0x20000000
local ClearFlag                 = 0x1FFFFFFF
local function hasbit(x, p) return x % (p + p) >= p end
local function setbit(x, p) return hasbit(x, p) and x or x + p end
local function clearbit(x, p) return hasbit(x, p) and x - p or x end


-- =============================================================
-- Module
-- =============================================================
local tiledLoader = {}
_G.ssk = _G.ssk or {}
_G.ssk.tiled = tiledLoader

-- ==
--    new() - Returns a new loader object containing the processed data for a specified tiled 'level' file.
-- ==
function tiledLoader.new( params )
	params = params or {}

	local myCC

	local loader = {}

	-- Set collision calculator if provided or create default
	if( params.cc ) then
		myCC = params.cc
	else
		myCC = ssk.cc.newCalculator()
		myCC:addName( "default" )
		myCC:collidesWith( "default", { "default" } )
	end

	-- Raw level data
	local levelData

	-- Logic Records
	local logic = {}

	-- Processed records for each object
	local oRec = {}

	-- Image records containing: full path, width, height
	local images = {}

	-- Set Path for tiled levels
	function loader.setLevelsPath( path )
		levelsPath = strGSub( path, "%/", "." )
		assetsRoot = path
	end

	-- Load and pre-process level
	--
	function loader.load( path )

		-- Raw Tiled Level
		levelData = table.deepCopy(require( levelsPath .. "." .. path ))

		-- Parse objects into useable records
		for i = 1, #levelData.layers do 
			local layerData = levelData.layers[i]
			local layerName = levelData.layers[i].name
			local objects 	= layerData.objects

			if( layerData.type == "tilelayer" ) then
				-- Skip these
			elseif( layerData.name == "logic" ) then
				table.print_r(objects[i] )
				for i = 1, #objects do				
					logic[#logic+1] = table.deepCopy( objects[i] )
				end
				table.print_r(logic[#logic])
			
			elseif( layerData.name == "ignore" ) then
			elseif( layerData.type == "objectgroup" ) then 
				for i = 1, #objects do
					local rec = table.deepCopy(objects[i])
					local gid = tonumber(rec.gid)
					local flip = {}
					if( gid ) then
			      	flip.x 	= hasbit(gid, FlippedHorizontallyFlag)
			      	flip.y 	= hasbit(gid, FlippedVerticallyFlag)          
			      	flip.xy = hasbit(gid, FlippedDiagonallyFlag) 
		      	
			      	gid = clearbit(gid, FlippedHorizontallyFlag)
			      	gid = clearbit(gid, FlippedVerticallyFlag)
			      	gid = clearbit(gid, FlippedDiagonallyFlag)    
			      end
		      	rec.gid = gid
		      	rec.flip = flip

					oRec[#oRec+1] = rec					
					--rec.x = rec.x + rec.width/2
					--rec.y = rec.y - rec.height/2
					rec.layer = layerName
				end
			end
		end
		-- Create id indexed list of image records with this levelData:
		--  image - Full path to image
		--  width - Image original width
		-- height - Image original height
		-- 
		for k,v in pairs( levelData.tilesets ) do
			local firstgid = v.firstgid
			for i = 1, #v.tiles do
				local tile = v.tiles[i]
				local rec = table.shallowCopy( tile )
				--local doDump = ( rec.id == 5 and rec.height == 64 )
				images[firstgid+rec.id] = rec
				--[[
				if( doDump ) then
					table.print_r(rec)
					print(firstgid,rec.id)
				end
				--]]
				
				rec.id = nil
				if( strMatch( rec.image, "%.%." ) ) then
					rec.image = strGSub(rec.image,"%.%.", "" )
					while( strSub( rec.image, 1, 1 ) == "/" ) do
						rec.image = strSub( rec.image, 2 )
					end
				else
					rec.image = assetsRoot .. "/" .. rec.image
				end
			end		
		end

		--
		-- Attach image path to each record
		--
		for i = 1, #oRec do
			local rec = oRec[i]
			if( rec.gid ) then
				rec.image = images[rec.gid].image
			end
		end		
	end

	--
	-- Draw Object
	--
	local newRect = display.newRect
	local newImageRect = display.newImageRect
	local newPolygon = display.newPolygon
	local function drawNumber( group, obj, isIndex, params )
		local label = display.newText( group, params.num, 
			                            obj.x, obj.y, 
			                            native.systemFont, params.numberFontSize or 10 )
		label:setFillColor( unpack( params.numberFill or { 0, 0 , 0 } ) )
		local scale1 = (label.contentWidth/obj.contentWidth)
		local scale2 = (label.contentHeight/obj.contentHeight)
		if( scale1 > 1 or scale2 > 1 ) then
			if( scale1 > scale2 ) then
				label:scale( 1/scale1, 1/scale1 )
			else
				label:scale( 1/scale2, 1/scale2 )
			end
		end
		function label.enterFrame( self )
			self.x = obj.x
			self.y = obj.y
		end; listen("enterFrame",label)
		function label.finalize( self )
			ignoreList( {"enterFrame"}, self)
		end; label:addEventListener("enterFrame")
	end
	--
	function loader.drawObj( layers, rec, params ) 
		layers = layers or display.currentStage
		params = params or {}
		--
		local builders = params.builders or {}
		local bType = rec.type
		local buildFunc = builders[bType]
		--
		local obj
		local ox = params.ox or 0
		local oy = params.oy or 0

		local group = layers[rec.layer] or layers

		if( buildFunc ) then
			obj = buildFunc( loader, group, rec.x + ox, rec.y + oy, rec, params )

		elseif( rec.gid ) then
   		obj = newImageRect( group, images[rec.gid].image, rec.width, rec.height )
   		obj.x = rec.x + ox
   		obj.y = rec.y + oy   		
   		obj.rotation = rec.rotation or 0
   		obj.rec = rec
   		obj.anchorX = 0
   		obj.anchorY = 1
   	
		elseif( rec.shape == "polygon" ) then
			local polygon = {}
			for j = 1, #rec.polygon do
				local vertex = rec.polygon[j]
				polygon[#polygon+1] = vertex.x
				polygon[#polygon+1] = vertex.y
			end			
			rec.polygon = polygon
			local x,y = misc.offset_xy(polygon)
			rec.x = rec.x + x
			rec.y = rec.y + y
			obj = newPolygon( group, rec.x, rec.y, rec.polygon)
   	else
   		obj = newRect( group, rec.x + ox, rec.y + oy, rec.width, rec.height )
   		obj.rotation = rec.rotation or 0
   		obj.rec = rec
   		obj.anchorX = 0
   		obj.anchorY = 1
   	end
   	
   	if( rec.flip.x ) then obj.xScale = -obj.xScale end
   	if( rec.flip.y ) then obj.yScale = -obj.yScale end

   	if( buildFunc == nil ) then  	
   		tiledLoader.centerAnchor(obj)
   		--
	   	if( params.showNumber and params.num ) then
	   		drawNumber( group, obj, false, params )
	   	elseif( params.showGID and rec.gid ) then
	   		params.num = rec.gid or "n/a"
	   		drawNumber( group, obj, true, params )
	   	end
			-- 
			if( loader.getProperty( rec, "hasBody" ) ) then	   		
				loader.addBody( obj, rec, {} )
			end
			loader.amendVisualParams( obj, rec )		
		end

		if( params.behaviors ) then
			local behaviors = params.behaviors
			local myBehaviors = loader.getBehaviors( rec )
			for behaviorName, behaviorSettings in pairs( myBehaviors ) do
				-- hack to allow application of same behavior multiple times
				local tmpName = string.split(behaviorName,"_") 
				--table.dump(tmpName)
				if( #tmpName > 2 ) then
					behaviorName = tmpName[1] .. "_" .. tmpName[2]
				end
				behaviors.add( obj, behaviorName, behaviorSettings )
			end
		end
   	return obj
	end
	

	--
	-- Draw All Objects
	--
	function loader.draw( layers, params ) 
		layers = layers or display.currentStage
		params = params or {}
		for i = 1, #oRec do
			if( params.showNumber ) then
				params.num = i
			end
			loader.drawObj( layers, oRec[i], params )
		end
	end

	--
	-- For Each - call 'func( rec, index )' for each raw level data record
	function loader.forEach( func ) 
		for i = 1, #oRec do func(oRec[i], i) end
	end


	--
	-- Get Logic - returns logic table
	function loader.getLogic( ) 
		return table.deepCopy( logic )
	end

	--
	-- For Each Logic - call 'func( rec, index )' for each record from the 'logic' layer.
	function loader.forEachLogic( func ) 
		for i = 1, #logic do func(logic[i], i) end
	end

	--
	-- Get Render Order
	--
	function loader.getRenderOrder(  ) 
		return levelData.renderorder
	end

	--
	-- Get 'Tile' width
	--
	function loader.getTileWidth(  ) 
		return levelData.tilewidth
	end

	--
	-- Get 'Tile' width
	--
	function loader.getTileHeight(  ) 
		return levelData.tileheight
	end

	--
	-- Get 'Level' width
	--
	function loader.getWidth(  ) 
		return (levelData.width * levelData.tilewidth)
	end

	--
	-- Get 'Level' height
	--
	function loader.getHeight(  ) 
		return (levelData.height * levelData.tileheight)
	end

	--
	-- Get images
	--
	function loader.getImages( ) 
		return images
	end

	-- Get image
	--
	function loader.getImage( gid )		
		return images[gid]
	end

	--
	-- Get image
	--
	function loader.getImagePath( gid )
		return images[gid].image
	end

	--
	-- Get all objects
	--
	function loader.getRecords( ) 
		return oRec
	end

	-- Get an object by type
	--
	function loader.getRecordsByType( getType ) 
		local objs = {}
		-- Draw all non-excluded objects
		for i = 1, #oRec do
			local rec = oRec[i]
			if( rec.type == getType ) then
				objs[#objs+1] = rec
			end
		end
		return objs
	end

	-- Get property from record (or type record)
	-- 
	function loader.getProperty( rec, name )
		if( rec.properties ~= nil  and rec.properties[name] ~= nil ) then 
			return rec.properties[name]
		end
		--
		local pdat = loader.getImage(rec.gid)
		if( pdat == nil ) then return nil end
		--
		pdat = pdat.properties
		if( pdat ~= nil and pdat[name] ~= nil ) then
			return( pdat[name] )
		end
		--
		return nil
	end

	-- Get all properties for a record
	-- 
	function loader.getProperties( rec )
		local names = {}
		if( rec.properties ~= nil ) then 
			for k,v in pairs( rec.properties ) do
				names[k]=k
			end
		end
		--
		local pdat = loader.getImage(rec.gid)
		if( pdat ~= nil ) then
			pdat = pdat.properties
			if( pdat ~= nil ) then
				for k,v in pairs( pdat ) do
					names[k]=k
				end
			end
		end
		--
		local properties = {}
		for k,v in pairs(names) do
			properties[k] = loader.getProperty( rec, k )
		end
		--
		return properties
	end

	-- Get all behaviors for a record
	-- 
	function loader.getBehaviors( rec )
		local properties = loader.getProperties( rec )
		local behaviors = {}
		for k,v in pairs( properties ) do
			if( strMatch( k, "b_" ) ) then
				behaviors[k] = properties[k]
			end
		end
		return behaviors
	end

	--
	-- Add body to objects
	--
	local function amendPhysicsParamsDef( bodyDef, rec  )
		bodyDef.bounce = loader.getProperty( rec, "bounce" ) or 0.2
		bodyDef.density = loader.getProperty( rec, "density" ) or 1
		bodyDef.friction = loader.getProperty( rec, "friction" ) or 0
		bodyDef.isSensor = loader.getProperty( rec, "isSensor" ) 
	end
	local function amendPhysicsParams( obj, rec )
		local props = { "angularVelocity", "gravityScale", "isAwake", "isBullet",
		                "isFixedRotation", "isSleepingAllowed", "linearDamping" }

		for i = 1, #props do
			local name = props[i]
			local val = loader.getProperty( rec, name )
			if( val ) then
				--print("Setting ", name, val  )
				obj[name] = val
			end
		end
		--
		obj.colliderName = loader.getProperty( rec, "colliderName" ) or "default"
		--
		local linearVelocity = loader.getProperty( rec, "linearVelocity" )
		if( linearVelocity ) then
			linearVelocity = string.split(linearVelocity,",")
			obj:setLinearVelocity(linearVelocity[1], linearVelocity[2])
		end
	end
	function loader.addBody( obj, rec, params ) 
		params = params or {}
		--
		local pdat
		local properties = {}
		local img = loader.getImage(rec.gid)

		-- Get Object Group from image record if it has one
		if( img ) then		
			pdat = img.objectGroup
			properties = img.properties or {}
		end

		if( pdat ) then
			-- Now get the objects from that group.
			pdat = pdat.objects		

			local bodyType = loader.getProperty( rec, "bodyType" ) or "static"
			local colliderName = loader.getProperty( rec, "colliderName" ) or "default"

			local bodies = {}

			-- Generate body definition(s)
			for i = 1, #pdat do			
				local body = table.shallowCopy(params)
				bodies[#bodies+1] = body
				local pdr = pdat[i]
				if( pdr.shape == "rectangle" ) then
					--print(pdr.shape)
					local sx = pdr.x
					local sy = pdr.y
					local swidth = pdr.width
					local sheight = pdr.height
					local ox = sx - obj.contentWidth/2
					local oy = sy - obj.contentHeight/2
					local shape = {}
					body.shape = shape
					shape[1] = ox 
					shape[2] = oy
					--
					shape[3] = ox + swidth
					shape[4] = oy
					--
					shape[5] = ox + swidth
					shape[6] = oy + sheight
					--
					shape[7] = ox
					shape[8] = oy + sheight
					--
					amendPhysicsParamsDef( body, rec )
					body.filter = myCC:getCollisionFilter( colliderName )

				elseif( pdr.shape == "polygon" ) then
					--print(pdr.shape)
					local sx = pdr.x
					local sy = pdr.y					
					local shape = {}
					body.shape = shape
					amendPhysicsParamsDef( body, rec )
					body.filter = myCC:getCollisionFilter( colliderName )

					for i = 1, #pdr.polygon do
						shape[#shape+1] = pdr.polygon[i].x + sx - obj.contentWidth/2
						shape[#shape+1] = pdr.polygon[i].y + sy - obj.contentHeight/2
					end
				else
					print("UNKNOWN SHAPE? ", pdr.shape )
					--print(pdr.shape)
					--table.print_r(pdr)
				end								
			end
			--table.print_r(bodies)
			physics.addBody( obj, bodyType, unpack(bodies) )
			amendPhysicsParams( obj, rec )

		-- Is a circular body
		elseif( loader.getProperty( rec, "radius" ) ) then
			local bodyType = loader.getProperty( rec, "bodyType" ) or "static"
			local colliderName = loader.getProperty( rec, "colliderName" ) or "default"
			local body = { radius = tonumber(loader.getProperty( rec, "radius" )) }
			amendPhysicsParamsDef( body, rec )
			body.filter = myCC:getCollisionFilter( colliderName )
			physics.addBody( obj, bodyType, body )
			amendPhysicsParams( obj, rec )
			--print("no object group found")
			

		-- Is this a polygon?
		elseif( rec.shape == "polygon" ) then
			local bodyType = loader.getProperty( rec, "bodyType" ) or "static"
			local colliderName = loader.getProperty( rec, "colliderName" ) or "default"
			local body = { }
			body.shape = rec.shape
			amendPhysicsParamsDef( body, rec )			
			body.filter = myCC:getCollisionFilter( colliderName )
			physics.addBody( obj, bodyType, body )
			amendPhysicsParams( obj, rec )
			--print("no object group found")

		-- If not, just add a rectangular body
		else
			local bodyType = loader.getProperty( rec, "bodyType" ) or "static"
			local colliderName = loader.getProperty( rec, "colliderName" ) or "default"			
			local body = { }			
			amendPhysicsParamsDef( body, rec )			
			body.filter = myCC:getCollisionFilter( colliderName )
			physics.addBody( obj, bodyType, body )
			amendPhysicsParams( obj, rec )
			--print("no object group found ")
		end		
	end

	-- Modify visual parameters
	--
	function loader.amendVisualParams( obj, rec )
		local props = { 
			"alpha",
			"anchorX",
			"anchorY",
			"blendMode",
			"isHitTestMasked",
			"isHitTestable"
		}

		for i = 1, #props do
			local name = props[i]
			local val = loader.getProperty( rec, name )
			if( val ) then
				--print("Setting ", name, val  )
				obj[name] = val
			end
		end
		--
		if( loader.getProperty( rec, "isVisible" ) == nil )  then
			obj.isVisible = rec.visible 
		else
			obj.isVisible = loader.getProperty( rec, "isVisible" )
		end
		--
		local fill = loader.getProperty( rec, "fill" )
		if( fill ) then
			if( strMatch(fill,",") ) then
				fill = string.split(fill,",")
				for i = 1, 4 do
					fill[i] = fill[i] or 1
				end
				obj:setFillColor(unpack(fill))
			else
				obj:setFillColor(unpack(hexcolor(fill)))
			end
		end	
	end


	return loader
end

-- ==
--    getLevel() - EFM
-- ==
function tiledLoader.getLevel( name, params )
   params = params or { debugEn = false }
   local loader = tiledLoader.new( params )
   if( params.levelPath ) then
      loader.setLevelsPath( params.levelPath  )
   end
   loader.load( name, params )
   return loader
end

-- ==
--    stitch() - EFM
-- ==
function tiledLoader.stitch( records, loader, params )
   params = params or {}
   
   local cur = loader.getRecords()
   
   for i = 1, #cur do
      local rec = table.deepCopy(cur[i])
      records[#records+1] = rec

      if( params.ox ) then rec.x = rec.x + params.ox end
      if( params.oy ) then rec.y = rec.y + params.oy end
   end

   return records
end


-- ==
--    stitch2() - EFM
-- ==
function tiledLoader.stitch2( name, levelData, params )	
	levelData = levelData or {}
	params = params or {}
	--
	local dir   = params.dir
	local oy 	= params.oy or 0
	local ox 	= params.ox or 0
   --
   local loader = tiledLoader.new( params )
   --
   loader.setLevelsPath( params.levelsPath or "levels" )
   loader.load( name )
   
   --
   local records 		= loader.getRecords()
	local levelHeight = loader.getHeight()
	local levelWidth 	= loader.getWidth()
	local tileHeight 	= loader.getTileHeight()
	local tileWidth 	= loader.getTileWidth()
	--
	local tmp = {}
	for i = 1, #records do
		local rec = table.deepCopy( records[i] )		
		tmp[#tmp+1] = rec
		--
		rec.x = rec.x + ox
		rec.y = rec.y + oy
		--
		if( dir == "up" ) then
			rec.y = rec.y - levelHeight - tileHeight/2			
			rec.x = rec.x + tileWidth/2
		elseif( dir == "down" ) then
			rec.y = rec.y - tileHeight/2
			rec.x = rec.x + tileWidth/2
		elseif( dir == "right" ) then
			rec.y = rec.y - levelHeight - tileHeight/2			
			rec.x = rec.x + tileWidth/2
		end
		--
		if( rec.shape == "polygon" ) then
			local polygon = {}
			for j = 1, #rec.polygon do
				local vertex = rec.polygon[j]
				polygon[#polygon+1] = vertex.x
				polygon[#polygon+1] = vertex.y
			end			
			rec.polygon = polygon
			local x,y = misc.offset_xy(polygon)
			rec.x = rec.x + x
			rec.y = rec.y + y

		--elseif( not rec.gid ) then
			--table.print_r(rec)
		else
			--table.dump(rec)
			local entity = loader.getImage(rec.gid).image
			entity = entity:gsub( "/" , " ")
			entity = entity:gsub( "%." , " ")
			entity = entity:gsub( "png" , "")
			entity = entity:gsub( "levels" , "")
			entity = entity:gsub( " " , "")
			rec.entity = entity
		end
		--
		--table.dump(rec)
	end
	if( dir == "up" ) then
		local function compare(a,b)
		  	return a.y > b.y
		end
		tSort( tmp, compare)
	elseif( dir == "down" ) then
		local function compare(a,b)
		  	return a.y < b.y
		end
		tSort( tmp, compare)
	elseif( dir == "right" ) then
		local function compare(a,b)
		  	return a.x < b.x
		end
		tSort( tmp, compare)
	end
	
	--
	for i = 1, #tmp do
		levelData[#levelData+1] = tmp[i]
	end
	--	
	return loader, levelData, levelWidth, levelHeight
end

-- ==
-- https://github.com/ponywolf/ponyblitz/blob/master/com/ponywolf/ponytiled.lua
-- ==
tiledLoader.centerAnchor = function(obj)
  if obj.contentBounds then 
    local bounds = obj.contentBounds
    local actualCenterX, actualCenterY =  (bounds.xMin + bounds.xMax)/2 , (bounds.yMin + bounds.yMax)/2
    obj.anchorX, obj.anchorY = 0.5, 0.5  
    obj.x = actualCenterX
    obj.y = actualCenterY 
  end
end

return tiledLoader
