local things  		= require "scripts.things"
local objects 		= require "scripts.objects"
local gamelayers 	= require( "scripts.gamelayers" )
local player 		= require "scripts.player"


-- SSK 
local isInBounds		= ssk.easyIFC.isInBounds
local newCircle 		= ssk.display.circle
local newRect 			= ssk.display.rect
local newImageRect 		= ssk.display.imageRect
local easyIFC			= ssk.easyIFC
local ternary			= _G.ternary
local quickLayers  		= ssk.display.quickLayers
local easyPush 			= ssk.easyPush

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

----------------------------------------------------------------------
--	Locals
----------------------------------------------------------------------
local layers = gamelayers.get()

local inventoryBox

local onInventoryPush
local onStatusPush
local onMapPush

local openCloseTime = 0

local function tchelper(first, rest)
  return first:upper()..rest:lower()
end
local function capFirst( str )
	str = str:gsub("(%a)([%w_']*)", tchelper)
	return str
end

local function closeGroups()
	local invGroup = layers.inv
	local statusGroup = layers.status
	local mapGroup = layers.map

	print(invGroup.isOpen, statusGroup.isOpen, mapGroup.isOpen)

	if (invGroup.isOpen) then
		invGroup.isOpen  = false
		transition.to( invGroup, { y = invGroup.closedY, time = openCloseTime, transition = easing.outCirc })
	end
	if (statusGroup.isOpen) then
		statusGroup.isOpen  = false
		transition.to( statusGroup, { y = statusGroup.closedY, time = openCloseTime, transition = easing.outCirc })
	end
	if (mapGroup.isOpen) then
		mapGroup.isOpen  = false
		transition.to( mapGroup, { y = mapGroup.closedY, time = openCloseTime, transition = easing.outCirc })
	end
end

----------------------------------------------------------------------
--	Builders
----------------------------------------------------------------------

--
--== LOCATION BAR *** TOP OF SCREEN ***
--
local function createLocationBar()
	layers.locationBar.y = -unusedHeight/2
	local bar = newRect(layers.locationBar, centerX, 15, { w = w, h = 30, fill = _DARKERGREY_, stroke = _BLACK_, strokeWidth = 1} )

	-- Top Bar
	--local tmp = easyIFC:quickLabel(layers.locationBar, "<<", 5, bar.y, system.nativeFont, 14, _BLACK_ )
	--tmp.anchorX = 0
	--easyIFC:presetPush( layers.locationBar, "default", w - 16 , bar.y, 25, 25, "X", nil )

	local areaName = easyIFC:quickLabel(layers.locationBar, "AREANAME012", 10, bar.y, system.nativeFont, 16, _WHITE )
	areaName.anchorX = 0
	areaName.maxWidth = areaName.contentWidth
	areaName.setText = function( self , text )
		self.text = text
		self.xScale = 1
		if(self.contentWidth > self.maxWidth) then
			self.xScale = self.maxWidth/self.contentWidth
		end
	end

	areaName.onRoomChange = function( self, event )
		self:setText( event.area .. " - " )
	end
	listen( "onRoomChange", areaName )


	local subAreaName = easyIFC:quickLabel(layers.locationBar, "SUBAREANAME012345", 125, bar.y, system.nativeFont, 16, _WHITE )
	subAreaName.anchorX = 0
	subAreaName.maxWidth = subAreaName.contentWidth
	subAreaName.setText = function( self , text )
		self.text = text
		self.xScale = 1
		if(self.contentWidth > self.maxWidth) then
			self.xScale = self.maxWidth/self.contentWidth
		end
		self.x = areaName.x + areaName.contentWidth
	end

	subAreaName.onRoomChange = function( self, event )
		self:setText( event.room )
	end
	listen( "onRoomChange", subAreaName )

end

--
--== BOTTOM BAR *** BOTTOM OF SCREEN ***
--
local function createBottomBar()
	layers.botBar.y = h + unusedHeight/2 - 30
	local bar = newRect(layers.botBar, centerX, 15, { w = w, h = 30, fill = _DARKERGREY_, stroke = _BLACK_, strokeWidth = 1} )

	local tmp easyIFC:presetPush( layers.botBar, "default", 4+75/2 , bar.y, 75, 25, "Inventory", onInventoryPush )
	local tmp easyIFC:presetPush( layers.botBar, "default", 8 + 1.5 * 75 , bar.y, 75, 25, "Status", onStatusPush )
	local tmp easyIFC:presetPush( layers.botBar, "default", 12 + 2.5 * 75, bar.y, 75, 25, "Map", onMapPush )
	local tmp easyIFC:presetPush( layers.botBar, "default", 16 + 3.5 * 75, bar.y, 75, 25, "Options", nil )

end

--
--== StoryBox *** TOP OF SCREEN ***
--
local function createStoryBox()
	--local story = newRect(layers.story, centerX, centerY - 105, { w = w, h = 208, fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 1} )
	--local backImage = newImageRect( layers.underlay, centerX, centerY,  "images/interface/protoBack.png", { w = 380, h = 570 } )
	--local storyBack = newImageRect( layers.story, centerX, centerY,  "paper2.jpg", { w = 380, h = 570, r = 90, alpha = 0.2 } )

end

