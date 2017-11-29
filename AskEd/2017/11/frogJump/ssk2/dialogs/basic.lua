-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Basic Dialog (Tray)
-- =============================================================
local mAbs = math.abs
local pairs = pairs
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers

local basic = {}

-- ==
-- create( group, x, y, params ) - Creates a new tray.
-- ==
function basic.create( group, x, y, params )
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

	local style 					= params.style or 1

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

		if( softShadowOY < 0 or mAbs(softShadowOX) > 10 ) then
			shadow._top = newImageRect( snap.group, -width/2 + 10, -height/2, 
									"ssk2/dialogs/images/top" .. style .. ".png",
									{ w = width - 20, h = 24, anchorX = 0, anchorY = 0, fill = softShadowFill } )
		end

		if( softShadowOY > 0 or mAbs(softShadowOX) > 10 ) then
			shadow._bot = newImageRect( snap.group, -width/2 + 10, height/2, 
									"ssk2/dialogs/images/top" .. style .. ".png",
									{ w = width - 20, h = 24, yScale = -1, anchorX = 0, anchorY = 0, fill = softShadowFill } )
		end

		if( softShadowOX < 0 or mAbs(softShadowOY) > 24) then
			shadow._left = newImageRect( snap.group, -width/2, 0, 
									"ssk2/dialogs/images/left" .. style .. ".png",
									{ w = 10, h = height - 48, anchorX = 0, fill = softShadowFill } )
		end
	
		if( softShadowOX > 0 or mAbs(softShadowOY) > 24 ) then	
			shadow._right = newImageRect( snap.group, width/2, 0, 
									"ssk2/dialogs/images/left" .. style .. ".png",
									{ w = 10, h = height - 48, xScale = -1, anchorX = 0, fill = softShadowFill } )
		end

		if( mAbs(softShadowOX) > 10 or mAbs(softShadowOY) > 24 ) then
			shadow._center = newImageRect( snap.group, 0, 0,
									"ssk2/dialogs/images/center" .. style .. ".png",
									{ w = width - 20, h = height - 48, fill = softShadowFill } )
		end

		if( softShadowOY < 0 or softShadowOX < 0 ) then
			shadow._ul = newImageRect( snap.group, -width/2, -height/2, 
									"ssk2/dialogs/images/ul" .. style .. ".png",
									{ w = 10, h = 24, anchorX = 0, anchorY = 0, fill = softShadowFill } )
		end

		if( softShadowOY < 0 or softShadowOX > 0 ) then
			shadow._ur = newImageRect( snap.group, width/2, -height/2, 
									"ssk2/dialogs/images/ul" .. style .. ".png",
									{ w = 10, h = 24, xScale = -1, anchorX = 0, anchorY = 0, fill = softShadowFill } )
		end

		if( softShadowOY > 0 or softShadowOX < 0 ) then
			shadow._ll = newImageRect( snap.group, -width/2, height/2, 
									"ssk2/dialogs/images/ul" .. style .. ".png",									
									{ w = 10, h = 24, yScale = -1, anchorX = 0, anchorY = 0, fill = softShadowFill } )
		end

		if( softShadowOY > 0 or softShadowOX > 0 ) then
			shadow._lr = newImageRect( snap.group, width/2, height/2, 
									"ssk2/dialogs/images/ul" .. style .. ".png",
									{ w = 10, h = 24, xScale = -1, yScale = -1, anchorX = 0, anchorY = 0, fill = softShadowFill } )
		end

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

	dialog._top = newImageRect( dialog, -width/2 + 10, -height/2, 
							"ssk2/dialogs/images/top" .. style .. ".png",
							{ w = width - 20, h = 24, anchorX = 0, anchorY = 0, fill = fill } )

	dialog._bot = newImageRect( dialog, -width/2 + 10, height/2, 
							"ssk2/dialogs/images/top" .. style .. ".png",
							{ w = width - 20, h = 24, yScale = -1, anchorX = 0, anchorY = 0, fill = fill } )

	dialog._left = newImageRect( dialog, -width/2, 0, 
							"ssk2/dialogs/images/left" .. style .. ".png",
							{ w = 10, h = height - 48, anchorX = 0, fill = fill } )

	dialog._right = newImageRect( dialog, width/2, 0, 
							"ssk2/dialogs/images/left" .. style .. ".png",
							{ w = 10, h = height - 48, xScale = -1, anchorX = 0, fill = fill } )

	dialog._center = newImageRect( dialog, 0, 0,
							"ssk2/dialogs/images/center" .. style .. ".png",
							{ w = width - 20, h = height - 48, fill = fill } )

	dialog._ul = newImageRect( dialog, -width/2, -height/2, 
							"ssk2/dialogs/images/ul" .. style .. ".png",
							{ w = 10, h = 24, anchorX = 0, anchorY = 0, fill = fill } )
	dialog._ur = newImageRect( dialog, width/2, -height/2, 
							"ssk2/dialogs/images/ul" .. style .. ".png",
							{ w = 10, h = 24, xScale = -1, anchorX = 0, anchorY = 0, fill = fill } )

	dialog._ll = newImageRect( dialog, -width/2, height/2, 
							"ssk2/dialogs/images/ul" .. style .. ".png",
							{ w = 10, h = 24, yScale = -1, anchorX = 0, anchorY = 0, fill = fill } )
	dialog._lr = newImageRect( dialog, width/2, height/2, 
							"ssk2/dialogs/images/ul" .. style .. ".png",
							{ w = 10, h = 24, xScale = -1, yScale = -1, anchorX = 0, anchorY = 0, fill = fill } )

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
_G.ssk.dialogs.basic = basic

return basic