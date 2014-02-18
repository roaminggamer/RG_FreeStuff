-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup() 


local labelNames = {"vx", "vy", "nx", "ny", "percent", "phase", "state", "angle", "direction" }


local backImage = ssk.display.imageRect( group, centerX, centerY, "images/interface/starBack_380_570.png", {w = 380, h = 570, rotation = 90} )

-- Static Labels
local curX = 120
local curY = 50

local extraParams = { referencePoint = display.CenterRightReferencePoint, fontSize = 24, color = _WHITE_ }

for k,v in ipairs( labelNames ) do
	local tmp = ssk.labels:presetLabel( group, "default", v ..":", curX , curY, extraParams )
	curY = curY + 30
end

-- Dynamic Labels
local labels = {}
curX = 140
curY = 50
extraParams = { referencePoint = display.CenterLeftReferencePoint, fontSize = 24, color = _WHITE_ }

for k,v in ipairs( labelNames ) do
	labels[v] = ssk.labels:presetLabel( group, "default", "-", curX , curY, extraParams )
	labels[v].origX = curX
	curY = curY + 30
end

local function joystickListener( event )
	for k,v in ipairs( labelNames ) do
		labels[v]:setText(event[v] or "-")
		labels[v]:setReferencePoint(display.CenterLeftReferencePoint)
		labels[v].x = labels[v].origX
	end
end

ssk.gem:add( "myJoystickEvent", joystickListener )


ssk.inputs:createJoystick( group, centerX+140, centerY, 
                          { outerAlpha = 0.5, deadZoneAlpha = 0.5, 
						    stickRadius = 50, stickImg = "images/interface/dpad.png", 
						    eventName =  "myJoystickEvent", inputObj = backImage } )

return group
