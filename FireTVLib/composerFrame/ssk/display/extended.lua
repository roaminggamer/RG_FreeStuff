-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- Prototyping Objects
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================

local debugLevel = 0 -- Comment out to get global debugLevel from main.cs
local function _dprint( lvl, ... )
	if( debugLevel >= lvl ) then
		print( unpack(arg) )
	end
end


if( not table.dump ) then
	function string:rpad(len, char)
		local theStr = self
	    if char == nil then char = ' ' end
	    return theStr .. string.rep(char, len - #theStr)
	end

	function table.dump(theTable, padding ) -- Sorted

		local theTable = theTable or  {}

		local tmp = {}
		for n in pairs(theTable) do table.insert(tmp, n) end
		table.sort(tmp)

		local padding = padding or 30
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


local fnn
if( not _G.fnn ) then
	fnn = function( ... ) 
		for i = 1, #arg do
			local theArg = arg[i]
			if(theArg ~= nil) then return theArg end
		end
		return nil
	end
else
	fnn = _G.fnn
end

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
	local group = group or display.currentStage

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
		dObj = display.newRoundedRect( group, 0, 0, width, height, cornerRadius )
	else
		dObj = display.newRect( group, 0, 0, width, height )
	end

	dObj.x = x
	dObj.y = y
	
	applyVisualParams( dObj, visualParams )

	if(bodyParams) then 
		addBody(dObj, bodyParams) 
		if( dObj.density ) then
			dObj.mass = 0.001 * width * height * dObj.density
		end
	end
	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

	return dObj
end

-- ==
--    ssk.display.circle() - Extends display.newCircle() by adding visual parameters and physics parameters.
-- ==
function displayExtended.circle( group, x, y, visualParams, bodyParams ) --, behaviorsList )
	local group = group or display.currentStage

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

	local dObj = display.newCircle( group, x, y, radius )

	applyVisualParams( dObj, visualParams )

	if(bodyParams) then 
		local bodyParams = table.shallowCopy(bodyParams)
		bodyParams.radius = radius
		addBody(dObj, bodyParams) 
		if( dObj.density ) then
			dObj.mass = 0.001 * math.pi * radius * radius * dObj.density
		end
	end

	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

	return dObj
end

-- ==
--    ssk.display.image() - Extends display.newImage() by adding visual parameters and physics parameters.
-- ==
function displayExtended.image( group, x, y, imgSrc, visualParams, bodyParams ) --, behaviorsList )
	_dprint(2, group, x, y, imgSrc, visualParams, bodyParams) --, behaviorsList )
	local group = group or display.currentStage

	_dprint(2, group, imgSrc )
	local dObj = display.newImage( group, imgSrc, 0, 0 )
	dObj.x = x
	dObj.y = y

	applyVisualParams( dObj, visualParams )

	local width  = dObj.contentWidth
	local height = dObj.contentHeight

	if(bodyParams) then 
		addBody(dObj, bodyParams, imgSrc) 
		if( dObj.density ) then
			dObj.mass = 0.001 * width * height * dObj.density
		end
	end
if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

	return dObj
end


-- ==
--    ssk.display.imageRect() - Extends display.newImageRect() by adding visual parameters and physics parameters.
-- ==
function displayExtended.imageRect( group, x, y, imgSrc, visualParams, bodyParams ) --, behaviorsList )
	_dprint(2, group, x, y, imgSrc, visualParams, bodyParams) --, behaviorsList )
	local group = group or display.currentStage

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

	_dprint(2, group, imgSrc, width, height )
	local dObj = display.newImageRect( group, imgSrc, width, height )

	dObj.x = x
	dObj.y = y

	applyVisualParams( dObj, visualParams )

	if(bodyParams) then 
		addBody(dObj, bodyParams, imgSrc) 
		if( dObj.density ) then
			dObj.mass = 0.001 * width * height * dObj.density
		end
	end
if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

	return dObj
end

-- ==
--    func() - what it does
-- ==
initDPP = function()
	dpp = {}
	-- Basic settings
	dpp.bodyType = "dynamic"
	dpp.bounce   = 0.2
	dpp.density  = nil -- 1.0 -- EFM
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
	print("g_prototyping.lua => dpp (Default Physical Params):")
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
	ignoreParams["fill"] = "fill"
	ignoreParams["stroke"] = "stroke"

	--table.dump( visualParams )


	if(visualParams) then

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
	local paramNames = { "bodyType", "angularDamping", "isBodyActive", "isBullet", "gravityScale", "collision",
	                     "isFixedRotation", "isSensor", "isSleepingAllowed", "linearDamping", "density", "radius" }
	for k,v in ipairs( paramNames ) do
		obj[v] = fnn(bodyParams[v], dpp[v])
	end

	if( bodyParams.collision ) then
		obj:addEventListener( "collision" )
	end
end

-- ==
--    func() - what it does
-- ==
addBehaviors = function( obj, behaviorsList )
	for k,v in ipairs( behaviorsList ) do
		local valueType = type(v)
			
		if( valueType == "string" ) then
			_dprint(2,"attach string variant")
			ssk.behaviors:attachBehavior(obj, v)
		elseif( valueType == "table" ) then
			_dprint(2,"attach table variant")
			ssk.behaviors:attachBehavior(obj, v[1], v[2] )
		else
			error("u_prototyping.lua:addBehaviors() => Unknown type: " .. valueType)
		end
		
	end
end

initDPP()

displayExtended.addBody = addBody
return displayExtended