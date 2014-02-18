-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Buttons Presets
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
--
-- DO NOT MODIFY THIS FILE.  MODIFY "data/buttons.lua" instead.
--
-- =============================================================
--
-- labelsInit.lua - Create Label Presets
--
local mgr = ssk.buttons

local imagePath = "data/rg_basicButtons/"

local gameFont = gameFont or native.systemFont

-- ============================
-- ========= OPAQUE BLUE 
-- ============================
local params = 
{ 
	textColor			= { 0, 0, 0, 255 },
	fontSize			= 21,
	textFont			= gameFont,
	unselRectFillColor	= {0,0,255,255},
	selRectFillColor	= {0,0,200,255},
	unselRectEn			= true,
	selRectEn			= true,
	strokeWidth			= 2,
    strokeColor			= {1,1,1,128},
	textOffset			= {0,1},
	emboss				= true,
}
mgr:addPreset( "blue", params )

-- ============================
-- ========= OPAQUE RED 
-- ============================
params.unselRectFillColor	= {255,0,0,255}
params.selRectFillColor		= {200,0,0,255}

mgr:addPreset( "red", params )

-- ============================
-- ================ BLUE GRADIENT
-- ============================
local params = 
{ 
	textColor          = { 0, 0, 0, 255 },
	fontSize           = 18,
	textFont           = gameFont,
	unselRectGradient  = graphics.newGradient ( { 170, 170, 255, 255  }, { 64, 64, 255, 255 }, "down" ),
	selRectGradient    = graphics.newGradient ( { 200, 200, 220, 255  }, { 94, 94, 220, 255 }, "down" ),
	strokeWidth        = 1,
    strokeColor        = {1,1,1,128},
	textOffset         = {0,1},
	emboss             = true,
}

mgr:addPreset( "blueGradient", params )

-- ============================
-- =============== GREEN GRADIENT
-- ============================
params.unselRectGradient  = graphics.newGradient ( { 200, 220, 200, 255  }, { 32, 220,32, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 220, 255, 220, 255  }, { 0, 255, 0, 255 }, "down" )
mgr:addPreset( "greenGradient", params )

-- ============================
-- ========== BLUE/GREEN GRADIENT
-- ============================
params.unselRectGradient  = graphics.newGradient ( { 170, 170, 255, 255  }, { 64, 64, 255, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 220, 255, 220, 255  }, { 0, 255, 0, 255 }, "down" )
mgr:addPreset( "blueGreenGradient", params )

-- ============================
-- ================= RED GRADIENT
-- ============================
params.unselRectGradient  = graphics.newGradient ( { 255, 128 , 128, 255  }, { 255, 32, 32, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 255, 64, 64, 255  }, { 255, 32, 32, 255 }, "down" )

params.unselRectGradient  = graphics.newGradient ( { 255, 128, 128, 255  }, { 220, 32, 32, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 255, 170, 170, 255  }, { 255, 0, 0, 255 }, "down" )

mgr:addPreset( "redGradient", params )

-- ============================
-- ============== ORANGE GRADIENT
-- ============================
params.unselRectGradient  = graphics.newGradient ( { 170, 170, 170, 255  }, { 64, 64, 64, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 200, 200, 200, 255  }, { 94, 94, 94, 255 }, "down" )
params.buttonOverlayRectColor = {0xff, 0x99, 0x00, 180}
mgr:addPreset( "orangeGradient", params )

-- ============================
-- ============== YELLOW GRADIENT
-- ============================
params.unselRectGradient  = graphics.newGradient ( { 170, 170, 170, 255  }, { 94, 94, 94, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 200, 200, 200, 255  }, { 128, 128, 128, 255 }, "down" )
params.buttonOverlayRectColor = { 0xff, 0xff, 0x00, 200}
mgr:addPreset( "yellowGradient", params )

-- ============================
--================ WHITE GRADIENT
-- ============================
params.unselRectGradient  = graphics.newGradient ( { 230, 230, 230, 255  }, { 160, 160, 160, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 255, 255, 255, 255  }, { 180, 180, 180, 255 }, "down" )
params.buttonOverlayRectColor = nil
mgr:addPreset( "whiteGradient", params )

-- ============================
-- ================ HOME BUTTON
-- ============================
params.buttonOverlayRectColor = nil
params.unselImgSrc = imagePath .. "misc/home.png"
params.selImgSrc   = imagePath .. "misc/homeOver.png"
params.unselRectEn = false
params.selRectEn   = false
params.strokeWidth = 0
mgr:addPreset( "homeButton", params )