--
--== InventoryBox
--
local function createInventoryBox( )

	local width 	= w
	local height 	= h - 60 + unusedHeight
	local left 		= 0
	local top 		= 0 

	local invGroup = layers.inv

	invGroup.y = -unusedHeight/2 + 30

	newRect(invGroup, centerX, top, { w = width, h = height, fill = _DARKERGREY_, stroke = _YELLOW_, strokeWidth = 1, anchorY = 0} )

	local tmp = easyIFC:quickLabel(invGroup, "Inventory", centerX, 14 , system.nativeFont, 24, _WHITE_ )

	invGroup.isOpen 	= true
	invGroup.openY 		= invGroup.y 
	invGroup.closedY 	= invGroup.y + height

	invGroup.isOpen = false
	invGroup.y = invGroup.closedY

	invGroup.onShowHideInventory = function( self, event )	
		if( self.isOpen ) then
			closeGroups()
		else
			closeGroups()
			self.isOpen = true
			transition.to( self, { y = self.openY, time = openCloseTime, transition = easing.outCirc })
		end
		return true
	end
	listen( "onShowHideInventory", invGroup )

	--local line = display.newLine( layers.inv, centerX, top + 8, cx, top + height - 8)

	post("onUpdateInventory")
end

local function createInventoryBoxContent( )

	local invGroup = layers.inv
	local inv = player:getInventoryTable()

	display.remove(inventoryBox) 
	inventoryBox = display.newGroup()
	invGroup:insert( inventoryBox )

	local col1 = 7
	local col2 = 310

	local perColumn = 15

	local fontSize 	= 18
	local curY 		= 40
	local tweenY 	= 26 + unusedHeight/(perColumn+1)


	local onTouch = function( self, event )
		post("onInventoryTouch", { item = self.itemName }, 2 )
		--print( self.text )
		--table.dump(event)
	end
	for i = 1, perColumn do
		local item = inv[i]
		if( item ) then
			local name = item[1]
			local num = tonumber(item[2])
			local short = objects.getShort(name)
			local capName = capFirst(short)
			capName = string.gsub( capName, "_", " ")

			local tmp = easyIFC:quickLabel(inventoryBox, capName, col1, curY, system.nativeFont, fontSize, _WHITE_ )
			tmp.itemName = name
			tmp.anchorX = 0.5
			tmp.x = tmp.contentWidth/2 + col1
			easyPush.easyPushButton( tmp, onTouch )
			local tmp = easyIFC:quickLabel(inventoryBox, string.format("%3.3d", num ) , col2, curY, system.nativeFont, fontSize, _WHITE_ )
			tmp.anchorX = 1
		end
		curY = curY + tweenY		
	end
end
listen("onUpdateInventory", createInventoryBoxContent )


--
--== StatusBox
--
local function createStatusBox( )

	local width 	= w
	local height 	= h - 60 + unusedHeight
	local left 		= 0
	local top 		= 0 

	local statusGroup = layers.status

	statusGroup.y = -unusedHeight/2 + 30

	newRect(statusGroup, centerX, top, { w = width, h = height, fill = _DARKERGREY_, stroke = _YELLOW_, strokeWidth = 1, anchorY = 0} )

	local tmp = easyIFC:quickLabel(statusGroup, "Status", centerX, 14 , system.nativeFont, 24, _WHITE_ )

	statusGroup.isOpen 	= true
	statusGroup.openY 		= statusGroup.y 
	statusGroup.closedY 	= statusGroup.y + height

	statusGroup.isOpen = false
	statusGroup.y = statusGroup.closedY

	statusGroup.onShowHideStatus = function( self, event )
		if( self.isOpen ) then
			closeGroups()
		else
			closeGroups()
			self.isOpen = true
			transition.to( self, { y = self.openY, time = openCloseTime, transition = easing.outCirc })
		end
		return true
	end
	listen( "onShowHideStatus", statusGroup )

	--local line = display.newLine( layers.inv, centerX, top + 8, cx, top + height - 8)

	post("onUpdateStatus")
end

local function createStatusBoxContent( )
end
listen("onUpdateStatus", createStatusBoxContent )



--
--== MapBox
--
local function createMapBox( )
	local width 	= w
	local height 	= h - 60 + unusedHeight
	local left 		= 0
	local top 		= 0 

	local mapGroup = layers.map

	mapGroup.y = -unusedHeight/2 + 30

	newRect(mapGroup, centerX, top, { w = width, h = height, fill = _DARKERGREY_, stroke = _YELLOW_, strokeWidth = 1, anchorY = 0} )

	local tmp = easyIFC:quickLabel(mapGroup, "Map", centerX, 14 , system.nativeFont, 24, _WHITE_ )

	mapGroup.isOpen 	= true
	mapGroup.openY 		= mapGroup.y 
	mapGroup.closedY 	= mapGroup.y + height

	mapGroup.isOpen = false
	mapGroup.y = mapGroup.closedY

	mapGroup.onShowHideMap = function( self, event )
		if( self.isOpen ) then
			closeGroups()
		else
			closeGroups()
			self.isOpen = true
			transition.to( self, { y = self.openY, time = openCloseTime, transition = easing.outCirc })
		end
		return true
	end
	listen( "onShowHideMap", mapGroup )

	--local line = display.newLine( layers.inv, centerX, top + 8, cx, top + height - 8)

	post("onUpdateMap")
end

local function createMapBoxContent( )
end
listen("onUpdateMap", createMapBoxContent )


onInventoryPush = function()
	post( "onShowHideInventory" )
end

onStatusPush = function()
	post( "onShowHideStatus" )
end


onMapPush = function()
	post( "onShowHideMap" )
end

local public = {}

public.create = function()
	createLocationBar()
	createStoryBox()
	createBottomBar()
	createInventoryBox()
	createStatusBox()
	createMapBox()
end

return public