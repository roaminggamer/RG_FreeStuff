-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Button (Presets) Editor (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
local mgr 				= require "ssk2.core.interfaces.buttons"
local imagePath 		= "images/targets/"
local gameFont 		= ssk.gameFont() or native.systemFontBold

-- ============================
-- ========= DEFAULT BUTTON
-- ============================
local default_params = 
{ 
	labelColor				= {1,1,1,1},
	labelSize				= 16,
	labelFont				= gameFont,
	labelOffset         	= {0,1},
	selRectFillColor		= hexcolor("#00aeef"),
	unselRectFillColor	= hexcolor("#00703c"),
	strokeWidth         	= 1,
   strokeColor         	= {0.5,0.5,0.5,0.5},
   touchOffset         	= {1,1},
	emboss              	= false,	
}
mgr:addButtonPreset( "default", default_params )

local params = 
{ 
	labelColor				= {1,1,1,1},
	labelSize				= 16,
	labelFont				= gameFont,
	labelOffset         	= {0,1},
	selRectFillColor		= hexcolor("#00aeef"),
	unselRectFillColor	= hexcolor("#00703c"),
	strokeWidth         	= 0,
	strokeColor         	= {0.5,0.5,0.5,0.5},    
	emboss              	= false,	
}
mgr:addButtonPreset( "menu", params )


local default_params = 
{ 
	labelColor				= {1,1,1,1},
	labelSize				= 16,
	labelFont				= gameFont,
	labelOffset        	= {0,1},
	selRectFillColor		= hexcolor("#00aeef"),
	unselRectFillColor	= hexcolor("#00703c"),
	strokeWidth         	= 1,
    strokeColor         = {0.5,0.5,0.5,0.5},
    touchOffset         = {1,1},    
	emboss              	= false,	
}
mgr:addButtonPreset( "cancel", default_params )

