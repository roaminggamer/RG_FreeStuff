-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- events.lua
-- =============================================================

-- ==
-- Load the sounds
local mgr = ssk.sounds

mgr:addEffect("good", "sounds/good.wav")
mgr:addEffect("bad", "sounds/bad.wav")
mgr:addMusic("Soundtrack", "sounds/bouncing.mp3", nil, 1500)


-- ==
-- Set up sound event handlers
-- ==
local function onEffectsVolumeChange( event )
	--table.dump( event )
	--ssk.sounds:play( "Soundtrack" )
	ssk.sounds:setEffectsVolume( options.effectsVolume )

end

local function onMusicVolumeChange( event )
	--table.dump( event )
	ssk.sounds:setMusicVolume( options.musicVolume )

	--print( options.musicVolume )

	if( options.musicVolume == 0 ) then
		ssk.sounds:stop( "Soundtrack" )
	else
		ssk.sounds:play( "Soundtrack" )
	end
end

local function onPlayEffect( event )
	--table.dump( event )

	ssk.sounds:setEffectsVolume( options.effectsVolume )
	if( options.effectsVolume > 0 ) then
		ssk.sounds:play( event.effectName )
	end

end

ssk.gem:add( "EFFECTS_VOLUME_CHANGE", onEffectsVolumeChange )
ssk.gem:add( "MUSIC_VOLUME_CHANGE", onMusicVolumeChange )
ssk.gem:add( "PLAY_EFFECT", onPlayEffect )

