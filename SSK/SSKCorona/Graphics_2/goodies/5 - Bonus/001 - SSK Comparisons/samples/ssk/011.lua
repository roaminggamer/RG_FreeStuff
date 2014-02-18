-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup() 


local function onPush( event )
	local target = event.target 
	local phase  = event.phase

	print( "User pressed button: ", target:getText())

	return true  
end

-- Push Button 1
ssk.buttons:presetPush( group, "default", centerX, centerY - 45, 180, 40, "Button 1", onPush )

-- Push Button 2
ssk.buttons:presetPush( group, "default", centerX, centerY, 180, 40, "Button 2", onPush )

-- Push Button 3
ssk.buttons:presetPush( group, "default", centerX, centerY + 45, 180, 40, "Button 3", onPush )

group.y = group.y + 10

return group
