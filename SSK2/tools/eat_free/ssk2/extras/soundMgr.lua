-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local soundMgr = {}
_G.ssk.soundMgr = soundMgr

-- Local storage for sound handles
local allSounds 				= {} 

local debugLevel 				= 0
local globalVolume			= 1.0
local sfxVolume				= 1.0
local voiceVolume				= 1.0
local musicVolume				= 1.0

local audio    				= require "audio"
local getTimer 				= system.getTimer

local firstChannel 			= 1
local maxMusicChannels 		= 4
local maxVoiceChannels 		= 4
local firstMusicChannel 	= audio.findFreeChannel( audio.totalChannels  - maxMusicChannels + 1)
local firstVoiceChannel 	= audio.findFreeChannel( firstMusicChannel  - maxVoiceChannels)
local firstEffectChannel 	= audio.findFreeChannel( firstChannel )

--
-- dump( max ) 
--
function soundMgr.dump( name ) 
	if( name and allSounds[name] ) then
		table.print_r(allSounds[name])
	else
		table.print_r(allSounds)
	end
end

--
-- setMaxMusicChannels( max ) 
--
function soundMgr.setMaxMusicChannels( max )
	if( debugLevel > -1 ) then 
		print("WARNING: soundMgr.setMaxMusicChannels( max ) superceded by: soundMgr.setMaxChannels( music, voice )" )
		print("WARNING: Please call setMaxChannels( music, voice ) instead." )
	end
end
--
-- setMaxChannels( music, voice ) 
--
function soundMgr.setMaxChannels( music, voice ) 

	music = music or 4
	voice = voice or 4

	music = (music < 1) and 1 or music
	voice = (voice < 1) and 1 or voice

	local maxMusicChannels 		= music
	local maxVoiceChannels 		= voice
	
	local firstMusicChannel 	= audio.findFreeChannel( audio.totalChannels  - maxMusicChannels + 1)
	local firstVoiceChannel 	= audio.findFreeChannel( firstMusicChannel  - maxVoiceChannels)
	local firstEffectChannel 	= audio.findFreeChannel( firstChannel )

	if( debugLevel > 0 ) then
		print("soundMgr.setMaxChannels() - firstEffectChannel == " .. tostring(firstEffectChannel) )
		print("soundMgr.setMaxChannels() - firstVoiceChannel  == " .. tostring(firstVoiceChannel) )
		print("soundMgr.setMaxChannels() - firstMusicChannel  == " .. tostring(firstMusicChannel) )
	end

end

-- mute( isMuted, fadeTime )  
--
local muted = false
local lastVolume 

function soundMgr.mute( isMuted, fadeTime ) 
	--print("soundMgr.mute() ", isMuted, fadeTime, getTimer() ) 
	isMuted = fnn( isMuted, false )
	
	local playing = {}
	for k,v in pairs(allSounds) do		
		for l, m in pairs(v.playing) do
			playing[m]=m
		end
	end
	--for k,v in pairs( playing ) do 
		--table.dump(v)
	--end

	if( isMuted == muted ) then return end
	if( isMuted == false and not lastVolume ) then return end

	if( isMuted ) then
		lastVolume = globalVolume	
		for k,v in pairs( playing ) do 
			if(tonumber(fadeTime)) then
				audio.fade( { time = fadeTime, channel = v.channel, volume = 0 } )
			else
				audio.setVolume( 0, { channel = v.channel } )
			end
		end
	
		--		
		if(tonumber(fadeTime)) then
			timer.performWithDelay( tonumber(fadeTime), function() audio.setVolume( 0 ) end )			
		else
			audio.setVolume( 0 )
		end
		
	else

		audio.setVolume( lastVolume )
		lastVolume = nil
		--
		for k,v in pairs( playing ) do 
			if(tonumber(fadeTime)) then
				--print("fade up to 1", v.channel, v.volume)
				audio.fade( { time = fadeTime, channel = v.channel, volume = v.volume } )
			else
				--print("fade up to 2", v.channel, v.volume)
				audio.setVolume( v.volume, { channel = v.channel } )
			end
		end
	end
	muted = isMuted
