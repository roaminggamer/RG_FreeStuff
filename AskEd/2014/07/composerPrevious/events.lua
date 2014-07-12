-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- events.lua
-- =============================================================


-- ==
-- Sound Events
-- ==
local function onEffectsVolumeChange( event )
	table.dump( event )
	--ssk.sounds:play( "Soundtrack" )
	ssk.sounds:setEffectsVolume( options.effectsVolume )

	if( options.musicVolume > 0 ) then
		ssk.sounds:play( "good" )
	end

end

local function onMusicVolumeChange( event )
	table.dump( event )
	ssk.sounds:setMusicVolume( options.musicVolume )

	if( options.musicVolume == 0 ) then
		-- ssk.sounds:stop( )
	else
		ssk.sounds:play( "Soundtrack" )
	end
end

ssk.gem:add( "EFFECTS_VOLUME_CHANGE", onEffectsVolumeChange )
ssk.gem:add( "MUSIC_VOLUME_CHANGE", onMusicVolumeChange )

