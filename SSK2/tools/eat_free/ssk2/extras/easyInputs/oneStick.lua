-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- One Stick - Virtual Joystick Factory
-- =============================================================
local easyInputs = _G.ssk.easyInputs or {}
_G.ssk.easyInputs = easyInputs
-- =============================================================
local joystick 	= ssk.easyInputs.joystick
local newRect	= ssk.display.newRect
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

	return joystick.create( inputs, sx, sy, joyParams )

end

local function destroy()
	display.remove(inputs)
	inputs = nil
end

local public = {}
public.create 	= create
public.destroy 	= destroy
-- =============================================================
easyInputs.oneStick = public

return public