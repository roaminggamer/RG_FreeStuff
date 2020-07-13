--
-- labelsInit.lua - Create Label Presets
--
local mgr = require "ssk2.core.interfaces.buttons"
local imagePath = "presets/"
local gameFont = ssk.__gameFont or native.systemFontBold

-- ============================
-- ======= Button 1
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "button1_unsel.png",
	selImgSrc    = imagePath .. "button1_sel.png",
}
mgr:addButtonPreset( "custom1", params )


-- ============================
-- ======= Button 2
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "button3_unsel.png",
	selImgSrc    = imagePath .. "button3_sel.png",
}
mgr:addButtonPreset( "custom2", params )

-- ============================
-- ======= Button 3
-- ============================
local params = 
{ 
	unselImgSrc  = imagePath .. "button2_unsel.png",
	selImgSrc    = imagePath .. "button2_sel.png",
}
mgr:addButtonPreset( "custom3", params )


