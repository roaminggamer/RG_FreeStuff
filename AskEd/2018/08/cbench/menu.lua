-- =============================================================
-- menu.lua
-- =============================================================
-- Menu for SSK Sampler
--
--
-- Warning: This is NOT designed as an example and may be hard to follow.  
-- I wrote this for myself, to make it easier to show the examples.
--
-- =============================================================

--
-- A very long table/list of examples
--

local examples = {}
--              Example Name         Path
--              ------------         ----				

-- 
-- Display Objects vs. SSK Extended Display Objects
--
examples[#examples+1] = { "Display Objects: Basic",					"examples/display/001", 13, 5 }
examples[#examples+1] = { "Display Objects: Fill and Stroke",		"examples/display/002", 26, 5 }
examples[#examples+1] = { "Display Objects: Basic Text",			"examples/display/003", 6, 2 }
examples[#examples+1] = { "Display Objects: Colorized Text",		"examples/display/004", 10, 2 }
examples[#examples+1] = { "Display Objects: Lines",					"examples/display/005", 3, 3 }
examples[#examples+1] = { "Display Objects: Lines Color & Width",	"examples/display/006", 6, 3 }
examples[#examples+1] = { "Display Objects: Fancy Lines",			"examples/display/007", "", 23 }
examples[#examples+1] = { "Display Objects: Arrows and Arrowheads",	"examples/display/008", "", 6 }
examples[#examples+1] = { "Display Objects: More Fancy Lines",		"examples/display/009", "", 8 }

-- 
-- Physics
--
examples[#examples+1] = { "Physics: Simple Dynamic Body",			"examples/physics/001", 2, 1 }
examples[#examples+1] = { "Physics: Collision Filters",				"examples/physics/002", 27, 16 }

-- 
-- (Rendering) Layers
--
examples[#examples+1] = { "Layers",									"examples/layers/001", 7, 1 }


-- 
-- Buttons
--
examples[#examples+1] = { "Buttons: Push Buttons",					"examples/buttons/001", 69, 12 }
examples[#examples+1] = { "Buttons: Toggle Buttons",				"examples/buttons/002", "", 16 }
examples[#examples+1] = { "Buttons: Radio Buttons",					"examples/buttons/003", "", 16 }
examples[#examples+1] = { "Buttons: Push Buttons (Arcade Pack)",	"examples/buttons/004", "", 9 }


-- 
-- Inputs
--
examples[#examples+1] = { "Joystick: Basic",						"examples/inputs/001", "", 28 }
examples[#examples+1] = { "Joystick: Nicer",						"examples/inputs/002", "", 28 }



local paths = {}
local counts = {}
local buttonLabels = {}

for k,v in ipairs( examples ) do
	buttonLabels[k] = v[1]
	paths[v[1]] = v[2]
	counts[v[1]] = {v[3],v[4]}
end

local pureLabel
local sskLabel
local pureButton
local sskButton
local layers

local function enableButtons( pathBase, countValues )
	--print(pathBase)

	local purePath = pathBase .. "_pure.lua"
	local sskPath  = pathBase .. "_ssk.lua"

	if( io.exists( purePath, system.ResourceDirectory ) ) then
		pureLabel:setText("Pure Example: " .. purePath .. " => " .. countValues[1] .. " lines" )
		pureButton.lastPath = string.gsub( purePath, "%/", "." )
		pureButton.lastPath = string.gsub( pureButton.lastPath, "%.lua", "" )
		--print( pureButton.lastPath )
		pureButton:enable()
	else
		pureLabel:setText("Pure Example: none." )
		pureButton.lastPath = nil
		pureButton:disable()
	end

	if( io.exists( sskPath, system.ResourceDirectory ) ) then
		sskLabel:setText("SSK Example: " .. sskPath .. " => " .. countValues[2] .. " lines" )
		sskButton.lastPath = string.gsub( sskPath, "%/", "." )
		sskButton.lastPath = string.gsub( sskButton.lastPath, "%.lua", "" )
		--print( sskButton.lastPath )
		sskButton:enable()
	else
		pureLabel:setText("SSK Example: none." )
		sskButton.lastPath = nil
		sskButton:disable()
	end
end

local function onExampleSelect( event )
	local target = event.target
	local text   = target:getText()

	local pathBase = paths[text]
	local countValues = counts[text]
	enableButtons( pathBase, countValues )
	return true
end

local function onPure( event )
	timer.performWithDelay( 10, 
		function()
			require( event.target.lastPath )
			layers:removeSelf()
		end )
	return true
end

local function onSSK( event )
	timer.performWithDelay( 10, 
		function()
			require( event.target.lastPath )
			layers:removeSelf()
		end )
	return true
end

layers = ssk.display.quickLayers( nil, "background", "menu", "overlay" )

local exampleSelector = ssk.buttons:presetPush( layers.menu, "default", centerX, centerY - 50, 400, 40, 
											buttonLabels[1], ssk.sbc.tableRoller_CB, { fontSize = 20 } )	
ssk.sbc.prep_tableRoller( exampleSelector, buttonLabels, onExampleSelect ) 
pureButton = ssk.buttons:presetPush( layers.menu, "default", centerX - 105, centerY+10, 190, 40, "Pure", onPure, { fontSize = 20 } )	
sskButton = ssk.buttons:presetPush( layers.menu, "default", centerX + 105, centerY+10, 190, 40, "SSK", onSSK, { fontSize = 20 } )	
pureLabel = ssk.labels:quickLabel( layers.menu, "Pure Label", centerX, centerY + 60, nil, 14 )
sskLabel = ssk.labels:quickLabel( layers.menu, "SSK Label", centerX, centerY + 90, nil, 14 )


enableButtons( examples[1][2], { examples[1][3], examples[1][4] })
