-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
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

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

local displayBuilders

if( not _G.ssk.display ) then
	_G.ssk.display = {}
end

displayBuilders = _G.ssk.display

--
-- variables
--
local dpp
--
-- local functions (only used internally)
--
local initDPP
local addBody 
local addBehaviors

-- ==
--    func() - what it does
-- ==
function displayBuilders.rect( group, x, y, visualParams, bodyParams, behaviorsList )
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

	if(visualParams) then
		if(visualParams.fill) then dObj:setFillColor( unpack(visualParams.fill) ) end
		if(visualParams.stroke) then 
			dObj:setStrokeColor( unpack(visualParams.stroke) ) 
			dObj.strokeWidth = 1
		end
		if( visualParams.strokeWidth ) then dObj.strokeWidth = visualParams.strokeWidth end

		if( visualParams.myName ) then dObj.myName = visualParams.myName end -- debug params
	
		if( visualParams.rotation ) then dObj.rotation = visualParams.rotation end
	
	end

	if(bodyParams) then 
		addBody(dObj, bodyParams) 
		dObj.mass = 0.001 * width * height * dObj.density
	end
	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

	return dObj
end

-- ==
--    func() - what it does
-- ==
function displayBuilders.circle( group, x, y, visualParams, bodyParams, behaviorsList )
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

	if(visualParams) then
		if(visualParams.fill) then dObj:setFillColor( unpack(visualParams.fill) ) end
		if(visualParams.stroke) then 
			dObj:setStrokeColor( unpack(visualParams.stroke) ) 
			dObj.strokeWidth = 1
		end
		if( visualParams.strokeWidth ) then dObj.strokeWidth = visualParams.strokeWidth end

		if( visualParams.myName ) then dObj.myName = visualParams.myName end -- debug params

		if( visualParams.rotation ) then dObj.rotation = visualParams.rotation end
	end

	if(bodyParams) then 
		local bodyParams = table.shallowCopy(bodyParams)
		bodyParams.radius = radius
		addBody(dObj, bodyParams) 
		dObj.mass = 0.001 * math.pi * radius * radius * dObj.density
	end

	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

	return dObj
end

-- ==
--    func() - what it does
-- ==
function displayBuilders.imageRect( group, x, y, imgSrc, visualParams, bodyParams, behaviorsList )
	dprint(2, group, x, y, imgSrc, visualParams, bodyParams, behaviorsList )
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

	dprint(2, group, imgSrc, width, height )
	local dObj = display.newImageRect( group, imgSrc, width, height )

	dObj.x = x
	dObj.y = y

	if(visualParams) then
		if(visualParams.fill) then dObj:setFillColor( unpack(visualParams.fill) ) end
		if(visualParams.stroke) then 
			dObj:setStrokeColor( unpack(visualParams.stroke) ) 
			dObj.strokeWidth = 1
		end
		if( visualParams.strokeWidth ) then dObj.strokeWidth = visualParams.strokeWidth end

		if( visualParams.myName ) then dObj.myName = visualParams.myName end -- debug params

		if( visualParams.rotation ) then dObj.rotation = visualParams.rotation end
	end

	if(bodyParams) then 
		addBody(dObj, bodyParams) 
		dObj.mass = 0.001 * width * height * dObj.density
	end
if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

	return dObj
end

-- ==
--    func() - what it does
-- ==
function displayBuilders.imageCircle( group, x, y, imgSrc, visualParams, bodyParams, behaviorsList )
	local group = group or display.currentStage

	local radius = 40

	if(visualParams) then
		if( visualParams.size ) then
			radius = visualParams.size/2
		end
		if( visualParams.radius ) then
			radius = visualParams.radius
		end
		if( visualParams.diameter ) then
			radius = visualParams.diameter
		end
	end

	local dObj = display.newImageRect( group, imgSrc, radius*2, radius*2 )
	dObj.x = x
	dObj.y = y

	if(visualParams) then
		if(visualParams.fill) then dObj:setFillColor( unpack(visualParams.fill) ) end
		if(visualParams.stroke) then 
			dObj:setStrokeColor( unpack(visualParams.stroke) ) 
			dObj.strokeWidth = 1
		end
		if( visualParams.strokeWidth ) then dObj.strokeWidth = visualParams.strokeWidth end

		if( visualParams.myName ) then dObj.myName = visualParams.myName end -- debug params

		if( visualParams.rotation ) then dObj.rotation = visualParams.rotation end
	end

	if(bodyParams) then 
		local bodyParams = table.shallowCopy(bodyParams)
		bodyParams.radius = radius
		addBody(dObj, bodyParams) 
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
end