end


-- setVolume( volume, volType ) 
--
function soundMgr.setVolume( volume, volType ) 
	volume = volume or 1
	volume = ( volume > 1 ) and 1 or volume
	volume = ( volume < 0 ) and 0 or volume

	if( volType == nil ) then
		globalVolume = volume
		audio.setVolume( volume )

		if( debugLevel > 0  ) then
			print("soundMgr.setVolume() - Global Volume == " .. volume )
		end

	elseif( volType == "voice" ) then
		voiceVolume = volume
		for i = firstVoiceChannel, firstMusicChannel - 1 do
			audio.setVolume( volume * globalVolume, { channel = i } )
		end

		if( debugLevel > 0  ) then
			print("soundMgr.setVolume() - Effect Volume == " .. volume )
		end

	elseif( volType == "effect" ) then
		sfxVolume = volume
		for i = firstEffectChannel, firstMusicChannel - 1 do
			audio.setVolume( volume * globalVolume, { channel = i } )
		end

		if( debugLevel > 0  ) then
			print("soundMgr.setVolume() - Effect Volume == " .. volume )
		end

	elseif( volType == "music" ) then
		musicVolume = volume
		for i = firstMusicChannel, audio.totalChannels do
			audio.setVolume( volume * globalVolume, { channel = i } )
		end

		if( debugLevel > 0  ) then
			print("soundMgr.setVolume() - Music Volume == " .. volume )
		end

	end
end


-- enableSFX( enable ) - Globally enable/disable sound effects.
--
local sfxEn = true
function soundMgr.enableSFX( enable )
	sfxEn = enable 
	if( enable == false ) then
		for i = firstEffectChannel, firstVoiceChannel - 1 do
			audio.setVolume( 0, { channel = i } )
		end
	else
		for i = firstEffectChannel, firstVoiceChannel - 1 do
			audio.setVolume( sfxVolume * globalVolume, { channel = i } )
		end
	end
end


-- enableVoice( enable ) - Globally enable/disable voice over effects.
--
local voiceEn = true
function soundMgr.enableVoice( enable )
	voiceEn = enable 
	if( enable == false ) then
		for i = firstVoiceChannel, firstMusicChannel - 1 do
			audio.setVolume( 0, { channel = i } )
		end
	else
		for i = firstVoiceChannel, firstMusicChannel - 1 do
			audio.setVolume( voiceVolume * globalVolume, { channel = i } )
		end
	end
end

-- enableMusic( enable ) - Globally enable/disable music
--
local musicEn = true
function soundMgr.enableMusic( enable )	
	musicEn = enable 
	if( enable == false ) then
		for i = firstMusicChannel, audio.totalChannels do
			audio.setVolume( 0, { channel = i } )
		end
	else
		for i = firstMusicChannel, audio.totalChannels do
			audio.setVolume( musicVolume * globalVolume, { channel = i } )
		end
	end
end

-- enableDebug( enable ) - Globally enable/disable sound debug messaging.
--
function soundMgr.setDebugLevel( level )
	debugLevel = fnn(level, 0)

	if( debugLevel > 0 ) then
		print("firstEffectChannel == " .. tostring(firstEffectChannel) )
		print("firstVoiceChannel  == " .. tostring(firstVoiceChannel) )
		print("firstMusicChannel  == " .. tostring(firstMusicChannel) )
	end

end

