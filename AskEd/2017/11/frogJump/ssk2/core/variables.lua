-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Global Variables
-- =============================================================
-- =============================================================
-- Measurement and Spacing
-- =============================================================
local mFloor = math.floor
local function round(val, n)
   if (n) then
      return mFloor( (val * 10^n) + 0.5) / (10^n)
   else
		return mFloor(val+0.5)
	end
end

-- =============================================================
-- Display
-- =============================================================
function _G.ssk.core.calculateGlobals()
	_G.ssk.core.w             	= display.contentWidth
	_G.ssk.core.h             	= display.contentHeight
	_G.ssk.core.centerX       	= display.contentCenterX
	_G.ssk.core.centerY       	= display.contentCenterY
	_G.ssk.core.fullw         	= display.actualContentWidth 
	_G.ssk.core.fullh         	= display.actualContentHeight
	_G.ssk.core.unusedWidth   	= _G.ssk.core.fullw - _G.ssk.core.w
	_G.ssk.core.unusedHeight  	= _G.ssk.core.fullh - _G.ssk.core.h
	_G.ssk.core.left	        	= 0 - _G.ssk.core.unusedWidth/2
	_G.ssk.core.top           	= 0 - _G.ssk.core.unusedHeight/2
	_G.ssk.core.right         	= _G.ssk.core.w + _G.ssk.core.unusedWidth/2
	_G.ssk.core.bottom        	= _G.ssk.core.h + _G.ssk.core.unusedHeight/2

	_G.ssk.core.w 					= round(_G.ssk.core.w)
	_G.ssk.core.h 					= round(_G.ssk.core.h)
	_G.ssk.core.left          	= round(_G.ssk.core.left)
	_G.ssk.core.top           	= round(_G.ssk.core.top)
	_G.ssk.core.right         	= round(_G.ssk.core.right)
	_G.ssk.core.bottom        	= round(_G.ssk.core.bottom)
	_G.ssk.core.fullw         	= round(_G.ssk.core.fullw)
	_G.ssk.core.fullh         	= round(_G.ssk.core.fullh)

	_G.ssk.core.orientation  	= ( _G.ssk.core.w > _G.ssk.core.h ) and "landscape"  or "portrait"
	_G.ssk.core.isLandscape 	= ( _G.ssk.core.w > _G.ssk.core.h )
	_G.ssk.core.isPortrait 		= ( _G.ssk.core.h > _G.ssk.core.w )

	_G.ssk.core.left 				= (_G.ssk.core.left>=0) and math.abs(_G.ssk.core.left) or _G.ssk.core.left
	_G.ssk.core.top           	= (_G.ssk.core.top>=0) and math.abs(_G.ssk.core.top) or _G.ssk.core.top

	if(ssk.core.export) then ssk.core.export() end
end
_G.ssk.core.calculateGlobals()

