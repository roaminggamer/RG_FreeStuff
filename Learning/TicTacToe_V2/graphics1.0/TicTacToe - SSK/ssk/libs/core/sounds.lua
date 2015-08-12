-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Sound Manager
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================
local sounds

if( not _G.ssk.sounds ) then
	_G.ssk.sounds = {}
	_G.ssk.sounds.soundsCatalog = {}
	_G.ssk.sounds.effectsVolume = 0.8
	_G.ssk.sounds.musicVolume   = 0.8
	_G.ssk.sounds.musicChannel   = audio.findFreeChannel() 
	_G.ssk.sounds.effectsChannel = _G.ssk.sounds.musicChannel + 1
end

sounds = _G.ssk.sounds

audio.setMinVolume( 0.0 )
audio.setMaxVolume( 1.0 )


--EFM need more channels and way of handling volume
--EFM need error checking code too

-- ==
--    ssk.sounds:addEffect( name, file, stream, preload  ) - Creates a record for a new sound effect and optionally prepares it.
-- ==
function sounds:addEffect( name, file, stream, preload  )
	local entry = {}
	self.soundsCatalog[name] = entry

	entry.name     = name
	entry.file     = file
	entry.stream   = fnn(stream,false)
	entry.preload  = fnn(preload,false)
	entry.isEffect = true

	if(entry.preload) then
		if(entry.stream) then
			entry.handle = audio.loadStream( entry.file )
		else
			entry.handle = audio.loadSound( entry.file )
		end
	end
end

-- ==
--    ssk.sounds:addMusic( name, file, preload, fadein, stream  ) - Creates a record for a new music track and optionally prepares it.
-- ==
function sounds:addMusic( name, file, preload, fadein, stream  )
	local entry = {}
	self.soundsCatalog[name] = entry

	entry.name     = name
	entry.file     = file
	entry.stream   = fnn(stream,true)
	entry.preload  = fnn(preload,false)
	entry.fadein   = fnn(fadein, 500 )
	entry.stream   = true
	entry.isEffect = false

	if(entry.preload) then
		entry.handle = audio.loadStream( entry.file )
	end
end

-- ==
--    ssk.sounds:setEffectsVolume( value ) - Set the volume level for all sound effects played through the sound manager.
-- ==
function sounds:setEffectsVolume( value )
	self.effectsVolume = fnn(value or 1.0)
	if(self.effectsVolume < 0) then self.effectsVolume = 0 end
	if(self.effectsVolume > 1) then self.effectsVolume = 1 end
	audio.setVolume( sounds.effectsVolume, {channel = self.effectsChannel} )
	return self.effectsVolume
end

-- ==
--    ssk.sounds:getEffectsVolume( ) - Gets the volume level for all sound effects played through the sound manager.
-- ==
function sounds:getEffectsVolume( )
	return self.effectsVolume
end

-- ==
--    ssk.sounds:setMusicVolume( value ) - Set the volume level for all music tracks played through the sound manager.
-- ==
function sounds:setMusicVolume( value )
	self.musicVolume = fnn(value or 1.0)
	if(self.musicVolume < 0) then self.musicVolume = 0 end
	if(self.musicVolume > 1) then self.musicVolume = 1 end
	audio.setVolume( sounds.musicVolume, {channel = self.musicChannel} )
	return self.musicVolume
end

-- ==
--    ssk.sounds:getMusicVolume( ) - Gets the volume level for all music tracks played through the sound manager.
-- ==
function sounds:getMusicVolume(  )
	return self.musicVolume
end

-- ==
--    ssk.sounds:play( name ) - Plays a named sound effect or music track.
-- ==
function sounds:play( name )
	local entry = self.soundsCatalog[name]

	if(not entry) then
		print("Sound Manager - ERROR: Unknown sound: " .. name )
		return false
	end

	if(not entry.handle) then
		if(entry.stream) then
			entry.handle = audio.loadStream( entry.file )
		else
			entry.handle = audio.loadSound( entry.file )
		end
	end

	if(not entry.handle) then
		print("Sound Manager - ERROR: Failed to load sound: " .. name, entry.file )
		return false
	end

	if(entry.isEffect) then
		audio.setVolume( sounds.effectsVolume, {channel = self.effectsChannel} )
		audio.play( entry.handle, {channel = self.effectsChannel} )
	else
		audio.setVolume( sounds.musicVolume, {channel = self.musicChannel} )
		audio.play( entry.handle, {channel = self.musicChannel, loops = -1, fadein=entry.fadein} )
	end

	return true

end

-- ==
--    ssk.sounds:stop( name ) - Stops a currently-playing named sound effect or music track.
-- ==
function sounds:stop( name )
	local entry = self.soundsCatalog[name]

	if(not entry) then
		print("Sound Manager - ERROR: Unknown sound: " .. name )
		return false
	end

	if(entry.isEffect) then
		audio.stop( self.effectsChannel )
	else
		audio.stop( self.musicChannel )
	end

	return true

end