-- add( name, path, params ) - Add a sound record.
--
function soundMgr.add( name, path, params )

	-- Already exists.  Exit early.
	if( allSounds[name] ) then 
		if( debugLevel > -1 ) then 
			print("Warning: soundMgr.add() - soundMgr.add() name: " .. tostring(name) .. " already exists." )
		end
		return false
	end

	params = params or {}
	local soundType = params.soundType or "effect"
	local baseDir = params.baseDir or system.ResourceDirectory
	local preload = fnn( params.preload, false )

	if( soundType ~= "effect" and 
		 soundType ~= "voice"  and
		 soundType ~= "music" ) then
		error( "soundMgr.add( " .. tostring(name) .. ", ... ) - Unknown soundType: " ..
			    tostring( soundType ) )
		return
	end

	local record = {}

	allSounds[name] = record

	record.name 			= name
	record.path 			= path
	record.baseDir 		= baseDir
	record.soundType 		= soundType
	record.minTweenTime 	= params.minTweenTime
	record.sticky 			= params.sticky
	record.altVolume		= params.altVolume -- Modifies this sound's volume as a multiplier
	record.playing 		= {}


	if( preload )	then
		if( soundType == "effect" ) then
			record.handle = audio.loadSound( path, baseDir )
		elseif( soundType == "voice" ) then
			record.handle = audio.loadSound( path, baseDir )
		else
			record.handle = audio.loadStream( path, baseDir )
		end
		record.loaded = true
	else		
		record.loaded = false
	end
	return true
end

-- addEffect( name, path, params )
--
function soundMgr.addEffect( name, path, params )
	params = params or {}
	params.soundType = "effect"
	soundMgr.add( name, path, params )
end

-- addVoice( name, path, params )
--
function soundMgr.addVoice( name, path, params )
	params = params or {}
	params.soundType = "voice"
	soundMgr.add( name, path, params )
end

-- soundMgr.addMusic( name, path, params )
--
function soundMgr.addMusic( name, path, params )
	params = params or {}
	params.soundType = "music"
	soundMgr.add( name, path, params )
end


-- load( name ) - Load a specific sound to prepare it for playing.
--
function soundMgr.load( name )
	local record = allSounds[name]
	if( not record ) then return false end
	if( record.loaded ) then return true end		

	if( record.soundType == "effect" ) then
		record.handle = audio.loadSound( record.path, record.baseDir )
		record.loaded = true
		if( debugLevel > 0  ) then
			print("Loaded effect: " .. tostring(record.name) .. "(" .. tostring(record.handle) .. ")" )
		end

	elseif( record.soundType == "voice" ) then
		record.handle = audio.loadSound( record.path, record.baseDir )
		record.loaded = true
		if( debugLevel > 0  ) then
			print("Loaded voice: " .. tostring(record.name) .. "(" .. tostring(record.handle) .. ")" )
		end

	elseif( record.soundType == "music" ) then

		record.handle = audio.loadStream( record.path, record.baseDir )
		record.loaded = true
		if( debugLevel > 0  ) then
			print("Loaded music: " .. tostring(record.name) .. "(" .. tostring(record.handle) .. ")" )
		end
	end

	return true
end

-- removeAll( ) - Stop, release, then remove ALL sound records.
--
function soundMgr.removeAll(  )
	soundMgr.stopAll()
	soundMgr.releaseAll( nil, true )
	allSounds = {}
end



-- releaseAll( releaseType, force ) - Release sound resources.
--
function soundMgr.releaseAll( releaseType, force )
	force = fnn( force, false )

	for k,v in pairs( allSounds ) do
		if( v.loaded and ( releaseType == nil or releaseType == v.soundType) ) then
			if( force or not v.sticky ) then
				if( debugLevel > 0  ) then
					print("Unloading sound: " .. tostring(v.name) )
				end

				-- Stop any 'plays' of this sound so we can successfully release it
				for l, m in pairs( v.playing ) do
					audio.stop( m.channel )
				end
				v.playing = {}

				audio.dispose( v.handle )

				v.handle = nil
				v.loaded = false
			else
				if( debugLevel > 0  ) then
					print("soundMgr.releaseAll() - Skipping unload of sticky sound: " .. tostring( v.name ) )
				end
			end
		end
	end
end

