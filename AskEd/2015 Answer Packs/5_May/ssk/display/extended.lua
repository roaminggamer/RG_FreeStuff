-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================

local display_newCircle 		= display.newCircle
local display_newRect 			= display.newRect
local display_newRoundedRect 	= display.newRoundedRect
local display_newImage 			= display.newImage
local display_newImageRect 		= display.newImageRect
local display_newSprite 		= display.newSprite

local knownRuntimeListeners = { "enterFrame" }

local knownListeners = {
	"accelerometer",
	"audio",
	"axis",
	"collision",
	"colorSample",
	"completion",
	"fbconnect",
	"finalize",
	"gameNetwork",
	"gyroscope",
	"heading",
	"inputDeviceStatus",
	"key",
	"licensing",
	"location",
	"mapAddress",
	"mapLocation",
	"mapMarker",
	"mapTap",
	"memoryWarning",
	"mouse",
	"networkRequest",
	"networkStatus",
	"notification",
	"orientation",
	"particleCollision",
	"popup",
	"postCollision",
	"preCollision",
	"productList",
	"resize",
	"scene",
	"sprite",
	"storeTransaction",
	"system",
	"tap",
	"timer",
	"touch",
	"unhandledError",
	"urlRequest",
	"userInput",		
}

local knownSheets = {} 

if( not table.dump ) then
	function string:rpad(len, char)
	    if char == nil then char = ' ' end
	    return self .. string.rep(char, len - #self)
	end

	function table.dump(theTable, padding ) -- Sorted
		theTable = theTable or  {}
		padding = padding or 30

		local tmp = {}
		for n in pairs(theTable) do table.insert(tmp, n) end
		table.sort(tmp)

		print("\Table Dump:")
		print("-----")
		if(#tmp > 0) then
			for i,n in ipairs(tmp) do 		
				local key = tostring(tmp[i])
				local value = tostring(theTable[key])
				local keyType = type(key)
				local valueType = type(value)
				local keyString = key .. " (" .. keyType .. ")"
				local valueString = value .. " (" .. valueType .. ")" 
				keyString = keyString:rpad(padding)
				valueString = valueString:rpad(padding)
				print( keyString .. " == " .. valueString ) 
			end
		else
			print("empty")
		end
		print("-----\n")
	end
end

local fnn = _G.fnn
if( _G.fnn ) then
	fnn = function( ... ) 
		for i = 1, #arg do
			local theArg = arg[i]
			if(theArg ~= nil) then return theArg end
		end
		return nil
	end
end

local unpack 	= unpack
local pairs 	= pairs
local strGSub 	= string.gsub

-- Create the display class if it does not yet exist
--
local displayExtended = {}

--
-- Default physics parameters (used as default settings for all 'extended' builders below)
--
local dpp = {} -- Table containing settings

--
-- local functions (only used internally)
--
local initDPP
local applyVisualParams
local addBody 
local addBehaviors

-- ==
--    ssk.display.rect() - Extends display.newRect() by adding visual parameters and physics parameters.
-- ==
function displayExtended.rect( group, x, y, visualParams, bodyParams ) --, behaviorsList )
	group = group or display.currentStage
	visualParams = visualParams or {}

	local width = 40
	local height = 40
	local cornerRadius = 0

	if(visualParams) then
		if( visualParams.size ) then
			width = visualParams.size
			height = visualParams.size
		end

		if( visualParams.w ) then
			width = visualParams.w
		end
		if( visualParams.h ) then
			height = visualParams.h
		end

		if( visualParams.cornerRadius ) then
			cornerRadius = visualParams.cornerRadius
		end
	end
		
	local dObj 
	if( cornerRadius > 0 ) then
		dObj = display_newRoundedRect( group, 0, 0, width, height, cornerRadius )
	else
		dObj = display_newRect( group, 0, 0, width, height )
	end
	dObj.x = x
	dObj.y = y
	
	applyVisualParams( dObj, visualParams )
	
	if(bodyParams) then
		addBody(dObj, bodyParams) 
		if( dObj.density and not dObj.mass ) then
			dObj.mass = 0.001 * width * height * dObj.density
		end
	end
	if( ssk.__enableAutoListeners ) then
		for k,v in pairs( knownListeners ) do
			if( dObj[v] ) then dObj:addEventListener( v ) end
		end
		for k,v in pairs( knownRuntimeListeners ) do
			if( dObj[v] ) then Runtime:addEventListener( v, dObj ) end
		end
	end

	--EFM if(behaviorsList) then addBehaviors(dObj, behaviorsList) end
	return dObj
end
displayExtended.newRect = displayExtended.rect

-- ==
--    ssk.display.circle() - Extends display.newCircle() by adding visual parameters and physics parameters.
-- ==
function displayExtended.circle( group, x, y, visualParams, bodyParams ) --, behaviorsList )
	group = group or display.currentStage
	visualParams = visualParams or {}

	local radius = 20
	if(visualParams) then
		if( visualParams.size ) then
			radius = visualParams.size/2
		end
		if( visualParams.radius ) then
			radius = visualParams.radius
		end
		if( visualParams.diameter ) then
			radius = visualParams.diameter/2
		end
	end

	local dObj = display_newCircle( group, x, y, radius )

	applyVisualParams( dObj, visualParams )

	if(bodyParams) then 
		local bodyParams = table.shallowCopy(bodyParams)
		bodyParams.radius = radius
		addBody(dObj, bodyParams) 
		if( dObj.density ) then
			dObj.mass = 0.001 * math.pi * radius * radius * dObj.density
		end
	end

	if( ssk.__enableAutoListeners ) then
		for k,v in pairs( knownListeners ) do
			if( dObj[v] ) then dObj:addEventListener( v ) end
		end
		for k,v in pairs( knownRuntimeListeners ) do
			if( dObj[v] ) then Runtime:addEventListener( v, dObj ) end
		end
	end
	
	--EFM if(behaviorsList) then addBehaviors(dObj, behaviorsList) end
	return dObj
