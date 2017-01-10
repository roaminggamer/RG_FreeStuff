

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

----------------------------------------------------------------------
--	Locals
----------------------------------------------------------------------
local layers = gamelayers.get()


local startX = 10
local startY = 50 - unusedHeight/2

local nextX
local curX = startX
local curY = startY

local xSep = 8
local ySep = 22

local lastStory

local currentRoom

local normalText 	= _WHITE_
local roomColor 	= _BLUE_
local thingColor 	= _DARKGREY_
local objectColor 	= _GREY_

----------------------------------------------------------------------
--	Forward Declarations
----------------------------------------------------------------------
local addRoom
local showRoom
local init
local showObjects
local wordIsTarget
local takeObject
local dropObject
local addTouch
local processTarget

local _rooms = {}

addRoom = function( name, area, title, descr, objs )
	if( _rooms[name] ~= nil ) then
		error( "Room by the name " .. name .. " already exists!")
		return false
	end

	local theRoom = {}
	_rooms[name] = theRoom

	theRoom.area = area
	theRoom.title = title
	theRoom.description = descr
	theRoom.objects = objs or {}
end

local setTitle = function( name, title )
	local theRoom = _rooms[name]
	theRoom.title = title
end
local setDescription = function( name, descr )
	local theRoom = _rooms[name]
	theRoom.description = descr
end
local getObjects = function( name )
	local theRoom = _rooms[name]
    return theRoom.objects
end
local setObjects = function( name, objects )
	local theRoom = _rooms[name]
	theRoom.objects = objects or {}
