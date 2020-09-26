-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Particle Emitter (Loader/Creator)
-- =============================================================
local json 		= require "json"
local function round(val, n) if (n) then  return math.floor( (val * 10^n) + 0.5) / (10^n); else return math.floor(val+0.5); end end


-- ==
--    fnn( ... ) - Return first argument from list that is not nil.
--    ... - Any number of any type of arguments.
-- ==
local function fnn ( ... ) 
	for i = 1, #arg do
		local theArg = arg[i]
		if(theArg ~= nil) then return theArg end
	end
	return nil
end


-- ==
--    Common emitter builder, used by all other variants below.
-- ==
local function pex( group, x, y, data, params )
	params = params or {}
	local group = group or display.currentStage
	local overrides 	= overrides or {}
	local fixNumbers 	= params.fixNumbers or false

	-- Strip for override later
	--params.fixNumbers = nil

	-- Apply overrides
	for k,v in pairs(params) do
		data[k] = v
	end

	-- If 'fixNumbers' requested, apply
	if( fixNumbers ) then
		local val
		for k,v in pairs(data) do
			val = tonumber(v)
			if( val ~= nil ) then
				data[k] = val
				print(val)
			end
		end
	end
	--table.dumpu(data)

	local emitter = display.newEmitter( data )
	emitter.x = x
	emitter.y = y	

	group:insert(emitter)

	return emitter, data
end

