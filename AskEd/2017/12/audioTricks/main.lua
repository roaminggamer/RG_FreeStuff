-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
--require "ssk2.loadSSK"
--_G.ssk.init()
-- =============================================================

local song = audio.loadSound( "Dub Eastern.mp3" )
print(song)
local channel, source = audio.play( song )
print("Channel: " .. tostring(channel) )
print("Source: " .. tostring(source) )

--for k,v in pairs( al ) do
--	print( k, v)
--end

al.Source(source, al.PITCH, 0.5 )

print(  al.Source(source, al.POSITION ) )

