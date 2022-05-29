local common = {}

common.curLevel = 2
common.currentDifficulty = 1

-- Forward Declarations

-- Useful Localizations
-- SSK
--
local newCircle 		= ssk.display.newCircle
local newRect 			= ssk.display.newRect
local newImageRect 		= ssk.display.newImageRect
local easyIFC   		= ssk.easyIFC
local easyFlyIn			= easyIFC.easyFlyIn
local isInBounds    	= ssk.easyIFC.isInBounds
local persist 			= ssk.persist
local isValid 			= display.isValid

local vector2Angle		= ssk.math2d.vector2Angle
local angle2Vector		= ssk.math2d.angle2Vector
local scaleVec			= ssk.math2d.scale

-- Corona & Lua
--
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs


function common.createHelpButton()
	easyIFC:presetPush( common.layers.overlay, "fastpack_check", right - 35, top + 35, 60, 60, "?", onHelp,
	{ font = gameFont, labelSize = 32, labelOffset = {1,5}, labelColor = _K_, selLabelColor = _K_,
	  unselImgFillColor = _W_, selImgFillColor  =  hexcolor("#dbf5cf") } )
end


function common.createSharingButtons()
	easyIFC:presetPush( common.layers.overlay, "fastpack_facebook", left + 150, bottom - 150, 60, 60, "", onFacebook,
	{  unselImgFillColor = _W_ } )
	easyIFC:presetPush( common.layers.overlay, "fastpack_twitter", right - 150, bottom - 150, 60, 60, "", onTwiter,
	{  unselImgFillColor = _W_ } )
end


function common.doCountDown( cb )
	local tmp = easyIFC:quickLabel( common.layers.overlay, "3", centerX, centerY, gameFont, 80  )
	tmp.value = 4

	local function onComplete( self )
		tmp.value = tmp.value - 1
		if( tmp.value > 0 ) then
			tmp.alpha = 1
			tmp.text = tmp.value
		elseif( tmp.value == 0 ) then
			tmp.alpha = 1
			tmp.text = "Go!"
		else
			display.remove( self )
			if( cb ) then cb() end
			return 
		end
		if( tmp.value == 3 ) then
			transition.to( tmp, { alpha = 0, delay = 250, time = 1000, onComplete = onComplete } )
		elseif( tmp.value == 0 ) then
			transition.to( tmp, { alpha = 0, delay = 750, time = 250, onComplete = onComplete } )
		else
			transition.to( tmp, { alpha = 0, delay = 0, time = 1000, onComplete = onComplete } )
		end
	end
	onComplete()	
end

function common.createLevelCounter()
	local tmp = easyIFC:quickLabel( common.layers.overlay, "Level: " .. common.curLevel, left + 10 , top + 10, gameFont, 40  )	
	tmp.anchorX = 0
	tmp.anchorY = 0
	return tmp
end

function common.doBallCount( choices, answer )
	local flyDelay = 500
	local flyTime = 1500

	local label
	local buttonsGroup = display.newGroup()		
	common.layers.content:insert( buttonsGroup )

	choices = table.shuffle(choices)

	local function onCorrect()
		local msg = easyIFC:quickLabel( label.parent, "CORRECT!", centerX, centerY, gameFont, 40, _G_ )
		msg.xScale = 0.001
		msg.yScale = 0.001
		transition.to( msg, {xScale = 2, yScale = 2, delay = 0, time = flyTime/2, transition = easing.inOutBack } )		
		transition.to( msg, {alpha = 0, delay = flyTime, time = flyTime/2, transition = easing.inOutBack } )		


		local function onComplete()
			display.remove( msg )
			display.remove( label )
			display.remove( buttonsGroup )			
			post("onCorrect")
		end

		transition.to( label, { x = label.x + fullw, delay = flyTime/2, time = flyTime, 
			transition = easing.inOutBack } )		
		transition.to( buttonsGroup, { x = buttonsGroup.x - fullw, delay = flyTime/2, time = flyTime, 
			transition = easing.inOutBack, onComplete = onComplete } )
	end

	local function onIncorrect()

		local msg = easyIFC:quickLabel( label.parent, "WRONG!", centerX, centerY, gameFont, 40, _R_ )
		msg.xScale = 0.001
		msg.yScale = 0.001
		transition.to( msg, {xScale = 2, yScale = 2, delay = 0, time = flyTime/2, transition = easing.inOutBack } )		
		transition.to( msg, {alpha = 0, delay = flyTime, time = flyTime/2, transition = easing.inOutBack } )		

		local function onComplete()
			display.remove( label )
			display.remove( buttonsGroup )			
			post("onIncorrect")
		end
		transition.to( label, { x = label.x + fullw, delay = flyDelay, time = flyTime, 
			transition = easing.inOutBack } )		
		transition.to( buttonsGroup, { x = buttonsGroup.x - fullw, delay = flyDelay, time = flyTime, 
			transition = easing.inOutBack, onComplete = onComplete } )
	end

	label = easyIFC:quickLabel( common.layers.content, "What Was Your Count?", centerX, centerY - 150, gameFont, 40  )

	local bw 	= 120
	local bh 	= bw
	local curX 	= centerX - (#choices * bw)/2 	+bw/2	
	local curY 	= bottom - 200 -- label.y + 200

	for i = 1, #choices do		
		local tmp = easyIFC:presetPush( buttonsGroup, "fastpack_check", curX, curY, bw - 10, bh - 10, choices[i], 
			( choices[i] == answer ) and onCorrect or onIncorrect,
			{ font = gameFont, labelSize = 32, labelOffset = {1,5}, labelColor = _K_, selLabelColor = _K_,
	  		unselImgFillColor = _W_, selImgFillColor  =  hexcolor("#dbf5cf") } )
		curX = curX + bw
	end

	easyFlyIn( label, { delay = flyDelay, sox = -fullw, time = flyTime } )
	easyFlyIn( buttonsGroup, { delay = flyDelay, sox = fullw, time = flyTime } )
end


return common