end
local addObjects = function( name, ... )
	local objects = _rooms[name].objects
    for i = 1, #arg do
    	objects[#objects+1] = arg[i]
    end

end
local removeObjects = function( name, ... )
	local objects = _rooms[name].objects
    for i = 1, #arg do
    	local obj = arg[i]
    	for j = 1, #objects do
    		if (objects[j] == obj ) then
    			table.remove( objects, j )
    		end
    	end
    end
end
local hasObject = function( name, obj )
	local objects = _rooms[name].objects
	for j = 1, #objects do
		if (objects[j] == obj ) then
			return true
		end
	end
	return false
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
	
	--print(string.find( target, ".", 1, true ), target:len())

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

	----print("addTouch ==> ", target, word, room, "BO" )
	
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

	obj.touch = function( self, event )
		if( event.phase ~= "ended" ) then return true end
		--table.dump(event)
		if( obj._type == "room" ) then
			----print("Start 'room' touch")
			showRoom( target, currentRoom, word )
			----print("End 'room' touch")

		elseif( obj._type == "thing" ) then

			----print("Start 'thing' touch")
			--table.dump(obj)
			local descr = things.getDescription( obj, target, word, room )
			doPopup( descr, currentRoom )
			----print("End 'thing' touch")
			
		elseif( obj._type == "object" ) then
			----print("Start 'object' touch")
			--doTakeObjectPopup( objects[target][2], room, objects[target][1], target )
			local cantake, descr = objects.getDescription( obj, target, word, room )

			if( cantake == true ) then

				doTakeObjectPopup( descr , 
					               room, 
				    	           objects.getShort( target, room ), 
				               		target )
			else
				doPopup( descr, currentRoom )
			end
			----print("End 'object' touch")

		end
		return true
	end

	--[[
	local outline = newRect( obj.parent, obj.x + obj.contentWidth/2, obj.y + 2, 
		{ w = obj.contentWidth + 2, h = obj.contentHeight - 8, 
		  fill = _TRANSPARENT_, stroke = _WHITE_ } )
	--]]		  


	obj:addEventListener( "touch", obj )
end

-- ==
--    showRoom() - EFM
-- ==
showRoom = function( room )

	-- EFM do some 'leave room processing here?'

	display.remove( lastStory )
	lastStory = display.newGroup()

	post("before_" .. room, { fromRoom = currentRoom, room = room } )
	currentRoom = room

	layers.story:insert( lastStory )
	curX = startX
	curY = startY
	--print(room)

	local text
	local area 
	local title

	if( _rooms[room] ~= nil ) then
		text = string.gsub( _rooms[room].description, "\n", " " )
		area = _rooms[room].area
		title = _rooms[room].title
	else 
		text = "Missing description for room " .. room
		area = "UNKOWN"
		title = "ERROR"
	end

	text = string.gsub( text, "  ", " " )
	text = string.gsub( text, "  ", " " )
	text = string.gsub( text, "%. ", "." )
	text = string.gsub( text, "%.", ".  " )

	local words = text:split( " " )


	for i = 1, #words do
	--for i = 1, 2 do

		local word = words[i]

		if( string.find( word, "<br>" ) ) then
			--print("BOB" .. word)
			curX = startX
			curY = curY + ySep * 1.5
		end
		word = string.gsub( word, "<br>", "" )


		local doTouch = false
		local target 

		if( wordIsTarget( word ) ) then
			doTouch = true

			word,target = processTarget( word )


		end

		local tmp = display.newText( lastStory, word, 0, 0, gameFont, ySep - 2 )	
		tmp:setFillColor( unpack( normalText ) )
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

	--post( "onRoomChange", { area = _rooms[room].area, room = _rooms[room].title } )
	post( "onRoomChange", { area = area, room = title } )
	post("after_" .. room, { room = room } )
end

-- ==
--    showObjects() - EFM
-- ==
showObjects = function( room )
	curX = startX
	curY = curY + ySep * 2

	local curObjects 

	if( _rooms[room] ) then
		curObjects = _rooms[room].objects
	else
		curObjects = {}
	end

	local text = "There is a "

	if( #curObjects == 0 ) then
		return false
	end

	for i = 1, #curObjects do
		if( i ~= 1 and i == #curObjects ) then
			text  = text .. ", and a "

		elseif (i > 1) then
			text  = text .. ", "
		
		end

		local name = curObjects[i]

		print(i, name,room)

		text = text .. "#" .. objects.getShort( name, room ) .. "#" .. name
	end
	
	text = text .. " here."

	text = string.gsub( text, "  ", " " )
	text = string.gsub( text, "  ", " " )
	local words = text:split( " " )

	local text = _rooms[room].description
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
		tmp:setFillColor( unpack( normalText ) )
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

	player:inventoryAdd( target )
	post("onUpdateInventory")
	----print(target,room)

	local roomObjects = _rooms[room].objects
	for i = 1, #roomObjects do
		if(roomObjects[i] == target) then
			table.remove( roomObjects, i )
			return
		end
	end
end

-- ==
--    dropObject() - EFM
-- ==
dropObject = function( target, room )
	----print(target,room)
	local roomObjects = _rooms[room].objects
	roomObjects[#roomObjects+1] = target
end


init = function()
	--local backImage = newImageRect( layers.underlay, centerX, centerY,  "protoBack.png", { w = 380, h = 570 } )
	--local backImage = newImageRect( layers.underlay, centerX, centerY,  "back1.png", { w = 380, h = 570 } )
end

local public = {}

public.init 			= init
public.add 				= addRoom
public.showRoom 		= showRoom
public.takeObject		= takeObject
public.getCurrentRoom 	= function() return currentRoom end


public.setTitle 		= setTitle
public.setDescription 	= setDescription
public.getObjects 		= getObjects
public.setObjects 		= setObjects
public.addObjects 		= addObjects
public.removeObjects	= removeObjects
public.hasObject 		= hasObject


return public
	

----------------------------------------------------------------------
--	Run the Story
----------------------------------------------------------------------
--display.setDefault( "fillColor", 0, 0, 0 )
--local backImage = newImageRect( layers.underlay, centerX, centerY,  "images/interface/protoBack.png", { w = 380, h = 570 } )
--local backImage = newImageRect( layers.underlay, centerX, centerY,  "images/paper2.jpg", { w = 380, h = 570, r = 90, alpha = 0.8 } )
--showRoom( 'start' )


