-- =============================================================
-- 'Basic Sound Manager' Module
-- =============================================================
require "scripts.globals"
-- =============================================================
local globalVolume 	= 1.0
local effectVolume 	= 1.0
local musicVolume 	= 1.0
--
local allSounds 	 	 = {}
--
local minEffectChannel = 4 -- Save bottom 5 channels for music.

-- =============================================================
local soundMgr = {}


-- ==
--		addEffect() - Adds effect record to list, loads it, and categorizes it.
-- ==
function soundMgr.addEffect( name, path, baseDir )
	if( not allSounds[name] ) then
		allSounds[name] = {
			category = "effect",
			handle 	= audio.loadSound( path, baseDir or system.ResourceDirectory  )
		}
	end
	return allSounds[name]
end

-- ==
--		addMusic() - Adds music record to list, loads it, and categorizes it.
-- ==
function soundMgr.addMusic( name, path, baseDir )
	if( not allSounds[name] ) then
		allSounds[name] = {
			category = "music",
			handle 	= audio.loadStream( path, baseDir or system.ResourceDirectory  )
		}
	end
	return allSounds[name]
end


-- ==
--		play() - Optionally rewind sound, automaticaly find a channel, set category specific volume for
--    this sound, then play sound.
-- ==
function soundMgr.play( name, options )
	options = options or {}
	--	
	local record = allSounds[name]
	--
	if( not record ) then return nil end
	--
	if( options.rewind ) then
		options.rewind = nil
		audio.rewind( record.handle )
	end
	
	-- Get free channel
	local channel
	if( record.category == "effect") then
		channel = audio.findFreeChannel( minEffectChannel + 1 )
	else
		channel = audio.findFreeChannel()
	end
	options.channel = channel

	-- Failed to get channel, abort.
	if( not channel ) then return 0 end

	-- Set channel volume based on 'current' settings.
	local volume = globalVolume
	if( record.category == "effect") then
		volume = volume * effectVolume
	else
		volume = volume * musicVolume
	end
	audio.setVolume( volume, { channel = channel } )

	print(volume,channel)
	-- Play the sound
	return audio.play( record.handle, options )
end

-- ==
--
-- ==
function soundMgr.setVolume( category, volume )	
	-- Passed number as first argument 
	if( tonumber( category ) ) then
		globalVolume = volume or 1

	elseif( category == "effect" ) then
		effectVolume = volume or 1
	
	elseif( category == "music" ) then
		musicVolume = volume or 1
	end
end

-- ==
--
-- ==
function soundMgr.getVolume( category )
	if( category == "effect" ) then
		return effectVolume
	
	elseif( category == "music" ) then
		return musicVolume
	end
	
	-- Assume 'nil' passed and return global volume
	return globalVolume
end

-- ==
--
-- ==
local function onSound( event )
	local options = {}
	for k,v in pairs( event ) do
		options[k] = v
	end
	-- Clear some un-needed fields from copy of event
	options.name = nil 
	options.time = nil
	options.sound = nil
	--
	print( soundMgr.play( event.sound , options ) )
end; listen( "onSound", onSound )


return soundMgr