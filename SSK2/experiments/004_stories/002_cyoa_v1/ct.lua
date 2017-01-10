local things = require "things"
local objects = require "objects"


local newImageRect 	= ssk.display.newImageRect
local newRect 			= ssk.display.newRect
local easyIFC			= ssk.easyIFC
local mRand 			= math.random

local getTimer 		= system.getTimer
local sysGetInfo		= system.getInfo
local strMatch 		= string.match
local strFormat 		= string.format


----------------------------------------------------------------------
--	Locals
----------------------------------------------------------------------
local layers 

local startX = 10
local startY = 20

local nextX
local curX = startX
local curY = startY

local xSep = 8
local ySep = 24

local lastStory

local currentRoom


local roomColor 	= { 1, 1, 0 }
local thingColor 	= _BRIGHTORANGE_
local objectColor 	= _PINK_
local scriptColor 	= _CYAN_

----------------------------------------------------------------------
--	Forward Declarations
----------------------------------------------------------------------
local addRoom
local init
local showRoom
local showObjects
local wordIsTarget
local takeObject
local dropObject
local doPopup
local doYNPopup
local doTakeObjectPopup
local addTouch
local processTarget

-- Scripts
local scripts = {}
scripts.window  = { }


local rooms = {}

addRoom = function( name, title, descr, objs )
	if( rooms[name] ~= nil ) then
		error( "Room by the name " .. name .. " already exists!")
		return false
	end

	local theRoom = {}
	rooms[name] = theRoom

	theRoom.title = title
	theRoom.description = descr
	theRoom.objects = objs or {}
end

----------------------------------------------------------------------
--	Function Definitions
----------------------------------------------------------------------

-- ==
--    wordIsTarget() - Is this word a valid target?
-- ==
wordIsTarget = function( curWord )
	return curWord:match( "#" ) 
end

-- ==
--    processTarget() - Process this word into a proper target
-- ==
processTarget = function( curWord )
	local word = curWord
	
	local tmp = word:gsub( "#", " ")
	tmp = string.trim( tmp )
	tmp = tmp:split( " " )
	word = tmp[1]
	
	local target = tmp[2]
	
	print(string.find( target, ".", 1, true ), target:len())

	if(string.find( target, ".", 1, true ) == target:len() ) then
		word = word .. "."
		target = target:sub( 1, target:len()-1)
	end

	if(string.find( target, ",", 1, true ) == target:len() ) then
		word = word .. ","
		target = target:sub( 1, target:len()-1)
	end

	if(string.find( target, ";", 1, true ) == target:len() ) then
		word = word .. ";"
		target = target:sub( 1, target:len()-1)
	end

	word = word:gsub( "_", " " )	

	return word, target
end


-- ==
--    addTouch() - EFM
-- ==
addTouch = function( obj, target, word, room )		

	print("addTouch ==> ", target, word, room, "BO" )
	
	obj._type = "room"
	obj:setFillColor( unpack( roomColor ) )

	if( things.isThing(target) ) then
		obj._type = "thing"
		obj:setFillColor( unpack( thingColor ) )
	end

	if( objects.isObject(target) ) then
		obj._type = "object"
		obj:setFillColor( unpack( objectColor ) )
	end

	if( scripts[target] ) then
		obj._type = "script"
		obj:setFillColor( unpack( scriptColor ) )
	end
		

	obj.touch = function( self, event )
		if( event.phase ~= "ended" ) then return true end
		--table.dump(event)
		if( obj._type == "room" ) then
			print("Start 'room' touch")
			showRoom( target, currentRoom, word )
			print("End 'room' touch")

		elseif( obj._type == "thing" ) then

			print("Start 'thing' touch")
			--table.dump(obj)
			local descr = things.getDescription( obj, target, word, room )
			doPopup( descr, currentRoom )
			print("End 'thing' touch")
			
		elseif( obj._type == "object" ) then
			print("Start 'object' touch")
			--doTakeObjectPopup( objects[target][2], room, objects[target][1], target )
			local cantake, descr = objects.getDescription( obj, target, word, room )

			if( cantake == true ) then

				doTakeObjectPopup( descr .. " : " .. tostring(cantake), 
					               room, 
				    	           objects.getShort( target, room ), 
				               		target )
			else
				doPopup( descr .. " : " .. tostring(cantake), currentRoom )
			end
			print("End 'object' touch")

		end
		return true
	end


	obj:addEventListener( "touch", obj )
end

-- ==
--    showRoom() - EFM
-- ==
showRoom = function( room )

	-- EFM do some 'leave room processing here?'

	display.remove( lastStory )
	lastStory = display.newGroup()

	currentRoom = room

	layers.content:insert( lastStory )
	curX = startX
	curY = startY
	--print(room)
	local text = string.gsub( rooms[room].description, "\n", " " )
	text = string.gsub( text, "  ", " " )
	text = string.gsub( text, "  ", " " )
	local words = text:split( " " )

	local text = rooms[room].description
	text = text:gsub( "_", " " )

	for i = 1, #words do
	--for i = 1, 2 do

		local word = words[i]

		local doTouch = false
		local target 

		if( wordIsTarget( word ) ) then
			doTouch = true

			word,target = processTarget( word )


		end

		local tmp = display.newText( lastStory, word, 0, 0, gameFont, ySep - 2 )	
		tmp.anchorX = 0

		nextX = curX + tmp.contentWidth + xSep
		if(nextX > w) then
			curX = startX
			nextX = curX + tmp.contentWidth + xSep
			curY = curY + ySep
		end

		tmp.x = curX
		curX = nextX
		tmp.y = curY

		if( doTouch ) then
			addTouch( tmp, target, word, room  )
		end
	end

	showObjects( room )