-- release( name, force ) - Release sound resources.
--
function soundMgr.release( name, force )
	force = fnn( force, false )	
	local record = allSounds[name]
	if( not record ) then return false end
	if( not record.loaded ) then return true end

	if( force or not record.sticky ) then
		if( debugLevel > 0  ) then
			print("Unloading sound: " .. tostring(record.name) )
		end
		-- Stop any 'plays' of this sound so we can successfully release it
		for k, v in pairs( record.playing ) do
			audio.stop( v.channel )
		end
		record.playing = {}

		audio.dispose( record.handle )

		record.handle = nil
		record.loaded = false
	else
		if( debugLevel > 0  ) then
			print("soundMgr.release() - Skipping unload of sticky sound: " .. tostring( record.name ) )
		end
	end
end


-- stopAll( stopType ) - Stop all sounds (in a category).
--
function soundMgr.stopAll( stopType )
	--print(table.count(allSounds), "sound count")
	for k,v in pairs( allSounds ) do
		if( stopType == nil or stopType == v.soundType ) then
			-- Stop any 'plays' of this sound
			for l, m in pairs( v.playing ) do
				audio.stop( m.channel )
			end
			v.playing = {}
		end
	end
	-- ENSURE ALL SOUNDS ARE STOPPED
	if( stopType == nil ) then audio.stop() end
end


-- rewind( name, soundType ) - Stop a sound.
--
function soundMgr.rewind( name, soundType )	
	local record = allSounds[name]
	if( not record ) then return false end
	if( not record.loaded ) then return true end
	if( soundType ~= nil and record.soundType ~= soundType ) then return end

	-- Stop any 'plays' of this sound
	for k, v in pairs( record.playing ) do
		audio.rewind( v.channel )
	end
	record.playing = {}
end


-- stop( name, soundType  ) - Stop a sound.
--
function soundMgr.stop( name, soundType, noRewind )	
	local record = allSounds[name]
	if( not record ) then return false end
	if( not record.loaded ) then return true end
	if( soundType ~= nil and record.soundType ~= soundType ) then return end
	--
	for k, v in pairs( record.playing ) do
		if( not noRewind ) then
			audio.rewind( v.channel )
		end
		audio.stop( v.channel )
	end
	--audio.rewind( record.handle )
end