-- ==
--    func() - what it does
-- ==
function displayBuilders.listDPP()
	print("g_prototyping.lua => dpp (Default Physical Params):")
	for k,v in pairs(dpp) do
		print( tostring(k):rpad(20) .. " == ", tostring(v) )
	end
	print("\n")
end


-- ==
--    func() - what it does
-- ==
function displayBuilders.getDPP(name)
	return dpp[name]
end

-- ==
--    func() - what it does
-- ==
function displayBuilders.setDPP(name,value)
	dpp[name] = value
end

-- ==
--    func() - what it does
-- ==
addBody = function( obj, bodyParams )

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
		local collisionFilter = theCalculator:getCollisionFilter( myColliderName )
		params.filter=collisionFilter		
-- ==
--    func() - what it does
-- ==
		obj.getColliderName = function(self) return myColliderName end
	end

	-- add the body (square or circular)
	physics.addBody( obj, params )

	-- set any remaining parameters
	local paramNames = { "bodyType", "angularDamping", "isBodyActive", "isBullet", 
	                     "isFixedRotation", "isSensor", "isSleepingAllowed", "linearDamping", "density", "radius" }
	for k,v in ipairs( paramNames ) do
		obj[v] = fnn(bodyParams[v], dpp[v])
	end

end

-- ==
--    func() - what it does
-- ==
addBehaviors = function( obj, behaviorsList )
	for k,v in ipairs( behaviorsList ) do
		local valueType = type(v)
			
		if( valueType == "string" ) then
			dprint(2,"attach string variant")
			ssk.behaviors:attachBehavior(obj, v)
		elseif( valueType == "table" ) then
			dprint(2,"attach table variant")
			ssk.behaviors:attachBehavior(obj, v[1], v[2] )
		else
			error("u_prototyping.lua:addBehaviors() => Unknown type: " .. valueType)
		end
		
	end
end

-- ==
--    func() - what it does
-- ==
function displayBuilders.quickLayers( parentGroup, ... )


	local parentGroup = parentGroup or display.currentStage
	local layers = display.newGroup() 
	parentGroup:insert(layers)

	layers._db = {}

	local lastGroup

	dprint(1,"\\ (parentGroup)")
	
	for i = 1, #arg do
		local theArg = arg[i]
			
		if(type(theArg) == "string") then
			dprint(1,"|--\\ " .. theArg)
			local group = display.newGroup()
			lastGroup = group
			layers._db[#layers._db+1] = group 
			layers[theArg] = group 
			parentGroup:insert( group )

		else -- Must be a table -- ALLOW UP TO 'ONE' ADDITIONAL LEVEL OF DEPTH
			for j = 1, #theArg do
				local theArg2 = theArg[j]
				dprint(1,"   |--\\ " .. theArg2)
				if(type(theArg2) == "string") then
					local group = display.newGroup()
					layers._db[#layers._db+1] = group 
					layers[theArg2] = group 
					lastGroup:insert( group )
				else
					error("layers() Only two levels allowed!")
				end				
			end
		end		
	end

	-- ==
--    func() - what it does
-- ==
function layers:destroy()
		for i = #self._db, 1, -1 do
			dprint(2,"quickLayers(): Removing layer: " .. i)
			self._db[i]:removeSelf()
		end
		self:removeSelf()
	end
	
	return layers	
end

initDPP()

