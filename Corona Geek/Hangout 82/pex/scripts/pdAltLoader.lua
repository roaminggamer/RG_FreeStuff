local pexConverter = require "scripts.pexConverter"

local function pdAltLoader( group, x, y, name, params )

	print( group, x, y, name, params )

	local params 	= params or {}
	local width 	= params.width or 200
	local height 	= params.height or width
	local scale 	= params.scale or 1
	local ex 		= params.ex or 0
	local ey 		= params.ey or 0
	local imageRoot	= params.imageRoot or ""
	local altTexture = params.altTexture

	local sample = display.newContainer( group, width, height)
	sample.x = x
	sample.y = y

	local tmp = display.newRect( sample, 0, 0, width, height )
	tmp.x = 0
	tmp.y = 0
	tmp:setFillColor( 0,0,0,0 )
	tmp:setStrokeColor( 1, 1, 0, 1 )
	tmp.strokeWidth = 4

	-- Load and Display Particle(s)
	print("Loading particle data file: " .. imageRoot .. name .. ".pex")
	--local data = table.load( imageRoot .. name .. ".json", system.ResourceDirectory )		
	local data = pexConverter( imageRoot .. name .. ".pex")
	if( altTexture ) then
		data.textureFileName = altTexture 
	end

	data.textureFileName = imageRoot .. data.textureFileName

	--table.dump(data)

	for k,v in pairs(data) do
		data[k] = tonumber(v) or v 
	end


	if( data.gravityx == nil ) then
		print( "Fixing data.gravityx ", data.gravityx, " Changing to 0 ")
		data.gravityx = 0
	end

	if( data.gravityy == nil ) then
		print( "Fixing data.gravityy ", data.gravityy, " Changing to 0 ")
		data.gravityy = 0
	end

	if( data.minRadiusVariance == nil ) then
		print( "Fixing data.minRadiusVariance ", data.minRadiusVariance, " Changing to 0 ")
		data.minRadiusVariance = 0
	end

	if( data.sourcePositionVariancex == nil ) then
		print( "Fixing data.sourcePositionVariancex ", data.sourcePositionVariancex, " Changing to 0 ")
		data.sourcePositionVariancex = 0
	end

	if( data.sourcePositionVariancey == nil ) then
		print( "Fixing data.sourcePositionVariancey ", data.sourcePositionVariancey, " Changing to 0 ")
		data.sourcePositionVariancey = 0
	end

	if( data.yCoordFlipped == nil ) then
		print( "Fixing data.yCoordFlipped ", data.yCoordFlipped, " Changing to 0 ")
		data.yCoordFlipped = 1
	end

	data.maxParticles = round(data.maxParticles or 100, 0)
	print( "Rounded data.maxParticles ", data.maxParticles)

	data.particleLifespan = tonumber(data.particleLifespan) or 1.0
	print( "Converted data.particleLifespan ", data.particleLifespan)


	table.dump(data)
	

	local emitter = display.newEmitter( data )
	emitter.x = ex
	emitter.y = ey
	
	sample:insert( emitter )

	return sample
end

return pdAltLoader