end

-- ==
--    showObjects() - EFM
-- ==
showObjects = function( room )
	curX = startX
	curY = curY + ySep * 2

	local curObjects = rooms[room].objects

	local text = "You also see a "

	if( #curObjects == 0 ) then
		return false
	end

	for i = 1, #curObjects do
		if (i > 1) then
			text  = text .. ", "
		
		elseif( i ~= i and i == #curObjects ) then
			text  = text .. ", and a "
		end

		local name = curObjects[i]

		text = text .. "#" .. objects.getShort( name, room ) .. "#" .. name
	end
	
	text = text .. "."

	text = string.gsub( text, "  ", " " )
	text = string.gsub( text, "  ", " " )
	local words = text:split( " " )

	local text = rooms[room].description
	text = text:gsub( "_", " " )

	for i = 1, #words do
	--for i = 1, 2 do

		local word = words[i]

		local doTouch = false
		local target 

		if( wordIsTarget( word ) ) then
			doTouch = true

			word,target = processTarget( word )


		end

		local tmp = display.newText( lastStory, word, 0, 0, gameFont, ySep - 2 )	
		tmp.anchorX = 0

		nextX = curX + tmp.contentWidth + xSep
		if(nextX > w) then
			curX = startX
			nextX = curX + tmp.contentWidth + xSep
			curY = curY + ySep
		end

		tmp.x = curX
		curX = nextX
		tmp.y = curY

		if( doTouch ) then
			addTouch( tmp, target, word, room  )
		end
	end
end

-- ==
--    takeObject() - EFM
-- ==
takeObject = function( target, room )

	print(target,room)

	local roomObjects = rooms[room].objects
	for i = 1, #roomObjects do
		if(roomObjects[i] == target) then
			roomObjects[i] = nil
			return
		end
	end
end

-- ==
--    dropObject() - EFM
-- ==
dropObject = function( target, room )

	print(target,room)

	local roomObjects = rooms[room].objects
	roomObjects[#roomObjects+1] = target
end


-- ==
--    doPopup() - EFM
-- ==
doPopup = function( text, room )
	local popup = display.newGroup()
	layers.popup:insert( popup )

	local back = newRect( popup, 0, 0, { w = w, h = 140 } )
	back.x = centerX
	back.y = centerY
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

	local back = newRect( popup, 0, 0, { w = w, h = 140 } )
	back.x = centerX
	back.y = centerY
	back:setFillColor(0,0,0)
	back:setStrokeColor(1,1,0)
	back.strokeWidth = 1

	local text = display.newText( popup, text, 0, 0, w-40, 90, gameFont, 14 )
	text.x = back.x
	text.y = back.y - 20

	local function onYes( event )
		display.remove( popup )		
		showRoom( room )
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

	local back = newRect( popup, 0, 0, { w = w, h = 140 } )
	back.x = centerX
	back.y = centerY
	back:setFillColor(0,0,0)
	back:setStrokeColor(1,1,0)
	back.strokeWidth = 1

	text = text .. "  \n\nTake the " .. object .. "?"

	local text = display.newText( popup, text, 0, 0, w-40, 90, gameFont, 14 )
	text.x = back.x
	text.y = back.y - 20

	local function onYes( event )		
		takeObject( target, room )
		display.remove( popup )		
		showRoom( room )
		return true
	end

	local function onNo( event )		
		display.remove( popup )		
		return true
	end

	easyIFC:presetPush( popup, "default", back.x - 55 , back.y + 70 - 25, 50, 25, "Yes", onYes )
	easyIFC:presetPush( popup, "default", back.x + 55 , back.y + 70 - 25, 50, 25, "No", onNo )

end


init = function()
	layers = ssk.display.quickLayers( nil, "underlay", "background", "content", "buttons", "popup", "overlay" )
	local backImage = newImageRect( layers.underlay, centerX, centerY,  "images/interface/protoBack.png", { w = 380, h = 570 } )
end

local public = {}

public.init 		= init
public.add 			= addRoom
public.showRoom 	= showRoom

return public
	

----------------------------------------------------------------------
--	Run the Story
----------------------------------------------------------------------
--display.setDefault( "fillColor", 0, 0, 0 )
--local backImage = newImageRect( layers.underlay, centerX, centerY,  "images/interface/protoBack.png", { w = 380, h = 570 } )
--local backImage = newImageRect( layers.underlay, centerX, centerY,  "images/paper2.jpg", { w = 380, h = 570, r = 90, alpha = 0.8 } )
--showRoom( 'start' )