end
displayExtended.newCircle = displayExtended.circle

-- ==
--    ssk.display.image() - Extends display.newImage() by adding visual parameters and physics parameters.
-- ==
function displayExtended.image( group, x, y, imgSrc, visualParams, bodyParams ) --, behaviorsList )
	group = group or display.currentStage
	visualParams = visualParams or {}

	local dObj = display_newImage( group, imgSrc, 0, 0 )
	dObj.x = x
	dObj.y = y

	applyVisualParams( dObj, visualParams )

	local width  = dObj.contentWidth
	local height = dObj.contentHeight

	if(bodyParams) then 
		addBody(dObj, bodyParams, imgSrc) 
		if( dObj.density and not dObj.mass ) then
			dObj.mass = 0.001 * width * height * dObj.density
		end
	end

	if( ssk.__enableAutoListeners ) then
		for k,v in pairs( knownListeners ) do
			if( dObj[v] ) then dObj:addEventListener( v ) end
		end
		for k,v in pairs( knownRuntimeListeners ) do
			if( dObj[v] ) then Runtime:addEventListener( v, dObj ) end
		end
	end

	--EFM if(behaviorsList) then addBehaviors(dObj, behaviorsList) end
	return dObj
end
displayExtended.newImage = displayExtended.image

-- ==
--    ssk.createSheet
-- ==


-- ==
--    ssk.display.imageRect() - Extends display.newImageRect() by adding visual parameters and physics parameters.
-- ==
function displayExtended.imageRect( group, x, y, imgSrc, visualParams, bodyParams ) --, behaviorsList )
	group = group or display.currentStage
	visualParams = visualParams or {}

	local width = 40
	local height = 40

	if(visualParams) then
		if( visualParams.size ) then
			width = visualParams.size
			height = visualParams.size
		end
		if( visualParams.w ) then
			width = visualParams.w
		end
		if( visualParams.h ) then
			height = visualParams.h
		end
	end

	local dObj
	if( visualParams.frameName ) then
		local sheetData = knownSheets[imgSrc]
		if( not sheetData ) then
			sheetData = {}
			knownSheets[imgSrc] = sheetData
			sheetData.imgFile = imgSrc
			sheetData.infoFile = strGSub(imgSrc,"%/",".")
			sheetData.infoFile = strGSub(sheetData.infoFile,"%.png","")
			sheetData.info = require(sheetData.infoFile)
			sheetData.sheet = graphics.newImageSheet( sheetData.imgFile, sheetData.info:getSheet() )
			--table.dump(sheetData)
		end		
		local frameIndex = sheetData.info:getFrameIndex(visualParams.frameName)
		dObj = display_newImageRect( group, sheetData.sheet, frameIndex, width, height )
	else
		dObj = display_newImageRect( group, imgSrc, width, height )
	end

	dObj.x = x
	dObj.y = y

	applyVisualParams( dObj, visualParams )

	if(bodyParams) then 
		addBody(dObj, bodyParams, imgSrc) 
		if( dObj.density and not dObj.mass ) then
			dObj.mass = 0.001 * width * height * dObj.density
		end
	end

	if( ssk.__enableAutoListeners ) then
		for k,v in pairs( knownListeners ) do
			if( dObj[v] ) then dObj:addEventListener( v ) end
		end
		for k,v in pairs( knownRuntimeListeners ) do
			if( dObj[v] ) then Runtime:addEventListener( v, dObj ) end
		end
	end

	--EFM if(behaviorsList) then addBehaviors(dObj, behaviorsList) end
	return dObj
