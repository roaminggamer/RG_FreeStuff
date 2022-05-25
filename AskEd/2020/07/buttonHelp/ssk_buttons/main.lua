io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================

-- Load button 'presets' - Used later to make buttons as needed.
require "presets.presets"


-- *************************************************************************************
-- Push buttons examples
-- *************************************************************************************
local function onPush ( event ) 	
	--for k,v in pairs(event) do print( k, v ) end  -- Uncommment to print all event details

	print( " Button id: " .. tostring(event.target.id) )
end

local group = display.newGroup()

local tmp = ssk.easyIFC:presetPush( group, "custom1", 200, 100, 316/2, 139/2, "", onPush )
tmp.id = "button 1"
local tmp = ssk.easyIFC:presetPush( group, "custom1", 200, 200, 316/2, 139/2, "", onPush )
tmp.id = "button 2"
local tmp = ssk.easyIFC:presetPush( group, "custom1", 200, 300, 316/2, 139/2, "", onPush )
tmp.id = "button 3"

tmp = nil



-- *************************************************************************************
-- Toggle buttons example
-- *************************************************************************************
local toggleButtons = {}

local function onToggle ( event )
	if( event.phase == "began" or event.phase == "ended"  ) then
		print( "\n dumping pressed status of all toggle buttons.")
		for i = 1, #toggleButtons do			
			print( toggleButtons[i].id, toggleButtons[i]:pressed() )
		end
	end
end

local tmp = ssk.easyIFC:presetToggle( group, "custom2", 450, 100, 171/2, 173/2, "", onToggle )
tmp.id = "toggle 1"
toggleButtons[#toggleButtons+1] = tmp

local tmp = ssk.easyIFC:presetToggle( group, "custom2", 450, 200, 171/2, 173/2, "", onToggle )
tmp.id = "toggle 2"
toggleButtons[#toggleButtons+1] = tmp

local tmp = ssk.easyIFC:presetToggle( group, "custom2", 450, 300, 171/2, 173/2, "", onToggle )
tmp.id = "toggle 3"
toggleButtons[#toggleButtons+1] = tmp

tmp = nil



-- *************************************************************************************
-- Radio buttons example
-- *************************************************************************************
local radioButtons = {}

local radioGroup = display.newGroup() -- Radio buttons in this group are 'associated' and only one a can be selected at a time.

-- Common pressed listener for push buttons
local function onRadio ( event )
	if( event.phase == "ended"  ) then
		print( "\n dumping pressed status of all toggle buttons.")
		for i = 1, #radioButtons do			
			print( radioButtons[i].id, radioButtons[i]:pressed() )
		end
	end
end

local tmp = ssk.easyIFC:presetRadio( radioGroup, "custom3", 150, 500, 171/2, 173/2, "", onRadio )
tmp.id = "radio 1 A"
radioButtons[#radioButtons+1] = tmp

local tmp = ssk.easyIFC:presetRadio( radioGroup, "custom3", 300, 500, 171/2, 173/2, "", onRadio )
tmp.id = "radio 2 A"
radioButtons[#radioButtons+1] = tmp

local tmp = ssk.easyIFC:presetRadio( radioGroup, "custom3", 450, 500, 171/2, 173/2, "", onRadio )
tmp.id = "radio 3 A"
radioButtons[#radioButtons+1] = tmp

tmp = nil

radioButtons[2]:toggle(true)
