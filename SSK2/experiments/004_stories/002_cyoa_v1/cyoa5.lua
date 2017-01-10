local imageRect 		= ssk.display.imageRect
local rect 				= ssk.display.rect
local easyIFC			= ssk.easyIFC
local tern 				= _G.ternary
local mRand 			= math.random

local getTimer 			= system.getTimer
local sysGetInfo		= system.getInfo
local strMatch 			= string.match
local strFormat 		= string.format

--[[
local layers = ssk.display.quickLayers( nil, "underlay", "background", "content", "buttons", "popup", "overlay" )


----------------------------------------------------------------------
--	Locals
----------------------------------------------------------------------
local startX = 10
local startY = 20

local nextX
local curX = startX
local curY = startY

local xSep = 8
local ySep = 24

local lastStory

local roomColor 	= { 1, 1, 0 }
local thingColor 	= _BRIGHTORANGE_
local objectColor 	= _PINK_
local scriptColor 	= _CYAN_

----------------------------------------------------------------------
--	Forward Declarations
----------------------------------------------------------------------
local showRoom
local showObjects
local wordIsTarget
local takeObject
local dropObject
local doPopup
local doYNPopup
local doTakeObjectPopup


-- EFM
-- EFM
-- EFM              Possible to do following as raw text formatted file?
-- EFM
-- EFM

-- Things
local things = {}
things.trail1  = { "That looks pretty steep.  Are you sure you want to go that way?", "Maybe you should go that way.  Maybe not." }
things.trail2  = "Wow, that is steep.  Watch your step if you go that way."

-- Objects
local objects = {}
objects.seashell1 = { "seashell", "You notice it has a very pleasing spiral shape." }
objects.rock1  = { "rock", "That a useful looking rock." }

-- Scripts
local scripts = {}
scripts.window  = { }

local targetIsRoom
local targetIsThing
local targetIsObject
local targetIsScript

local processTarget


local addTouch

----------------------------------------------------------------------
--	The Story
----------------------------------------------------------------------
local text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.  Lorem Ipsum is simply dummy text of the printing and typesetting industry.  "

-- EFM
-- EFM
-- EFM              Possible to do following as raw text formatted file?
-- EFM
-- EFM

local rooms = {}

rooms['start'] = { title = 'Beach', 
	description = "You are standing on a beach.  A rocky #trail#trail1 leads #north#room1 towards some cliffs.  To the #west#room2 you see a shack.  ",
	objects = { "seashell1" }  }

rooms['room1'] = { title = 'Cliffs', 
	description = "A small clearing rests at the base of impassible cliffs.  A rocky #trail#trail2 leads #south#start towards the ocean.  A grassy path leads uphill to the #west#room3.  ",
	objects = { }  }

rooms['room2'] = { title = 'Shack', 
	description = "A small shack with a single #door#shackdoor and a #window#shackwindow sits all alone on the edge of the island.  The door is closed.  Trails lead #north#room3 and #east#start.  ",
	objects = { }  }

rooms['room3'] = { title = 'Hilltop', 
	description = "You stand atop a low hill.  To the #east#room1 you see a grassy clearing.  To the #south#room2 is a shack.  A loose and rutted trail leads #southeast#start.  ",
	objects = { }  }

rooms['shackdoor'] = { title = 'Door', 
	description = "You open the door, and see a crossbow resting on a table and facing the door.  You also see a string, attaching the the crossbow's trigger to the doorknob... Twang!  Oomph!You died.  ",
	objects = { }  }

rooms['shackwindow'] = { title = 'Dirty Window', 	
	description = "The window is too dirty to see through.  If you could break the window, you would be able to look inside.  Oh well, there is always the door.  ",
	objects = { }  }



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
addTouch = function( obj, target, room )		
	
	obj.curRoom = room

	obj._type = "room"
	obj:setFillColor( unpack( roomColor ) )

	if( things[target] ) then
		obj._type = "thing"
		obj:setFillColor( unpack( thingColor ) )
	end

	if( objects[target] ) then
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
			showRoom( target )

		elseif( obj._type == "thing" ) then

			local printString

			if( type( things[target] ) == "string" ) then
				--print( things[target] )
				printString = things[target]
			else
				local list = things[target]
				--print( list[mRand(1,#list)] )
				printString = list[mRand(1,#list)]
			end

			doPopup( printString, obj.curRoom )
			

		elseif( obj._type == "object" ) then
			doTakeObjectPopup( objects[target][2], room, objects[target][1], target )

		elseif( obj._type == "script" ) then
			print( scripts[target] )
		end
		return true
	end


	obj:addEventListener( "touch", obj )
end

-- ==
--    showRoom() - EFM
-- ==
showRoom = function( room )
	display.remove( lastStory )
	lastStory = display.newGroup()
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
			addTouch( tmp, target, room )
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

		text = text .. "#" .. objects[name][1] .. "#" .. name
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
			addTouch( tmp, target, room )
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

	local back = rect( popup, 0, 0, { w = w, h = 140 } )
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

	local back = rect( popup, 0, 0, { w = w, h = 140 } )
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

	local back = rect( popup, 0, 0, { w = w, h = 140 } )
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

	

----------------------------------------------------------------------
--	Run the Story
----------------------------------------------------------------------
--display.setDefault( "fillColor", 0, 0, 0 )
local backImage = imageRect( layers.underlay, centerX, centerY,  "images/interface/protoBack.png", { w = 380, h = 570 } )
--local backImage = imageRect( layers.underlay, centerX, centerY,  "images/paper2.jpg", { w = 380, h = 570, r = 90, alpha = 0.8 } )
showRoom( 'start' )


--]]