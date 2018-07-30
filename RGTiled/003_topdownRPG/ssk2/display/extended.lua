-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Display Factories
-- =============================================================

local displayExtended = {}

local display_newCircle 		= display.newCircle
local display_newRect 			= display.newRect
local display_newRoundedRect 	= display.newRoundedRect
local display_newImage 			= display.newImage
local display_newImageRect 	= display.newImageRect
local display_newSprite 		= display.newSprite

-- Lists of 'listeners' that will be automatically hooked up up and started IF:
-- The listener is supplied in the `visualParams` parameters table.
--
local autoRuntimeListeners = { 
	"accelerometer",
	"axis",
	"enterFrame",
	"mouse",
	"key",
}

local autoListeners = {
	"collision",
	"finalize",
	"sprite",
	"tap",
	"touch",
}

-- Place to store automatically generated sheet data
--
local knownSheets = {} 

-- Ensure fnn() exists and if not implemented it.
--
local fnn
if( _G.fnn ) then
	fnn = _G.fnn
else
	fnn = function( ... ) 
		for i = 1, #arg do
			local theArg = arg[i]
			if(theArg ~= nil) then return theArg end
		end
		return nil
	end
end

-- Localize some much used functions for speedup
local unpack 	= unpack
local pairs 	= pairs
local strGSub 	= string.gsub


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
--    rgsk.display.newRect() - Extends display.newRect() by adding visual parameters and physics parameters.
-- ==
function displayExtended.newRect( group, x, y, visualParams, bodyParams, behaviorsList )
	group = group or display.currentStage
	visualParams = visualParams or {}

	local width = 40
	local height = 40
	local cornerRadius = 0

	if(visualParams) then
		if( visualParams.radius ) then
			width = visualParams.radius * 2
			height = visualParams.radius * 2
		end

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
	addBody(dObj, bodyParams) 

	for k,v in pairs( autoListeners ) do
		if( dObj[v] ) then dObj:addEventListener( v ) end
	end
	for k,v in pairs( autoRuntimeListeners ) do
		if( dObj[v] ) then Runtime:addEventListener( v, dObj ) end
	end

	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end
	return dObj
end

-- ==
--    rgsk.display.newCircle() - Extends display.newCircle() by adding visual parameters and physics parameters.
-- ==
function displayExtended.newCircle( group, x, y, visualParams, bodyParams, behaviorsList )
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
		bodyParams.radius = bodyParams.radius or radius		
	end
	addBody(dObj, bodyParams) 

	for k,v in pairs( autoListeners ) do
		if( dObj[v] ) then dObj:addEventListener( v ) end
	end
	for k,v in pairs( autoRuntimeListeners ) do
		if( dObj[v] ) then Runtime:addEventListener( v, dObj ) end
	end
	
	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end
	return dObj
end

-- ==
--    rgsk.display.newImage() - Extends display.newImage() by adding visual parameters and physics parameters.
-- ==
function displayExtended.newImage( group, x, y, imgSrc, visualParams, bodyParams, behaviorsList )
	group = group or display.currentStage
	visualParams = visualParams or {}

	local dObj
	if( visualParams.baseDir ) then
		dObj = display_newImage( group, imgSrc, visualParams.baseDir, 0, 0 )
	else
	end
	dObj.x = x
	dObj.y = y

	applyVisualParams( dObj, visualParams )

	local width  = dObj.contentWidth
	local height = dObj.contentHeight

	addBody(dObj, bodyParams, imgSrc) 

	for k,v in pairs( autoListeners ) do
		if( dObj[v] ) then dObj:addEventListener( v ) end
	end
	for k,v in pairs( autoRuntimeListeners ) do
		if( dObj[v] ) then Runtime:addEventListener( v, dObj ) end
	end

	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end
	return dObj
end

-- ==
--    rgsk.display.imageRect() - Extends display.newImageRect() by adding visual parameters and physics parameters.
-- ==
function displayExtended.newImageRect( group, x, y, imgSrc, visualParams, bodyParams, behaviorsList )
	group = group or display.currentStage
	visualParams = visualParams or {}

	local width = 40
	local height = 40

	if(visualParams) then

		if( visualParams.radius ) then
			width = visualParams.radius * 2
			height = visualParams.radius * 2
		end

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
		end		
		local frameIndex = sheetData.info:getFrameIndex(visualParams.frameName)
		dObj = display_newImageRect( group, sheetData.sheet, frameIndex, width, height )
	else
		if( visualParams.baseDir ) then
			dObj = display_newImageRect( group, imgSrc, visualParams.baseDir, width, height )
		else
			dObj = display_newImageRect( group, imgSrc, width, height )
		end
	end

	dObj.x = x
	dObj.y = y

	applyVisualParams( dObj, visualParams )

	addBody(dObj, bodyParams, imgSrc) 

	for k,v in pairs( autoListeners ) do
		if( dObj[v] ) then dObj:addEventListener( v ) end
	end
	for k,v in pairs( autoRuntimeListeners ) do
		if( dObj[v] ) then Runtime:addEventListener( v, dObj ) end
	end

	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end
	return dObj
