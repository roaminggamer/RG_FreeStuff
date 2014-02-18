-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup() 

-- Quick Labels

local testFont = "Courier New" -- May not work on individual devices
local testFont2 = "Arial Black" -- May not work on individual devices

ssk.labels:quickLabel( group, "quick label #1", centerX, 40 )
ssk.labels:quickLabel( group, "quick label #2", centerX, 65, testFont, 24, _BRIGHTORANGE_ )
ssk.labels:quickLabel( group, "quick label #3", centerX, 95, testFont2, 32, ssk.ggcolor:fromName( "PowderBlue", true ) )

-- Quick Embossed Labels

local testFont = "Courier New" -- May not work on individual devices
local testFont2 = "Arial Black" -- May not work on individual devices

ssk.labels:quickEmbossedLabel( group, "quick embossed label #1", centerX, 120 )
ssk.labels:quickEmbossedLabel( group, "quick embossed label #2", centerX, 150, testFont2, 30, _RED_, _GREEN_, _BLUE_ )
ssk.labels:quickEmbossedLabel( group, "quick embossed label #3", centerX, 190, testFont, 28, 
							   ssk.ggcolor:fromName( "DarkSlateGrey", true ), 
							   ssk.ggcolor:fromName( "LightGoldenrod", true ), 
							   ssk.ggcolor:fromName( "DarkGoldenrod", true ) )

-- Preset Labels
ssk.labels:presetLabel( group, "default", "preset label #1", centerX, 220 )
ssk.labels:presetLabel( group, "default", "preset label #2", centerX, 250, {fontSize = 24, textColor = _BLUE_} )
ssk.labels:presetLabel( group, "default", "preset label #3", centerX, 280, {fontSize = 20, emboss = true, embossTextColor = _DARKGREY_} )



return group
