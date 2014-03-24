local xml = require "scripts.xml"

local legend = {}
legend.FinishParticleSizeVariancevalue = "finishParticleSizeVariance"
legend.angleVariancevalue = "angleVariance"
legend.anglevalue = "angle"
legend.blendFuncDestinationvalue = "blendFuncDestination"
legend.blendFuncSourcevalue = "blendFuncSource"
legend.durationvalue = "duration"
legend.emitterTypevalue = "emitterType"
legend.finishColorVariancealpha = "finishColorVarianceAlpha"
legend.finishColorVarianceblue = "finishColorVarianceBlue"
legend.finishColorVariancegreen = "finishColorVarianceGreen"
legend.finishColorVariancered = "finishColorVarianceRed"
legend.finishColoralpha = "finishColorAlpha"
legend.finishColorblue = "finishColorBlue"
legend.finishColorgreen = "finishColorGreen"
legend.finishColorred = "finishColorRed"
legend.finishParticleSizevalue = "finishParticleSize"
legend.gravityx = "gravityx"
legend.gravityy = "gravityy"
legend.maxParticlesvalue = "maxParticles"
legend.maxRadiusVariancevalue = "maxRadiusVariance"
legend.maxRadiusvalue = "maxRadius"
legend.minRadiusvalue = "minRadius"
legend.particleLifeSpanvalue = "particleLifespan"
legend.particleLifespanVariancevalue = "particleLifespanVariance"
legend.radialAccelVariancevalue = "radialAccelVariance"
legend.radialAccelerationvalue = "radialAcceleration"
legend.rotatePerSecondVariancevalue = "rotatePerSecondVariance"
legend.rotatePerSecondvalue = "rotatePerSecond"
legend.rotationEndVariancevalue = "rotationEndVariance"
legend.rotationEndvalue = "rotationEnd"
legend.rotationStartVariancevalue = "rotationStartVariance"
legend.rotationStartvalue = "rotationStart"
legend.sourcePositionVariancex = "sourcePositionVariancex"
legend.sourcePositionVariancey = "sourcePositionVariancey"
legend.sourcePositionx = "sourcePositionx"
legend.sourcePositiony = "sourcePositiony"
legend.speedVariancevalue = "speedVariance"
legend.speedvalue = "speed"
legend.startColorVariancealpha = "startColorVarianceAlpha"
legend.startColorVarianceblue = "startColorVarianceBlue"
legend.startColorVariancegreen = "startColorVarianceGreen"
legend.startColorVariancered = "startColorVarianceRed"
legend.startColoralpha = "startColorAlpha"
legend.startColorblue = "startColorBlue"
legend.startColorgreen = "startColorGreen"
legend.startColorred = "startColorRed"
legend.startParticleSizeVariancevalue = "startParticleSizeVariance"
legend.startParticleSizevalue = "startParticleSize"
legend.tangentialAccelVariancevalue = "tangentialAccelVariance"
legend.tangentialAccelerationvalue = "tangentialAcceleration"
legend.texturename = "textureFileName"

local function pexConverter( filename )
	print( "Parsing PEX file " .. filename )

	local parser = xml.new()

	local tmp2 = parser:loadFile( filename )
	--table.print_r(tmp2)
	local tmp3 = {}
	for i = 1, #tmp2.child do
		for k,v in pairs( tmp2.child[i].properties ) do
			tmp3[tmp2.child[i].name .. tostring(k)] = v
		end
	end
	--table.dump(tmp3)

	for k, v in pairs(legend) do
		if(tmp3[k]) then
			tmp3[v] = tmp3[k]
			tmp3[k] = nil
		end
	end

	for k,v in pairs( tmp3 ) do
		if( tonumber( v ) ) then
			tmp3[k] = tostring( round(v,2) )
		end
	end

	tmp3.configName = "dummy"

	--table.dump(tmp3)

	return tmp3
end


return pexConverter