end
displayExtended.newImageRect= displayExtended.imageRect


-- ==
--    ssk.display.sprite() - Extends display.newImageRect() by adding visual parameters and physics parameters.
-- ==
function displayExtended.sprite( group, x, y, imgSrc, sequenceData, visualParams, bodyParams ) --, behaviorsList )
	group = group or display.currentStage
	visualParams = visualParams or {}

	local width
	local height

	if(visualParams) then
		if( visualParams.size ) then
			width = visualParams.size
			height = visualParams.size
		end
		if( visualParams.w ) then
			width = visualParams.w
		end
		if( visualParams.h ) then
			height = visualParams.h
		end
	end

	local sheetData = knownSheets[imgSrc]
	if( not sheetData ) then
		sheetData = {}
		knownSheets[imgSrc] = sheetData
		sheetData.imgFile = imgSrc
		sheetData.infoFile = strGSub(imgSrc,"%/",".")
		sheetData.infoFile = strGSub(sheetData.infoFile,"%.png","")
		sheetData.info = require(sheetData.infoFile)
		sheetData.sheet = graphics.newImageSheet( sheetData.imgFile, sheetData.info:getSheet() )
		--table.dump(sheetData)
	end	

	local dObj = display_newSprite( group, sheetData.sheet, sequenceData )

	local xScale = visualParams.scale or visualParams.xScale 
	local yScale = visualParams.scale or visualParams.yScale 

	width = width or dObj.contentWidth
	height = height or dObj.contentHeight

	local xScaleC = width/dObj.contentWidth
	local yScaleC = height/dObj.contentHeight

	visualParams.xScale = xScale and xScale * xScaleC or xScaleC
	visualParams.yScale = yScale and yScale * yScaleC or yScaleC

	dObj.x = x
	dObj.y = y

	applyVisualParams( dObj, visualParams )

	if(bodyParams) then
		addBody(dObj, bodyParams, imgSrc) 
		if( dObj.density and not dObj.mass ) then
			dObj.mass = 0.001 * width * height * dObj.density
		end
	end

	--EFM if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

	visualParams.autoPlay = fnn( visualParams.autoPlay, true )

	if( visualParams.sequence ) then
		dObj:setSequence(visualParams.sequence)
	end

	if( visualParams.frameNum ) then
		dObj:setFrame(visualParams.frameNum)
	end

	if( visualParams.frameName ) then
		local frameIndex = sheetData.info:getFrameIndex(visualParams.frameName)
		dObj:setFrame(frameIndex)
	end

	if( visualParams.autoPlay ) then
		dObj:play()
	end
	return dObj
end
displayExtended.newSprite = displayExtended.sprite

-- ==
--    initDPP() - Sets the default body parameters for all ssk created display objects that have bodies
-- ==
initDPP = function()
	dpp = {}
	-- Basic settings
	dpp.bodyType = "dynamic"
	dpp.bounce   = 0.2
	dpp.density  = 1.0
	dpp.friction = 0.3

	-- Extra Settings
	dpp.angularDamping     = 0
	dpp.isBodyActive       = true
	dpp.isBullet           = false
	dpp.isFixedRotation    = false
	dpp.isSensor           = false
	dpp.isSleepingAllowed  = true
	dpp.linearDamping      = 0
	dpp.gravityScale 	   = 1
	dpp.useOutline         = false
	dpp.outlineCoarseness  = 2
end

-- ==
--    ssk.display.listDPP() - (For Debug).  Prints current default physics parameters
-- ==
function displayExtended.listDPP()
	print("dpp (Default Physical Params):")
	for k,v in pairs(dpp) do
		print( tostring(k):rpad(20) .. " == ", tostring(v) )
	end
	print("\n")
end


-- ==
--    ssk.display.getDPP() - Returns the default physics parameters.
-- ==
function displayExtended.getDPP(name)
	return dpp[name]
end

