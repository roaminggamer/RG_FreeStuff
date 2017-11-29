-- =============================================================
-- Custom Dialog (Tray)
-- =============================================================
local mAbs = math.abs
local pairs = pairs
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers

local custom = {}

-- ==
-- create( group, x, y, params ) - Creates a new tray.
-- ==
function custom.create( group, x, y, params )
	group = group or display.currentStage
	x = x or centerX
	y = y or centerY
	params = params or {}
	local width 					= params.width or fullw/2
	local height 					= params.height or fullh/2
	local fill						= params.fill or _W_
	local blockerFill   			= params.blockerFill or _K_
	local blockerAlpha  			= params.blockerAlpha or 0.5
	local blockerAlphaTime  	= params.blockerAlphaTime or 0
	local closeOnTouchBlocker 	= fnn(params.closeOnTouchBlocker, false)

	local softShadow 				= fnn(params.softShadow, false )
	local softShadowFill   		= params.softShadowFill or _K_
	local softShadowOX 			= params.softShadowOX or 2
	local softShadowOY 			= params.softShadowOY or 2
	local softShadowBlur			= params.softShadowBlur or 4
	local softShadowSigma		= params.softShadowSigma or 140
	local softShadowAlpha 		= params.softShadowAlpha or 0.5
	local onClose 					= params.onClose
	local blockerAction			= params.blockerAction

	local trayImage				= params.trayImage
	local shadowImage				= params.shadowImage

	local frame = display.newGroup()
	group:insert(frame)

	local dialog = display.newGroup()
	frame:insert(dialog)
	dialog.frame = frame
	dialog.x = x
	dialog.y = y

	function frame.close( self )
		if( blockerAlphaTime > 0 ) then
			frame.blocker.closing = true
			transition.cancel( self )
			transition.to( frame.blocker, 
				{ alpha = 0, time = blockerAlphaTime, 
				  onComplete = function() display.remove(self) end } )
		else
			display.remove(self)
		end
	end

	--local tmp = newRect( frame, 0, 0, { w = width, h = height } )
	local function blockerTouch( self, event )
		if( frame.blocker.closing ) then return true end
		if( event.phase == "ended" ) then
			if( blockerAction ) then
				blockerAction( dialog )
			end
			if( closeOnTouchBlocker ) then
				
				nextFrame( 
					function() 
						if( onClose ) then
							onClose( dialog, function() frame:close() end )
						else
							frame:close()
						end				 
					end )
			end
		end
		return true
	end
	frame.blocker = newImageRect( frame, centerX, centerY, "ssk2/dialogs/images/fillW.png",
							{ w = fullw, h = fullh,touch = blockerTouch,
							  fill = blockerFill, alpha = blockerAlpha } )
	if( blockerAlphaTime > 0 ) then
		frame.blocker.alpha = 0
		transition.to( frame.blocker, { alpha = blockerAlpha, time = blockerAlphaTime } )
	end

	if( softShadow ) then
		local shadow = display.newGroup()
		frame.shadow = shadow
		frame:insert( shadow )
		local snap = display.newSnapshot( shadow, fullw, fullh )
		snap.x = centerX
		snap.y = centerY

		shadow._img = newImageRect( snap.group, 0, 0, 
								shadowImage,
								{ w = width, h = height, fill = softShadowFill } )

		snap:invalidate()
		snap.alpha = softShadowAlpha
		snap.fill.effect = "filter.blurGaussian"
		snap.fill.effect.horizontal.blurSize = softShadowBlur
		snap.fill.effect.horizontal.sigma = softShadowSigma
		snap.fill.effect.vertical.blurSize = softShadowBlur
		snap.fill.effect.vertical.sigma = softShadowSigma
		--shadow.x = shadow.x + softShadowOX
		--shadow.y = shadow.y + softShadowOY
		dialog:insert( snap )
		snap.x = softShadowOX
		snap.y = softShadowOY
	end


	dialog._img = newImageRect( dialog, 0, 0, 
							trayImage,
							{ w = width, h = height, fill = fill } )


	dialog:toFront()

	return dialog
end

----------------------------------------------------------------------
--	Attach To SSK and return
----------------------------------------------------------------------
if( not _G.ssk ) then	
	_G.ssk = { }
end
if( not _G.ssk.dialogs ) then
	_G.ssk.dialogs = {}
end
_G.ssk.dialogs.custom = custom

return custom