-- ============================
-- ================ UP BUTTON
-- ============================
params.buttonOverlayRectColor = nil
params.unselImgSrc = imagePath .. "arrows/buttonUp.png"
params.selImgSrc   = imagePath .. "arrows/buttonUpOver.png"
params.unselRectEn = false
params.selRectEn   = false
params.strokeWidth = 0
mgr:addPreset( "upButton", params )
-- ============================
-- ================ DOWN BUTTON
-- ============================
params.unselImgSrc = imagePath .. "arrows/buttonDown.png"
params.selImgSrc   = imagePath .. "arrows/buttonDownOver.png"
mgr:addPreset( "downButton", params )
-- ============================
-- ================ RIGHT BUTTON
-- ============================
params.unselImgSrc = imagePath .. "arrows/buttonRight.png"
params.selImgSrc   = imagePath .. "arrows/buttonRightOver.png"
mgr:addPreset( "rightButton", params )
-- ============================
-- ================ LEFT BUTTON
-- ============================
params.unselImgSrc = imagePath .. "arrows/buttonLeft.png"
params.selImgSrc   = imagePath .. "arrows/buttonLeftOver.png"
mgr:addPreset( "leftButton", params )
-- ============================
-- ================ 'A' BUTTON
-- ============================
params.unselImgSrc = imagePath .. "gel/buttonA.png"
params.selImgSrc   = imagePath .. "gel/buttonAOver.png"
mgr:addPreset( "A_Button", params )
-- ============================
-- ================ 'B' BUTTON
-- ============================
params.unselImgSrc = imagePath .. "gel/buttonB.png"
params.selImgSrc   = imagePath .. "gel/buttonBOver.png"
mgr:addPreset( "B_Button", params )
-- ============================
-- ================ 'C' BUTTON
-- ============================
params.unselImgSrc = imagePath .. "gel/buttonC.png"
params.selImgSrc   = imagePath .. "gel/buttonCOver.png"
mgr:addPreset( "C_Button", params )
-- ============================
-- ================ 'D' BUTTON
-- ============================
params.unselImgSrc = imagePath .. "gel/buttonD.png"
params.selImgSrc   = imagePath .. "gel/buttonDOver.png"
mgr:addPreset( "D_Button", params )
-- ============================
-- ================ 'E' BUTTON
-- ============================
params.unselImgSrc = imagePath .. "gel/buttonE.png"
params.selImgSrc   = imagePath .. "gel/buttonEOver.png"
mgr:addPreset( "E_Button", params )
-- ============================
-- ================ 'F' BUTTON
-- ============================
params.unselImgSrc = imagePath .. "gel/buttonF.png"
params.selImgSrc   = imagePath .. "gel/buttonFOver.png"
mgr:addPreset( "F_Button", params )

-- ============================
-- ================== MP BUTTON
-- ============================
local params = 
{ 
	textColor			= { 0, 0, 0, 255 },
	unselRectEn			= true,
	selRectEn			= true,

	unselRectFillColor	= {255,255,255,255},
	selRectFillColor	= {255,255,255,255},
	
	unselImgSrc			= imagePath .. "lostgarden/spOverlay.png",
	selImgSrc			= imagePath .. "lostgarden/mpOverlay.png",

	strokeWidth			= 2,
    strokeColor			= {0,0,0,128},
}
mgr:addPreset( "mpButton", params )

-- ============================
-- ============= OPTIONS BUTTON
-- ============================
params.buttonOverlayRectColor = nil
params.selRectFillColor	= {200,200,200,255}
params.unselImgSrc = imagePath .. "misc/gear.png"
params.selImgSrc   = imagePath .. "misc/gear.png"
params.unselRectEn = true
params.selRectEn   = true
mgr:addPreset( "optionsButton", params )

-- ============================
-- ============= BANANA BUTTON
-- ============================
params.buttonOverlayRectColor = nil
params.selRectFillColor	= {200,200,200,255}
params.touchMask = imagePath .. "masked/bananaMask.png"
params.touchMaskW = 256
params.touchMaskH = 256
params.unselImgSrc = imagePath .. "masked/bananaN.png"
params.selImgSrc   = imagePath .. "masked/bananaH.png"
params.unselRectEn = false
params.selRectEn   = false
mgr:addPreset( "bananaButton", params )

-- ============================
-- ============= APPLE BUTTON
-- ============================
params.buttonOverlayRectColor = nil
params.selRectFillColor	= {200,200,200,255}
params.touchMask = imagePath .. "masked/appleMask.png"
params.touchMaskW = 256
params.touchMaskH = 280
params.unselImgSrc = imagePath .. "masked/appleN.png"
params.selImgSrc   = imagePath .. "masked/appleH.png"
params.unselRectEn = false
params.selRectEn   = false
mgr:addPreset( "appleButton", params )

-- ============================
-- ============= FISH BUTTON
-- ============================
params.buttonOverlayRectColor = nil
params.selRectFillColor	= {200,200,200,255}
params.touchMask = imagePath .. "masked/fishMask.png"
params.touchMaskW = 300
params.touchMaskH = 180
params.unselImgSrc = imagePath .. "masked/fishN.png"
params.selImgSrc   = imagePath .. "masked/fishH.png"
params.unselRectEn = false
params.selRectEn   = false
mgr:addPreset( "fishButton", params )