-- ==
--    ssk.display.setDPP() - Replaces the DPP table with a new one.
-- ==
function displayExtended.setDPP(name,value)
	dpp[name] = value
end

-- ==
--    applyVisualParams() - Local function for adding bodies to the extended display objects.
-- ==
applyVisualParams = function( obj, visualParams )
	local ignoreParams = {}
	ignoreParams["fill"] 	= "fill"
	ignoreParams["stroke"] 	= "stroke"

	visualParams.xScale = visualParams.xScale or visualParams.scale
	visualParams.yScale = visualParams.yScale or visualParams.scale
	if(visualParams.stroke and visualParams.strokeWidth == nil) then visualParams.strokeWidth = 1 end

	if(visualParams.fill) then		
		if( visualParams.fill.type and visualParams.fill.type == "gradient" ) then
			obj.fill = visualParams.fill

		elseif( visualParams.fill.type and visualParams.fill.type == "composite" ) then
			obj.fill = visualParams.fill

			if( not visualParams.fillEffect ) then
				obj.fill.effect = "composite.average"
			else
				obj.fill.effect = visualParams.fillEffect
			end

		elseif( visualParams.fill.type and visualParams.fill.type == "image" ) then
			obj.fill = visualParams.fill				

		else
			obj:setFillColor( unpack(visualParams.fill) )
		end
	end

	if(visualParams.stroke) then		
		if( visualParams.stroke.type and visualParams.stroke.type == "gradient" ) then
			obj.stroke = visualParams.stroke

		elseif( visualParams.stroke.type and visualParams.stroke.type == "composite" ) then
			obj.stroke = visualParams.stroke

			if( not visualParams.strokeEffect ) then
				obj.stroke.effect = "composite.average"
			else
				obj.stroke.effect = visualParams.strokeEffect
			end

		elseif( visualParams.stroke.type and visualParams.stroke.type == "image" ) then
			obj.stroke = visualParams.stroke				

		else
			obj:setStrokeColor( unpack(visualParams.stroke) )
		end
	end

	for k,v in pairs(visualParams) do
		if( not ignoreParams[k] ) then
			obj[k] = v
		end
	end
end

-- ==
--    addBody() - Local function for adding bodies to the extended display objects.
-- ==
addBody = function( obj, bodyParams, imageFile )
	-- Copy basic body params into local params	
	local params = {}
	local paramNames = { "bounce", "density", "friction", "shape", "radius", "filter" }
	for k,v in ipairs( paramNames ) do
		params[v] = fnn(bodyParams[v], dpp[v])
	end

	-- Optionally get a collision filter
	local theCalculator
	if(bodyParams.calculator) then
		theCalculator = bodyParams.calculator
	else
		theCalculator = collisionCalculator
	end

	if(bodyParams.colliderName) then
		local myColliderName = bodyParams.colliderName
		if( theCalculator ) then
			local collisionFilter = theCalculator:getCollisionFilter( myColliderName )
			params.filter=collisionFilter	
			obj.colliderName = myColliderName
		else
			print("WARNING: SSK Extended Display Object -- Collider name specified, but no collision calculator found!")	
		end
	end

	if( imageFile and bodyParams.useOutline == true) then
		local outlineCoarseness = fnn( bodyParams.outlineCoarseness, dpp.outlineCoarseness )
		local imageOutline = graphics.newOutline( outlineCoarseness, imageFile )
		params.outline = imageOutline
	end

	-- add the body (square or circular)
	physics.addBody( obj, params )

	-- set any remaining parameters
	local paramNames = { "bodyType", "angularDamping", "isBodyActive", 
	                     "isBullet", "gravityScale", "collision",
	                     "isFixedRotation", "isSensor", "isSleepingAllowed", 
	                     "linearDamping", "density", "radius", 
	                     "angularVelocity",
	                    }
	for k,v in ipairs( paramNames ) do
		obj[v] = fnn(bodyParams[v], dpp[v], obj[v])
	end
end

-- ==
--    adBehaviors() - EFM - Not available right nowp
-- ==
addBehaviors = function( obj, behaviorsList )
	for k,v in ipairs( behaviorsList ) do
		local valueType = type(v)
			
		if( valueType == "string" ) then
			ssk.behaviors:attachBehavior(obj, v)
		elseif( valueType == "table" ) then
			ssk.behaviors:attachBehavior(obj, v[1], v[2] )
		else
			error("u_prototyping.lua:addBehaviors() => Unknown type: " .. valueType)
		end
	end
end

initDPP()

displayExtended.addBody = addBody

return displayExtended