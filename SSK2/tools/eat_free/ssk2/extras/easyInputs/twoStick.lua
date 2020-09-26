-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Two Stick - Split-Screen Virtual Joystick Factory
-- =============================================================
local easyInputs = _G.ssk.easyInputs or {}
_G.ssk.easyInputs = easyInputs
-- =============================================================
local joystick 	= ssk.easyInputs.joystick
local newRect 	= ssk.display.newRect
local inputs

local function create( group, params )
	group 	= group or display.currentStage
	params 	= params or {}

	system.activate("multitouch")

	local debugEn 			= params.debugEn or false
	local leftFill			= params.leftFill or {0,0,1}
	local rightFill			= params.rightFill or {1,0,0}
	local alpha 			= params.alpha or debugEn and 0.25 or 0
	local leftEventName 	= params.leftEventName or "onLeftJoystick"
	local rightEventName 	= params.rightEventName or "onRightJoystick"
	local leftJoyParams 	= params.leftJoyParams or params.joyParams or {}
	local rightJoyParams 	= params.rightJoyParams or params.joyParams or {}

	leftJoyParams = table.shallowCopy( leftJoyParams )
	rightJoyParams = table.shallowCopy( rightJoyParams )

	inputs = display.newGroup()
	group:insert(inputs)

	local left = newRect( inputs, centerX - fullw/4, centerY,
		{ w = fullw/2, h = fullh, fill = leftFill, alpha = alpha, 
		  myEventName = leftEventName, myFill = leftFill, isHitTestable = true })

	local right = newRect( inputs, centerX + fullw/4, centerY,
		{ w = fullw/2, h = fullh, fill = rightFill, alpha = alpha, 
		  myEventName = rightEventName, myFill = rightFill, isHitTestable = true })

	leftJoyParams.inputObj = left
	leftJoyParams.eventName = leftEventName
	leftJoyParams.inUseAlpha = fnn( leftJoyParams.inUseAlpha, 1 )
	leftJoyParams.notInUseAlpha = fnn( leftJoyParams.notInUseAlpha, 0.25 )

	rightJoyParams.inputObj = right
	rightJoyParams.eventName = rightEventName
	rightJoyParams.inUseAlpha = fnn( rightJoyParams.inUseAlpha, 1 )
	rightJoyParams.notInUseAlpha = fnn( rightJoyParams.notInUseAlpha, 0.25 )

	local sx = centerX - fullw/2 + 60
	local sy = centerY + fullh/2 - 60
	joystick.create( inputs, sx, sy, leftJoyParams )

	sx = centerX + fullw/2 - 60
	joystick.create( inputs, sx, sy, rightJoyParams )	
end
local function destroy()
	display.remove(inputs)
	inputs = nil
end

local public = {}
public.create 	= create
public.destroy 	= destroy
-- =============================================================
easyInputs.twoStick = public
return public