-- onSound (event listener)
--
local function onSound( event )
	local record = allSounds[event.sound]

	if( debugLevel > 1  ) then
		table.dump( event )
	end

	-- No Record found... abort
	--
	if( not record ) then 
		if( debugLevel > -1 ) then 
			print("Warning: soundMgr 'onSound' Listener - No record for sound " .. tostring(event.sound) .. " found?")
		end
		return 
	end

	-- Make sure this type of sound is enabled.
	--
	if( record.soundType == "effect" and sfxEn == false ) then 
		if( debugLevel > 1 ) then
			print("onSound() - Received 'effect' event, but effects are disabled." )
		end
		return 
	end
	if( record.soundType == "voice" and voiceEn == false ) then 
		if( debugLevel > 1 ) then
			print("onSound() - Received 'voice' event, but effects are disabled." )
		end
		return 
	end
	if(record.soundType == "music" and musicEn == false  )then 
		if( debugLevel > 1  ) then
			print("onSound() - Received 'music' event, but music is disabled." )
		end
		return 
	end

	-- Load the sound if it isn't loaded yet.
	--
	if( not record.loaded ) then
		if( record.soundType == "effect" ) then
			record.handle = audio.loadSound( record.path, record.baseDir )
			record.loaded = true

			if( debugLevel > 0 ) then
				print("Late loaded effect: " .. tostring(record.name) .. "(" .. tostring(record.handle) .. ")" )
			end

		elseif( record.soundType == "voice" ) then
			record.handle = audio.loadSound( record.path, record.baseDir )
			record.loaded = true

			if( debugLevel > 0 ) then
				print("Late loaded voice: " .. tostring(record.name) .. "(" .. tostring(record.handle) .. ")" )
			end

		elseif( record.soundType == "music" ) then
			record.handle = audio.loadStream( record.path, record.baseDir )
			record.loaded = true

			if( debugLevel > 0  ) then
				print("Late loaded music: " .. tostring(record.name) .. "(" .. tostring(record.handle) .. ")" )
			end
		end

	end

	-- Check to see if this sound has a 'minTweenTime' limit and skip if calculation fails
	--
	local curTime = getTimer()   
	if( record.minTweenTime and record.lastTime ) then      
		if( debugLevel > 1  ) then
			print( "Times:  cur / minTween / last ==> ", curTime, record.minTweenTime, record.lastTime )
		end
		if( curTime - record.lastTime < record.minTweenTime ) then			
			if( debugLevel > 0 ) then 
				print( "Warning: soundMgr 'onSound' Listener - Tried to play " .. tostring(record.name) .. " too soon (minTweenTime == " .. tostring(record.minTweenTime) .." ms).  Skipping.")
			end
			return
		end
	end
	record.lastTime = curTime

	-- Get a free channel in the proper set
	--
	local channel 
	if( record.soundType == "music" ) then
		channel = audio.findFreeChannel( firstMusicChannel )

	elseif( record.soundType == "voice" ) then
		channel = audio.findFreeChannel( firstVoiceChannel )
		if( channel >= firstMusicChannel ) then 
			if( debugLevel > 0 ) then 
				print( "Warning: soundMgr 'onSound' Listener - No more voice channels available!")
			end
			return 
		end

	else
		channel = audio.findFreeChannel( firstEffectChannel )
		if( channel >= firstVoiceChannel ) then 
			if( debugLevel > -1 ) then 
				print( "Warning: soundMgr 'onSound' Listener - No more effect channels available!")
			end
			return 
		end
	end	

	-- Music sounds are only allowed to play once.  i.e. Same sound can't be playing in two channels.
	--
	--if( record.soundType == "music" and table.count( record.playing ) > 0 ) then
	if( (record.soundType == "music" or record.soundType == "voice") and 
		 table.count( record.playing ) > 0 ) then
		if( debugLevel > -1 ) then 
			print( "Warning: soundMgr 'onSound' Listener - Tried to play " .. tostring(record.name) .. " (music or voice) and it is already playing.  Skipping.")
		end
		return		
	end

	if( channel ) then

		-- Apply Volume Settings To This Specific Channel
		local altVolume 	= record.altVolume or 1
		local soundType 	= record.soundType
		local volume = 0
		if( soundType == "effect" and sfxEn ) then
			volume = altVolume * sfxVolume * globalVolume
		
		elseif( soundType == "voice" and voiceEn ) then
			volume = altVolume * voiceVolume * globalVolume
		
		elseif( soundType == "music" and musicEn ) then
			volume = altVolume * musicVolume * globalVolume
		end
		audio.setVolume( volume, { channel = channel } )

		-- Generate a generic onComplete to clean up 
		--
		local function onComplete( self )
			record.playing[channel] = nil
			if( event.onComplete and type(event.onComplete) == "function" ) then
				event.onComplete()
			end
		end

		--table.dump( record, nil, record.name)
		local handle = audio.play( record.handle,  
			                        {	channel 		= channel, 
			                           loops 		= event.loops,
			                           duration 	= event.duration,
			                           onComplete 	= onComplete,
			                           fadein  		= event.fadein } )

		--print(record.soundType == "effect" , sfxEn, channel, handle )


		-- Track this sound so we can stop it later (and for music check)
		--
		record.playing[channel] = { handle = handle, channel = channel, time = getTimer(), volume = volume }
	end
end; Runtime:addEventListener( "onSound", onSound )

function soundMgr.stopListener( )	
	Runtime:removeEventListener( "onSound", onSound )
end


--[[
timer.performWithDelay(
	500,
	function()
		local function key( event ) 
		   if(event.phase == "up" and event.descriptor == "1" ) then
		   	soundMgr.mute(true, 500)
		   elseif(event.phase == "up" and event.descriptor == "2" ) then
		   	soundMgr.mute(false, 500)
		   end
		end; listen("key",key)
	end )
--]]

return soundMgr