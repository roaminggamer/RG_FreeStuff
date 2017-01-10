
local layers = gamelayers.get()

local popUpY = centerY - 100


-- SSK 
local isInBounds		= ssk.easyIFC.isInBounds
local newCircle 		= ssk.display.circle
local newRect 			= ssk.display.rect
local newImageRect 		= ssk.display.imageRect
local easyIFC			= ssk.easyIFC
local ternary			= _G.ternary
local quickLayers  		= ssk.display.quickLayers

local angle2Vector 		= ssk.math2d.angle2Vector
local vector2Angle 		= ssk.math2d.vector2Angle
local scaleVec 			= ssk.math2d.scale
local addVec 			= ssk.math2d.add
local subVec 			= ssk.math2d.sub
local getNormals 		= ssk.math2d.normals

-- Lua and Corona
local mAbs 				= math.abs
local mPow 				= math.pow
local mRand 			= math.random
local getInfo			= system.getInfo
local getTimer 			= system.getTimer
local strMatch 			= string.match
local strFormat 		= string.format


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
