-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
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
		"grid",
		"rulers",

		"lpane",
		--"rpane",
		"rpane_emitter",
		"rpane_image",
		--"rpb",
		"rpb_emitter",
		"rpb_image",

		"tbar", 
		"bbar",


		-- Layers used to load/select: emitters, images, etc.
		"select_block",
		"mpane_select",
		"rpane_select",		

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