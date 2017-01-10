
local layers = gamelayers.get()

local popUpY = centerY - 100


-- =============================================================
-- Localizations
-- =============================================================
-- Lua
local mAbs = math.abs;local mPow = math.pow;local mRand = math.random
local getInfo = system.getInfo; local getTimer = system.getTimer
local strMatch = string.match; local strFormat = string.format
local strGSub = string.gsub; local strSub = string.sub

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
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
--
-- Specialized SSK Features
local actions = ssk.actions


-- ==
--    doPopup() - EFM
-- ==
doPopup = function( text, room )
	local popup = display.newGroup()
	layers.popup:insert( popup )

	local back = newRect( popup, 0, 0, { w = w-5, h = 140 } )
	back.x = centerX
	back.y = popUpY
	back:setFillColor(0,0,0)
	back:setStrokeColor(1,1,0)
	back.strokeWidth = 1

	local text = display.newText( popup, text, 0, 0, w-40, 90, gameFont, 14 )
	text.x = back.x
	text.y = back.y - 20

	local function onOK( event )
		display.remove( popup )		
		return true
	end

	easyIFC:presetPush( popup, "default", back.x, back.y + 70 - 25, 50, 25, "OK", onOK )

end

-- ==
--    doYNPopup() - EFM
-- ==
doYNPopup = function( text, room, yesCB, noCB )
	local popup = display.newGroup()
	layers.popup:insert( popup )

	local back = newRect( popup, 0, 0, { w = w-5, h = 140 } )
	back.x = centerX
	back.y = popUpY
	back:setFillColor(0,0,0)
	back:setStrokeColor(1,1,0)
	back.strokeWidth = 1

	local text = display.newText( popup, text, 0, 0, w-40, 90, gameFont, 14 )
	text.x = back.x
	text.y = back.y - 20

	local function onYes( event )
		display.remove( popup )		
		rooms.showRoom( room )
		return true
	end

	local function onNo( event )
		display.remove( popup )
		return true
	end

	easyIFC:presetPush( popup, "default", back.x - 55 , back.y + 70 - 25, 50, 25, "Yes", onYes )
	easyIFC:presetPush( popup, "default", back.x + 55 , back.y + 70 - 25, 50, 25, "No", onNo )

end

-- ==
--    doTakeObjectPopup() - EFM
-- ==
doTakeObjectPopup = function( text, room, object, target  )
	local popup = display.newGroup()
	layers.popup:insert( popup )

	local back = newRect( popup, 0, 0, { w = w-5, h = 140 } )
	back.x = centerX
	back.y = popUpY
	back:setFillColor(0,0,0)
	back:setStrokeColor(1,1,0)
	back.strokeWidth = 1

	object = string.gsub( object, "_", " ")

	text = string.gsub( text, "_", " ")
	text = string.gsub( text, "<br>", "\n")

	text = text .. "  \n\nTake the " .. object .. "?"

	local text = display.newText( popup, text, 0, 0, w-40, 90, gameFont, 14 )
	text.x = back.x
	text.y = back.y - 20

	local function onYes( event )		
		rooms.takeObject( target, room )
		display.remove( popup )		
		rooms.showRoom( room )
		return true
	end

	local function onNo( event )		
		display.remove( popup )		
		return true
	end

	easyIFC:presetPush( popup, "default", back.x - 55 , back.y + 70 - 25, 50, 25, "Yes", onYes )
	easyIFC:presetPush( popup, "default", back.x + 55 , back.y + 70 - 25, 50, 25, "No", onNo )

end


local public = {}
public.doPopup 				= doPopup
public.doYNPopup 			= doYNPopup
public.doTakeObjectPopup 	= doTakeObjectPopup
return public