end


-- ==
--    rgsk.display.sprite() - Extends display.newImageRect() by adding visual parameters and physics parameters.
-- ==
function displayExtended.newSprite( group, x, y, imgSrc, sequenceData, visualParams, bodyParams, behaviorsList )
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

	addBody(dObj, bodyParams, imgSrc)

	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

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

-- ==
--    initDPP() - Sets the default body parameters for all rgsk created display objects that have bodies
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
	dpp.gravityScale 	   	= 1
	dpp.useOutline         = false
	dpp.outlineCoarseness  = 2
end

-- ==
--    rgsk.display.listDPP() - (For Debug).  Prints current default physics parameters
-- ==
function displayExtended.listDPP()
	print("dpp (Default Physical Params):")
	for k,v in pairs(dpp) do
		print( tostring(k):rpad(20) .. " == ", tostring(v) )
	end
	print("\n")
end


-- ==
--    rgsk.display.getDPP() - Returns the default physics parameters.
-- ==
function displayExtended.getDPP(name)
	return dpp[name]
end

-- ==
--    rgsk.display.setDPP() - Replaces the DPP table with a new one.
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

-- --
--    Pill Shape Generator (Derived from code by Mike W. seen in Corona Geek Episode: #185 part 2)
-- ==
local function pillShape( obj, params )
	local ow = obj.contentWidth
	local oh = obj.contentHeight
	if( not ow or not oh ) then return false end
	local maxCorner = ( ow < oh ) and ow or oh
	local corner 	= params.corner or (maxCorner * 0.15)
	corner = ( corner > maxCorner ) and (0.5 * maxCorner) or corner
	local xScale 	= params.xScale or 1
	local yScale 	= params.yScale or 1
	local offsetX 	= params.offsetX or 0
	local offsetY 	= params.offsetY or 0
	local x,y = params.offsetX or 0, params.offsetY or 0	
	ow = ow * 0.5 * (xScale or 1)
	oh = oh * 0.5 * (yScale or 1)
	local shape = 
	{ 
		x - ow + corner, y - oh,
		x + ow - corner, y - oh,
		x + ow, y - oh + corner,
		x + ow, y + oh - corner,
		x + ow - corner, y + oh,
		x - ow + corner, y + oh,
		x - ow, y + oh - corner,
		x - ow, y - oh + corner,		
	}
	return shape
end


-- ==
--    addBody() - Local function for adding bodies to the extended display objects.
-- ==
addBody = function( obj, bodyParams, imageFile )
	if( not bodyParams ) then return end
	-- Copy basic body params into local params	
	local params = 
	{
		bounce 		= bodyParams.bounce or dpp.bounce, 
		density 	= bodyParams.density or dpp.density,
		friction 	= bodyParams.friction or dpp.friction,
		shape 		= bodyParams.shape or dpp.shape,
		radius 		= bodyParams.radius or dpp.radius,
		filter 		= bodyParams.filter or dpp.filter,
	}

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
	elseif( bodyParams.imageOutline) then
		params.outline = bodyParams.imageOutline
	end

	-- Add Pillshape
	if( bodyParams.pillParams ) then
		params.shape = pillShape( obj, bodyParams.pillParams )
	end

	-- add the body (square or circular)
	physics.addBody( obj, params )

	-- set any remaining parameters
	obj.bodyType 				= bodyParams.bodyType or dpp.bodyType
	obj.angularDamping 		= bodyParams.angularDamping or dpp.angularDamping	
	obj.isBodyActive 			= fnn(bodyParams.isBodyActive, dpp.isBodyActive)
	obj.isBullet 				= fnn(bodyParams.isBullet, dpp.isBullet)
	obj.gravityScale 			= bodyParams.gravityScale or dpp.gravityScale
	obj.isFixedRotation 		= fnn(bodyParams.isFixedRotation, dpp.isFixedRotation)
	obj.isSensor 				= fnn(bodyParams.isSensor, dpp.isSensor)
	obj.isSleepingAllowed 	= fnn(bodyParams.isSleepingAllowed, dpp.isSleepingAllowed)
	obj.linearDamping 		= bodyParams.linearDamping or dpp.linearDamping
	obj.density 				= bodyParams.density or dpp.density
	obj.radius 					= bodyParams.radius or dpp.radius
	obj.angularVelocity 		= bodyParams.angularVelocity or dpp.angularVelocity
end

-- ==
--    adBehaviors() - NOTE - Not available right now
-- ==
addBehaviors = function( obj, behaviorsList )
	for k,v in ipairs( behaviorsList ) do
		local valueType = type(v)
			
		if( valueType == "string" ) then
			ssk.behaviors.manager:attachBehavior(obj, v)
		elseif( valueType == "table" ) then
			ssk.behaviors.manager:attachBehavior(obj, v[1], v[2] )
		else
			error("u_prototyping.lua:addBehaviors() => Unknown type: " .. valueType)
		end
	end
end

initDPP()

displayExtended.addBody = addBody

return displayExtended