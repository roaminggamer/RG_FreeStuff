local Library = require "CoronaLibrary"

local sprite = Library:new{ name='sprite', publisherId='com.' }

local function toImageSheet( spriteSet )
	assert( spriteSet.spriteSheet, "toImageSheet(): Bad spriteSet parameter: spriteSet.spriteSheet is nil" )

	local options

	local spriteSheet = spriteSet.spriteSheet

	if spriteSheet.format == "simple" then
		local w = spriteSheet.width
		local h = spriteSheet.height
		options =
		{
			width = w,
			height = h,
			numFrames = spriteSet.numFrames,
		}
	elseif spriteSheet.format == "complex" then
		assert( spriteSheet.spriteSheetFrames, "spriteSheet.spriteSheetFrames is nil")
		options =
		{
			spriteSheetFrames = spriteSheet.spriteSheetFrames
		}
	end

	local filename = spriteSheet.filename
	local baseDir = spriteSheet.baseDir

	if baseDir then
		return graphics.newImageSheet( filename, baseDir, options )
	else
		return graphics.newImageSheet( filename, options )
	end
end

local function toSequenceData( spriteSet )
	assert( spriteSet.spriteSheet, "toSequenceData(): Bad spriteSet parameter: spriteSet.spriteSheet is nil" )

	local spriteSheet = spriteSet.spriteSheet

	local default =
	{
		name = "default",
		start = spriteSet.startFrame,
		count = spriteSet.numFrames,
	}

	local sequenceData = spriteSet.sequences or {}
	table.insert( sequenceData, default )

	return sequenceData
end

sprite.newSprite = function( spriteSet )
	assert( spriteSet, "spriteSet is nil", "sprite.newSprite(): spriteSet is nil." )

	local s

	if spriteSet.type == "newSpriteArgs" then
		assert( type( spriteSet.args ) == "table", "sprite.newSprite(): 'spriteSet.args' is nil." )

		s = display.newSprite( unpack( spriteSet.args ) )
	else
		assert( spriteSet.type == "spriteSet" or spriteSet.type == "spriteMultiSet", "sprite.newSprite(): incorrect 'spriteSet.type'." )

		local imageSheet = toImageSheet( spriteSet )
		local sequenceData = toSequenceData( spriteSet )

		assert( sequenceData, "sprite.newSprite(): failed to create sequenceData" )

		s = display.newSprite( imageSheet, sequenceData )
	end

	function s:prepare( name )
		s:setSequence( name )
	end

	return s
end

-- sprite.add( spriteSet, sequenceName, startFrame, frameCount, time, [loopParam] )
sprite.add = function( spriteSet, sequenceName, startFrame, frameCount, time, loopParam )
	assert( spriteSet, "spriteSet is nil", "sprite.addSprite(): spriteSet is nil." )
	assert( spriteSet.type == "spriteSet", "sprite.addSprite(): incorrect 'spriteSet.type'.")

	local sequences = spriteSet.sequences
	if not sequences then
		sequences = {}
		spriteSet.sequences = sequences
	end

	table.insert( sequences, item )

	local loopCount = 0
	local loopDirection
	if loopParam and 0 ~= loopParam then
		loopCount = 1
		if -1 == loopParam then
			loopDirection = "bounce"
		elseif -2 == loopParam then
			loopCount = 0
			loopDirection = "bounce"
		end
	end

	local item =
	{
		name = sequenceName,
		start = startFrame,
		count = frameCount,
		time = time,
		loopCount = loopCount,
		loopDirection = loopDirection,
	}

	table.insert( sequences, item )
end

local function spriteSheetToImageSheet( spriteSheet )
	assert( false, "spriteSheetToImageSheet() is not implemented." )

	return nil
end

-- sprite.newSpriteMultiSet()
sprite.newSpriteMultiSet = function( sequences )
	assert( #sequences > 0, "sprite.newSpriteMultiSet(): sequences array is empty." )

	-- Assume first element defines default sheet
	local defaultSheet = spriteSheetToImageSheet( sequences[1].sheet )

	assert( defaultSheet, "sprite.newSpriteMultiSet(): no sheet param." )

	local sequenceData = {}
	for i=1,#sequences do
		local seq = sequences[i]
		local imageSheet = spriteSheetToImageSheet( seq.sheet )

		local data =
		{
			sheet = imageSheet,
			frames = seq.frames,
		}
		table.insert( sequenceData, data )
	end

	local result =
	{
		type = "newSpriteArgs",
		args = { defaultSheet, sequenceData, }
	}

	return sequences
end

-- sprite.newSpriteSet( spriteSheet, startFrame, frameCount )
sprite.newSpriteSet = function( spriteSheet, startFrame, frameCount )
	assert( spriteSheet, "sprite.newSpriteSet(): spriteSheet is nil." )
	assert( spriteSheet.type == "spriteSheet", "sprite.newSpriteSet(): spriteSheet is malformed." )

	local result =
	{
		type = "spriteSet",
		spriteSheet = spriteSheet,
		numFrames = frameCount,

		startFrame=startFrame,
	}

	return result
end

-- sprite.newSpriteSheet( spriteSheetFile, [baseDir,]  frameWidth, frameHeight )
sprite.newSpriteSheet = function( ... )
	local args = { ... }

	local spriteSheetFile = args[1]

	local nextArg = 2
	local baseDir = args[nextArg]
	if type(baseDir) ~= "userdata" then
		baseDir = nil
	else
		nextArg = nextArg + 1
	end

	local frameWidth, frameHeight = args[nextArg], args[nextArg+1]

	local result =
	{
		type = "spriteSheet",
		format = "simple",
		width = frameWidth, height = frameHeight,
		filename = spriteSheetFile, baseDir = baseDir,
	}

	function result:dispose()
		-- no-op
	end

	return result
end

-- sprite.newSpriteSheetFromData( spriteSheetFile, [baseDir,] coordinateData )
sprite.newSpriteSheetFromData = function( ... )
	local args = { ... }

	local spriteSheetFile = args[1]

	local nextArg = 2
	local baseDir = args[nextArg]
	if type(baseDir) ~= "userdata" then
		baseDir = nil
	else
		nextArg = nextArg + 1
	end

	local coordinateData = args[nextArg]

	local result =
	{
		type = "spriteSheet",
		format = "complex",
		spriteSheetFrames = coordinateData.frames,
		filename = spriteSheetFile, baseDir = baseDir,
	}

	function result:dispose()
		-- no-op
	end

	return result
end

return sprite