-- ====================================================
--
--	Load PD2 Editor 1 & 2 Formats and Create Emitter
--
--	PD2 ==>	Particle Designer 2 (https://71squared.com/particledesigner)
--
-- ====================================================
local function pd2Loader( group, x, y, fileName, params )
	params = params or {}
	local group = group or display.currentStage
	local overrides 	= overrides or {}
	local texturePath 	= params.texturePath or ""
	local altTexture 	= params.altTexture 
	local noEmitter 	= fnn(params.noEmitter,false)

	-- Strip for override later
	params.texturePath = nil
	params.altTexture = nil

	-- Load and Display Particle(s)
	--print("Loading particle data file: " .. fileName)
	local data = table.load( fileName, system.ResourceDirectory )		
	
	-- Apply alternate texture and texture path if provided
	data.textureFileName = altTexture or data.textureFileName
	data.textureFileName = texturePath .. data.textureFileName

	-- Repaire bad lifespan (sometimes exported by PD 2)
	data.particleLifespan = tonumber(data.particleLifespan) or 0.05

	-- Strip off the unused image data if present
	data.textureImageData = nil 

	if( noEmitter == true ) then
		return data
	end
	return pex( group, x, y, data, params)
end

-- ====================================================
--
--	Load Starling Editor 1 & 2 Formats and Create Emitter
--
--	Starling (http://onebyonedesign.com/)
--
-- ====================================================
local xml={}function xml.new()XmlParser={};function XmlParser:toXMLString(value)value=string.gsub(value,"&","&amp;");value=string.gsub(value,"<","&lt;");value=string.gsub(value,">","&gt;");value=string.gsub(value,"\"","&quot;");value=string.gsub(value,"([^%w%&%;%p%\t% ])",function(c)return string.format("&#x%X;",string.byte(c))end);return value;end
function XmlParser:fromXMLString(value)value=string.gsub(value,"&#x([%x]+)%;",function(h)return string.char(tonumber(h,16))end);value=string.gsub(value,"&#([0-9]+)%;",function(h)return string.char(tonumber(h,10))end);value=string.gsub(value,"&quot;","\"");value=string.gsub(value,"&apos;","'");value=string.gsub(value,"&gt;",">");value=string.gsub(value,"&lt;","<");value=string.gsub(value,"&amp;","&");return value;end
function XmlParser:parseArgs(s)local arg={}string.gsub(s,"(%w+)=([\"'])(.-)%2",function(w,_,a)arg[w]=self:fromXMLString(a);end)return arg
end
function XmlParser:parseXMLTest(xmlText)local stack={}local top={name=nil,value=nil,properties={},child={}}table.insert(stack,top)local ni,c,label,xarg,empty
local i,j=1,1 while true do
ni,j,c,label,xarg,empty=string.find(xmlText,"<(%/?)([%w:]+)(.-)(%/?)>",i)if not ni then break end
local text=string.sub(xmlText,i,ni-1);if not string.find(text,"^%s*$")then
top.value=(top.value or"")..self:fromXMLString(text);end
if empty=="/"then
table.insert(top.child,{name=label,value=nil,properties=self:parseArgs(xarg),child={}})elseif c==""then
top={name=label,value=nil,properties=self:parseArgs(xarg),child={}}table.insert(stack,top)else
local toclose=table.remove(stack)top=stack[#stack]if(#stack<1)then
error("XmlParser: nothing to close with "..label)end
if toclose.name~=label then
error("XmlParser: trying to close "..toclose.name.." with "..label)end
table.insert(top.child,toclose)end
i=j+1
end
local text=string.sub(xmlText,i);if not string.find(text,"^%s*$")then
stack[#stack].value=(stack[#stack].value or"")..self:fromXMLString(text);end
if(#stack>1)then
error("XmlParser: unclosed "..stack[stack.n].name)end
return stack[1].child[1];end
function XmlParser:loadFile(xmlFilename,base)if not base then
base=system.ResourceDirectory
end
local path=system.pathForFile(xmlFilename,base)local hFile,err=io.open(path,"r");if hFile and not err then
local xmlText=hFile:read("*a");io.close(hFile);return self:parseXMLTest(xmlText),nil;else
print(err)return nil
end
end
return XmlParser
end
local legend = {}
legend.FinishParticleSizeVariancevalue = "finishParticleSizeVariance";
legend.angleVariancevalue = "angleVariance";
legend.anglevalue = "angle";
legend.blendFuncDestinationvalue = "blendFuncDestination";
legend.blendFuncSourcevalue = "blendFuncSource";
legend.durationvalue = "duration";
legend.emitterTypevalue = "emitterType";
legend.finishColorVariancealpha = "finishColorVarianceAlpha";
legend.finishColorVarianceblue = "finishColorVarianceBlue";
legend.finishColorVariancegreen = "finishColorVarianceGreen";
legend.finishColorVariancered = "finishColorVarianceRed";
legend.finishColoralpha = "finishColorAlpha";
legend.finishColorblue = "finishColorBlue";
legend.finishColorgreen = "finishColorGreen";
legend.finishColorred = "finishColorRed";
legend.finishParticleSizevalue = "finishParticleSize";
legend.gravityx = "gravityx";
legend.gravityy = "gravityy";
legend.maxParticlesvalue = "maxParticles";
legend.maxRadiusVariancevalue = "maxRadiusVariance";
legend.maxRadiusvalue = "maxRadius";
legend.minRadiusvalue = "minRadius";
legend.particleLifeSpanvalue = "particleLifespan";
legend.particleLifespanVariancevalue = "particleLifespanVariance";
legend.radialAccelVariancevalue = "radialAccelVariance";
legend.radialAccelerationvalue = "radialAcceleration";
legend.rotatePerSecondVariancevalue = "rotatePerSecondVariance";
legend.rotatePerSecondvalue = "rotatePerSecond";
legend.rotationEndVariancevalue = "rotationEndVariance";
legend.rotationEndvalue = "rotationEnd";
legend.rotationStartVariancevalue = "rotationStartVariance";
legend.rotationStartvalue = "rotationStart";
legend.sourcePositionVariancex = "sourcePositionVariancex";
legend.sourcePositionVariancey = "sourcePositionVariancey";
legend.sourcePositionx = "sourcePositionx";
legend.sourcePositiony = "sourcePositiony";
legend.speedVariancevalue = "speedVariance";
legend.speedvalue = "speed";
legend.startColorVariancealpha = "startColorVarianceAlpha";
legend.startColorVarianceblue = "startColorVarianceBlue";
legend.startColorVariancegreen = "startColorVarianceGreen";
legend.startColorVariancered = "startColorVarianceRed";
legend.startColoralpha = "startColorAlpha";
legend.startColorblue = "startColorBlue";
legend.startColorgreen = "startColorGreen";
legend.startColorred = "startColorRed";
legend.startParticleSizeVariancevalue = "startParticleSizeVariance";
legend.startParticleSizevalue = "startParticleSize";
legend.tangentialAccelVariancevalue = "tangentialAccelVariance";
legend.tangentialAccelerationvalue = "tangentialAcceleration";
legend.texturename = "textureFileName";

local function starlingConverter( filename )
	print( "Parsing PEX file " .. filename )
	local parser = xml.new()
	local tmp = parser:loadFile( filename )
	local tmp2 = {}
	for i = 1, #tmp.child do
		for k,v in pairs( tmp.child[i].properties ) do
			tmp2[tmp.child[i].name .. tostring(k)] = v
		end
	end
	for k, v in pairs(legend) do
		if(tmp2[k]) then
			local tmpVal = tmp2[k]
			tmp2[k] = nil
			tmp2[v] = tmpVal
			
		end
	end
	for k,v in pairs( tmp2 ) do
		if( tonumber( v ) ) then
			tmp2[k] = tostring( round(v,2) )
		end
	end
	return tmp2
end

local function starlingLoader( group, x, y, fileName, params )
	params = params or {}
	local group = group or display.currentStage
	local overrides 	= overrides or {}
	local texturePath 	= params.texturePath or ""
	local altTexture 	= params.altTexture 
	local noEmitter 	= fnn(params.noEmitter,false)

	-- Force numbers fix 
	params.fixNumbers = true

	-- Strip for override later
	params.texturePath = nil
	params.altTexture = nil

	-- Load and Display Particle(s)
	--print("Loading particle data file: " .. fileName)
	local data = starlingConverter( fileName )

	-- Apply alternate texture and texture path if provided
	data.textureFileName = altTexture or data.textureFileName
	data.textureFileName = texturePath .. data.textureFileName

	-- Repaire bad values sometimes exported by OneByDesign editor
	data.gravityx = tonumber(data.gravityx) or 0
	data.gravityy = tonumber(data.gravityy) or 0
	minRadiusVariance = tonumber(minRadiusVariance) or 0
	sourcePositionVariancex = tonumber(sourcePositionVariancex) or 0
	sourcePositionVariancey = tonumber(sourcePositionVariancey) or 0
	data.yCoordFlipped = tonumber(data.yCoordFlipped) or 1
	data.maxParticles = tonumber(data.maxParticles) or 100
	data.particleLifespan = tonumber(data.particleLifespan) or 0.05
	--table.dump(data)

	if( noEmitter == true ) then
		return data
	end
	return pex( group, x, y, data, params)
end

-- ====================================================
--
--	Load RG Particle Editor 1 & 2 Formats and Create Emitter
--
-- ====================================================
local function rgLoader( group, x, y, fileName, params )
	params = params or {}
	local group = group or display.currentStage
	local overrides 	= overrides or {}
	local texturePath 	= params.texturePath or ""
	local altTexture 	= params.altTexture 
	local noEmitter 	= fnn(params.noEmitter,false)

	-- Force numbers fix 
	--params.fixNumbers = true

	-- Strip for override later
	params.texturePath = nil
	params.altTexture = nil

	-- Load and Display Particle(s)
	--print("Loading particle data file: " .. fileName)
	local data = table.load( fileName, system.ResourceDirectory )

	--table.dump(data)

	-- Apply alternate texture and texture path if provided
	data.textureFileName = altTexture or data.textureFileName
	data.textureFileName = texturePath .. data.textureFileName

	if( noEmitter == true ) then
		return data
	end
	return pex( group, x, y, data, params)
end


local public = {}
public.loadRG  		= rgLoader
public.loadPD2 		= pd2Loader
public.loadStarling 	= starlingLoader

----------------------------------------------------------------------
--	Attach To SSK and return
----------------------------------------------------------------------
if( _G.ssk ) then
	ssk.pex = public
else 
	_G.ssk = { pex = public }
end


return public