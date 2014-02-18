-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup() 

require( "data.rg_arcadeButtons.presets" ) -- Arcade Button Presets

ssk.buttons:presetPush( group,	"arcade_green",  centerX - 90, centerY - 45, 80, 80, "" )
ssk.buttons:presetPush( group,	"arcade_red",    centerX,      centerY - 45, 80, 80, "" )
ssk.buttons:presetPush( group,	"arcade_yellow", centerX + 90, centerY - 45, 80, 80, "" )

ssk.buttons:presetPush( group,	"arcade_blue",   centerX - 90, centerY + 50, 80, 80, "" )
ssk.buttons:presetPush( group,	"arcade_orange", centerX,      centerY + 50, 80, 80, "" )
ssk.buttons:presetPush( group,	"arcade_white",  centerX + 90, centerY + 50, 80, 80, "" )


return group
