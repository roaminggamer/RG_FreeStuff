-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Button (Presets) Editor (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2016 
-- =============================================================
-- 
-- =============================================================
local layersMgr = {}

local layers

function layersMgr.create( group )
	group = group or display.currentStage
	layers = ssk.display.quickLayers( group, 
		"skel",
		
		"mpane",

		"lpane",
		
		--"rpane",
		"rpane_buttonPreset",

		--"rpb",
		"rpb_buttonPreset",

		"tbar", 
		"bbar",

		"overlay",
		"dialog" ) -- reserved for 'overlay pane image'
	return layers
end

function layersMgr.destroy( )
	display.remove( layers )
	layers = nil
	return
end

function layersMgr.get( )
	return layers
end

return layersMgr