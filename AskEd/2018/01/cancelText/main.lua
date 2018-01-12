-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
--  main.lua
-- =============================================================
-- Start (code/comments)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { } )
-- =============================================================
-- Optionally enable meters to check FPS and Memory usage.
-- =============================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
-- =============================================================

local defaults = { "Line 1", "Line 2", "Line 3" }
local fields = {}
local currentField 

local function onUserInput( self, event )
	table.dump(event)
	if( event.phase == "began" ) then
		currentField = self
		self.last = self.text		
	elseif( event.phase == "ended" ) then
		currentField = nil
	end
end

local function onCancel( event )
	if( currentField ) then
		currentField.text = currentField.last
	end
	native.setKeyboardFocus(nil)
	for i = 1, #fields do
		print("Cancelled ", i, " ==> ", fields[i].text )
	end
end


local function onOK( event )
	native.setKeyboardFocus(nil)
	for i = 1, #fields do
		print("OK ", i, " ==> ", fields[i].text )
	end
end


for i = 1, 3 do
	local tmp = native.newTextField( centerX, top + 200 + i * 50, 300, 45 )
	tmp.text = defaults[i]
	tmp.userInput = onUserInput
	tmp:addEventListener( "userInput" )
	fields[i] = tmp
end

ssk.easyIFC:presetPush( nil, "default", centerX - 100, fields[3].y + 80, 100, 40, "Cancel", onCancel)
ssk.easyIFC:presetPush( nil, "default", centerX + 100, fields[3].y + 80, 100, 40, "OK", onOK)




