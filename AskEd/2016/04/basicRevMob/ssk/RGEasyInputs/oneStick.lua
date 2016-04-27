-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- One Stick - Virtual Joystick Builder
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
local joystick 	= ssk.easyInputs.joystick
local newRect	= ssk.display.rect
local inputs

local function create( group, params )
	group 	= group or display.currentStage
	params 	= params or {}

	local debugEn 		= params.debugEn or false
	local fill 			= params.fill or {1,0,0}
	local alpha 		= params.alpha or debugEn and 0.25 or 0
	local eventName 	= params.eventName or "onJoystick"
	local startRight 	= fnn(params.startRight, true)
	local joyParams 	= params.joyParams or {}

	inputs = display.newGroup()
	group:insert(inputs)

	local inputObj = newRect( inputs, centerX, centerY,
		{ w = fullw, h = fullh, fill = fill, alpha = alpha, isHitTestable = true } )

	local sx = centerX + fullw/2 - 60
	local sy = centerY + fullh/2 - 60

	if( startRight  == false ) then 
		sx = centerX - fullw/2 + 60
	end

	joyParams.inputObj = inputObj
	joyParams.eventName = eventName
	joyParams.inUseAlpha = fnn( joyParams.inUseAlpha, 1 )
	joyParams.notInUseAlpha = fnn( joyParams.notInUseAlpha, 0.25 )

	joystick.create( inputs, sx, sy, joyParams )

end

local function destroy()
	display.remove(inputs)
	inputs = nil
end

local public = {}
public.create 	= create
public.destroy 	= destroy
return public