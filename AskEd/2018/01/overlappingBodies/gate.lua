-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- 
-- =============================================================
local common 		= require "scripts.common"

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua Functions
local getTimer          = system.getTimer
local mRand					= math.random
local mAbs					= math.abs
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert

local files = ssk.files

-- =============================================================
-- Locals
-- =============================================================
local gate = {}

function gate.run(onSuccess,onFailure)
	local gateGroup = display.newGroup()
	gateGroup.x = centerX
	gateGroup.y = centerY
	gateGroup.enterFrame = gateGroup.toFront
	listen("enterFrame", gateGroup)
	local blocker = newImageRect( gateGroup, 0, 0, "images/fillT.png", 
		{ size = 50000, fill = _P_, alpha = 0.5 } )
	blocker.touch = function() return true end
	blocker:addEventListener("touch")

	local function onExit()
		ignore("enterFrame", gateGroup)
		display.remove(gateGroup)
	end

	-- Retry Group
	local retryGroup = display.newGroup()
	gateGroup:insert(retryGroup)

	-- Question Tray
	local qTrayGroup = display.newGroup()
	gateGroup:insert(qTrayGroup)
	local qTray = newImageRect( qTrayGroup, 0, 0, "images/gate/qTray.png", 
		{ w = 1113, h = 1146 } )
	local exitB = easyIFC:presetPush( qTrayGroup, "gateExit", -qTray.contentWidth/2 + 100, -qTray.contentHeight/2 + 100, 48, 52, "", onExit)	

	-- Numbers
	local curX = { -308, -100, 105, 310 }
	local curY = -270
	local numbers = {}
	for i = 1, 4 do
		local number = display.newText( qTrayGroup, 0, curX[i], curY, common.font1, 100 )
		number:setFillColor(0)
		numbers[i]=number
		number.isVisible = false
	end

	-- Number names
	local numberNames = {}
	numberNames[0] = "ZERO"
	numberNames[1] = "ONE"
	numberNames[2] = "TWO"
	numberNames[3] = "THREE"
	numberNames[4] = "FOUR"
	numberNames[5] = "FIVE"
	numberNames[6] = "SIX"
	numberNames[7] = "SEVEN"
	numberNames[8] = "EIGHT"
	numberNames[9] = "NINE"

	-- Random numbers
	local curNumbers = {}
	for i = 1, 4 do
		curNumbers[i] = mRand(0,9)
	end

	-- Message 
	local msg
	for i = 1, 4 do
		if( msg ) then 
			msg = msg .. ", " 
		else 
			msg = ""
		end
		msg = msg .. numberNames[curNumbers[i]]		
	end
	local tmp = display.newText( qTrayGroup, msg, 0, 30, common.font2, 55 )
	tmp:setFillColor(0)

	-- Buttons
	local bSize = 135
	local bGap = 30
	local startX = -(6 * (bSize + bGap) - bGap)/2 + bSize/2
	local startY = 220
	local curX = startX
	local curY = startY

	local curNum = 1

	local function onButton( event )
		local target = event.target
		local num = target.num
		if( num == 99 ) then
			curNum = curNum - 1
			if( curNum < 1 ) then curNum = 1 end
			numbers[curNum].text = 0
			numbers[curNum].isVisible = false			

		elseif( curNum <= 4 ) then
			numbers[curNum].text = num
			numbers[curNum].isVisible = true
			curNum = curNum + 1
			if( curNum > 4 ) then
				local matches = true
				for i = 1, 4 do
					local numA = tonumber(numbers[i].text)
					local numB = tonumber(curNumbers[i])
					print( i, numA, numB, matches )
					matches = matches and (numA == numB)
				end
				if( matches ) then 
					onSuccess() 
					onExit()
				else 
					qTrayGroup.isVisible = false
					retryGroup.isVisible = true
				end				
			end
		end
	end

	for i = 1, 6 do
		local tmp = easyIFC:presetPush( qTrayGroup, "gateB" .. i, curX, curY, bSize, bSize, "", onButton)	
		tmp.num = i
		curX = curX + bSize + bGap
	end
	curX = startX
	curY = curY  + bSize + bGap

	for i = 1, 4 do
		if( i < 4 ) then
			local tmp = easyIFC:presetPush( qTrayGroup, "gateB" .. i+6, curX, curY, bSize, bSize, "", onButton)	
			tmp.num = 6 + i
		else
			local tmp = easyIFC:presetPush( qTrayGroup, "gateB0", curX, curY, bSize, bSize, "", onButton)	
			tmp.num = 0
		end
		curX = curX + bSize + bGap
	end
	curX = curX + bSize/2 + bGap/2
	local tmp = easyIFC:presetPush( qTrayGroup, "gateBack", curX, curY, bSize, bSize, "", onButton)	
	tmp.num = 99

	-- Retry Tray	
	--retryGroup:toFront()
	local tryAgain = newImageRect( retryGroup, 0, 0, "images/gate/tryAgain.png", 
		{ w = 1113, h = 1146 } )
	local exitB = easyIFC:presetPush( retryGroup, "gateExit", -qTray.contentWidth/2 + 100, -qTray.contentHeight/2 + 100, 48, 52, "", onExit)	

	local function onRetry()
		nextFrame(
			function()
				retryGroup.isVisible = false
				qTrayGroup.isVisible = true
			end )
	end
	easyIFC:presetPush( retryGroup, "gateTryAgain", 0, 450, 438, 96, "", onRetry)		
	retryGroup.isVisible = false


	--
	local scale = (fullw-20)/1113
	gateGroup:scale(scale,scale)
end

return gate