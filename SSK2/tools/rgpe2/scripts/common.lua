-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
local common = {}

common.helpURL = "https://roaminggamer.github.io/RGDocs/pages/RGPE2/"

common.isDirty = false

common.handleSize = 30

common.debug_showEmitterIDs = false

common.doubleClickTime = 333

common.fieldButtonSelStrokeColor 			= hexcolor("#4161fb")
common.fieldButtonColor 						= hexcolor("#444444")
common.fieldButtonFont 							= _G.normalFont 
common.fieldButtonFontSize 					= 14
common.fieldButtonFontColor 					= _W_
common.fieldButtonFontSelColor 				= _K_


common.fieldButtonTextFieldFont 				= _G.normalFont 
common.fieldButtonTextFieldFontSize 		= 14
common.fieldButtonTextFieldFontColor 		= _K_
common.fieldButtonSelTextFieldFontColor 	= hexcolor("#4161fb")

common.selectedChipColor 						= hexcolor("#4161fb")

common.overlayFill 								= hexcolor("#167efc")

common.rightPaneHeaderFont 					= _G.boldFont 
common.rightPaneHeaderFontSize 				= 20
common.rightPaneHeaderFontColor 				= _W_

common.backgroundColor  = hexcolor("#515151")
common.backColor   		= hexcolor("#313131")
common.barColor        	= hexcolor("#111111")
common.barColor        	= hexcolor("#313131")
common.barStroke   		= hexcolor("#515151")

return common