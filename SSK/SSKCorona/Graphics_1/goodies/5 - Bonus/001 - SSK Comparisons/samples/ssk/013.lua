-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup() 

local function onRadio( event )
	local target = event.target 
	local phase  = event.phase

	if(target.isPressed) then
		print( "User toggled button: ", target:getText(), "DOWN")
	else
		print( "User toggled button: ", target:getText(), "UP")
	end

	return true  
end


-- Radio Button 1
ssk.buttons:presetRadio( group, "default", centerX, centerY - 45, 180, 40, "Button 1", onRadio )

-- Radio Button 2
ssk.buttons:presetRadio( group, "default", centerX, centerY, 180, 40, "Button 2", onRadio )

-- Radio Button 3
ssk.buttons:presetRadio( group, "default", centerX, centerY + 45, 180, 40, "Button 3", onRadio )

return group
