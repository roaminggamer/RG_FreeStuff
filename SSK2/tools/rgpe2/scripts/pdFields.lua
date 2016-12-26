-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
local pdFields = {}


-- =============================================================
-- EMITTERS
-- =============================================================

--configName="Some String"

-- Basic Emitter Settings
local basic = {}
pdFields.basic 	= basic
basic.title 	= "Emitter Settings - Basic"
basic[1] 		= { attrName = "maxParticles", displayName = "Max Particles", min = 1, max = 2000, decimalPoints = 0 }
basic[2] 		= { attrName = "duration", displayName = "Duration", min = -1.0, max = 6000.00, decimalPoints = 4 }
basic[3] 		= { attrName = "sourcePositionVariancex", displayName = "X Variance", min = 0, max = 2048, decimalPoints = 0 }
basic[4] 		= { attrName = "sourcePositionVariancey", displayName = "Y Variance", min = 0, max = 2048, decimalPoints = 0 }
basic[5] 		= { attrName = "angle", displayName = "Angle", min = 0.00, max = 360.00, decimalPoints = 2 }
basic[6] 		= { attrName = "angleVariance", displayName = "Angle Variance", min = -360.00, max = 360.00, decimalPoints = 2 }
basic[7] 		= { attrName = "emitterType", displayName = "Emitter Type", min = 0, max = 1, decimalPoints = 0, type = "dropdown",
                    choices = { { 0, "Gravity" }, { 1, "Radial" } } } 
--basic[8] 		= { attrName = "sourcePositionx", displayName = "X Position", min = 0, max = 2048, decimalPoints = 0 }
--basic[9] 		= { attrName = "sourcePositiony", displayName = "Y Position", min = 0, max = 2048, decimalPoints = 0 }

-- Gravity Emitter Sub-settings
local gravity = {}
pdFields.gravity = gravity
gravity.title 	= "Emitter Settings - Gravity"
gravity[1] 		= { attrName = "gravityx", displayName = "X Gravity", min = -2000.00, max = 2000.00, decimalPoints = 2 }
gravity[2] 		= { attrName = "gravityy", displayName = "Y Gravity", min = -2000.00, max = 2000.00, decimalPoints = 2 }
gravity[3] 		= { attrName = "speed", displayName = "Speed", min = 0, max = 2000, decimalPoints = 0 }
gravity[4] 		= { attrName = "speedVariance", displayName = "Speed Variance", min = 0, max = 2000, decimalPoints = 0 }
gravity[5] 		= { attrName = "radialAcceleration", displayName = "Radial Acceleration", min = -2000.00, max = 2000.00, decimalPoints = 2 }
gravity[6] 		= { attrName = "radialAccelVariance", displayName = "Radial Accel Variance", min = -2000.00, max = 2000.00, decimalPoints = 2 }
gravity[7] 		= { attrName = "tangentialAcceleration", displayName = "Tangential Acceleration", min = -2000.00, max = 2000.00, decimalPoints = 2 }
gravity[8] 		= { attrName = "tangentialAccelVariance", displayName = "Tangential Accel Variance", min = -2000.00, max = 2000.00, decimalPoints = 2 }

-- Radial Emitter Sub-settings
local radial = {}
pdFields.radial = radial
radial.title 	= "Emitter Settings - Radial"
radial[1] 		= { attrName = "minRadius", displayName = "Min Radius", min = 0.00, max = 1000.00, decimalPoints = 2 }
radial[2]      	= { attrName = "minRadiusVariance", displayName = "Min Radius Variance", min = 0.00, max = 1000.00, decimalPoints = 2 }
radial[3]       = { attrName = "maxRadius", displayName = "Max Radius", min = 0.00, max = 1000.00, decimalPoints = 2 }
radial[4]      	= { attrName = "maxRadiusVariance", displayName = "Max Radius Variance", min = 0.00, max = 1000.00, decimalPoints = 2 }
radial[5] 		= { attrName = "rotatePerSecond", displayName = "Rotations Per Second", min = -1000.00, max = 1000.00, decimalPoints = 2 }
radial[6] 		= { attrName = "rotatePerSecondVariance", displayName = "Rotations Variance", min = -1000.00, max = 1000.00, decimalPoints = 2 }

-- Particle Settings
local particle = {}
pdFields.particle = particle
particle.title 	= "Particle Settings"
particle[1] 	= { attrName = "particleLifespan", displayName = "Lifespan", min = 0.05, max = 10.00, decimalPoints = 2 }
particle[2] 	= { attrName = "particleLifespanVariance", displayName = "Lifespan Variance", min = 0.0, max = 10.00, decimalPoints = 2 }
particle[3] 	= { attrName = "startParticleSize", displayName = "Start Size", min = 0.00, max = 512.00, decimalPoints = 2 }
particle[4] 	= { attrName = "startParticleSizeVariance", displayName = "Start Size Variance", min = 0.00, max = 512.00, decimalPoints = 2 }
particle[5] 	= { attrName = "finishParticleSize", displayName = "Finish Size", min = 0.00, max = 512.00, decimalPoints = 2 }
particle[6] 	= { attrName = "finishParticleSizeVariance", displayName = "Finish Size Variance", min = 0.00, max = 512.00, decimalPoints = 2 }
particle[7] 	= { attrName = "rotationStart", displayName = "Rotation Start", min = 0.00, max = 360.00, decimalPoints = 2 }
particle[8] 	= { attrName = "rotationStartVariance", displayName = "Rotation Start Variance", min = 0.00, max = 360.00, decimalPoints = 2 }
particle[9] 	= { attrName = "rotationEnd", displayName = "Rotation End", min = 0.00, max = 7200.00, decimalPoints = 2  }
particle[10] 	= { attrName = "rotationEndVariance", displayName = "Rotation End Variance", min = 0.00, max = 7200.00, decimalPoints = 2 }


local color = {}
pdFields.color = color
color.title 	= "Alpha & Blending"
color[1] 		= { attrName = "startColorAlpha", displayName = "Start Alpha", min = 0.00, max = 1.00, decimalPoints = 2}
color[2] 		= { attrName = "startColorVarianceAlpha", displayName = "Start Alpha Variance", min = 0.00, max = 1.00, decimalPoints = 2}
color[3] 		= { attrName = "finishColorAlpha", displayName = "Finish Alpha", min = 0.00, max = 1.00, decimalPoints = 2}
color[4] 		= { attrName = "finishColorVarianceAlpha", displayName = "Finish Alpha Variance", min = 0.00, max = 1.00, decimalPoints = 2}
color[5] 		= { attrName = "blendFuncSource", displayName = "Source Blending", min = 1, max = 5, decimalPoints = 0, type = "dropdown",
                    choices = { { 0, "Zero" }, { 1, "One" }, { 768, "Source" }, { 769, "One - Source" }, { 770, "Source - Alpha" }, } } 
color[6] 		= { attrName = "blendFuncDestination", displayName = "Destination Blending", min = 1, max = 5, decimalPoints = 0, type = "dropdown",
                    choices = { { 0, "Zero" }, { 1, "One" }, { 768, "Source" }, { 769, "One - Source" }, { 770, "Source - Alpha" }, } } 


local colorslide = {}
pdFields.colorslide = colorslide
colorslide.title 	= "Color Settings"
colorslide[1] 		= { attrName = "startColorRed", displayName = "Start Red", min = 0.00, max = 1.00, decimalPoints = 9}
colorslide[2] 		= { attrName = "startColorGreen", displayName = "Start Green", min = 0.00, max = 1.00, decimalPoints = 9}
colorslide[3] 		= { attrName = "startColorBlue", displayName = "Start Blue", min = 0.00, max = 1.00, decimalPoints = 9}

colorslide[4] 		= { attrName = "startColorVarianceRed", displayName = "Start Red Variance", min = 0.00, max = 1.00, decimalPoints = 9}
colorslide[5] 		= { attrName = "startColorVarianceGreen", displayName = "Start Green Variance", min = 0.00, max = 1.00, decimalPoints = 9}
colorslide[6] 		= { attrName = "startColorVarianceBlue", displayName = "Start Blue Variance", min = 0.00, max = 1.00, decimalPoints = 9}

colorslide[7] 		= { attrName = "finishColorRed", displayName = "Finish Red", min = 0.00, max = 1.00, decimalPoints = 9}
colorslide[8] 		= { attrName = "finishColorGreen", displayName = "Finish Green", min = 0.00, max = 1.00, decimalPoints = 9}
colorslide[9] 		= { attrName = "finishColorBlue", displayName = "Finish Blue", min = 0.00, max = 1.00, decimalPoints = 9}

colorslide[10] 		= { attrName = "finishColorVarianceRed", displayName = "Finish Color Variance", min = 0.00, max = 1.00, decimalPoints = 9}
colorslide[11] 		= { attrName = "finishColorVarianceGreen", displayName = "Finish Green Variance", min = 0.00, max = 1.00, decimalPoints = 9}
colorslide[12] 		= { attrName = "finishColorVarianceBlue", displayName = "Finish Blue Variance", min = 0.00, max = 1.00, decimalPoints = 9}

local colorslide2 = {}
pdFields.colorslide2 = colorslide2
colorslide2.title 	= "Alpha / Blend Settings"
colorslide2[1] 		= { attrName = "startColorAlpha", displayName = "Start Alpha", min = 0.00, max = 1.00, decimalPoints = 2}
colorslide2[2] 		= { attrName = "startColorVarianceAlpha", displayName = "Start Alpha Variance", min = 0.00, max = 1.00, decimalPoints = 2}
colorslide2[3] 		= { attrName = "finishColorAlpha", displayName = "Finish Alpha", min = 0.00, max = 1.00, decimalPoints = 2}
colorslide2[4] 		= { attrName = "finishColorVarianceAlpha", displayName = "Finish Alpha Variance", min = 0.00, max = 1.00, decimalPoints = 2}
colorslide2[5] 		= { attrName = "blendFuncSource", displayName = "Source Blending",min = 1, max = 5, decimalPoints = 0, type = "dropdown",
                        choices = { { 0, "Zero" }, { 1, "One" }, { 768, "Source" }, { 769, "One - Source" }, { 770, "Source - Alpha" }, } } 
colorslide2[6] 		= { attrName = "blendFuncDestination", displayName = "Destination Blending", min = 1, max = 5, decimalPoints = 0, type = "dropdown",
                        choices = { { 0, "Zero" }, { 1, "One" }, { 768, "Source" }, { 769, "One - Source" }, { 770, "Source - Alpha" }, } } 


local mRand = math.random

local function randomizeEmitter( emitter, name, locks  )

	local locks = locks or {}

	--table.dump(locks)

	if( (name == nil or name == "basic") and locks.basic ~= true ) then
		print("Randomize basic")
		emitter["duration"] = -1
		emitter["maxParticles"] = round(mRand(1, 500), 0) or 1
		emitter["emitterType"] = mRand(0,1)

		if(emitter.emitterType == 0) then
			emitter["sourcePositionVariancex"] = round(mRand(1, 100), 0) or 1
			emitter["sourcePositionVariancey"] = round(mRand(0, 100), 0) or 1
			emitter["angle"] = round(mRand(1, 3600)/100, 2) or 0
			emitter["angleVariance"] = round(mRand(1, 3600)/100, 2) or 0
		else
			emitter["sourcePositionVariancex"] = 0
			emitter["sourcePositionVariancey"] = 0
			emitter["angle"] = 360
			emitter["angleVariance"] = 360
		end
	end

	if( (name == nil or name == "gravity") and locks.gravity ~= true ) then
		print("Randomize gravity")
		emitter["gravityx"] = round(mRand(0, 10000)/100, 2) or 0
		emitter["gravityy"] = round(mRand(0, 10000)/100, 2) or 0
		emitter["speed"] = round(mRand(-10000, 10000)/100, 2) or 0
		emitter["speedVariance"] = round(mRand(-10000, 10000)/100, 2) or 0
		emitter["radialAcceleration"] = round(mRand(-10000, 10000)/100, 2) or 0
		emitter["radialAccelVariance"] = round(mRand(-10000, 10000)/100, 2) or 0
		emitter["tangentialAcceleration"] = round(mRand(-10000, 10000)/100, 2) or 0
		emitter["tangentialAccelVariance"] = round(mRand(-10000, 10000)/100, 2) or 0
	end

	if( (name == nil or name == "radial") and locks.radial ~= true ) then
		print("Randomize radial")
		emitter["maxRadius"] = round(mRand(0, 10000)/100, 2) or 0
		emitter["minRadius"] = round(mRand(0, 5000)/100, 2) or 0
		emitter["maxRadiusVariance"] = round(mRand(0, 10000)/100, 2) or 0
		emitter["minRadiusVariance"] = round(mRand(0, 5000)/100, 2) or 0
		emitter["rotatePerSecond"] = round(mRand(0, 10000)/100, 2) or 0
		emitter["rotatePerSecondVariance"] = round(mRand(0, 10000)/100, 2) or 0
	end

	if( (name == nil or name == "particle") and locks.particle ~= true ) then
		print("Randomize particle")
		emitter["particleLifespan"] = round(mRand(0, 1000)/100, 2) or 0.05
		emitter["particleLifespanVariance"] = round(mRand(0, 1000)/100, 2) or 0
		emitter["startParticleSize"] = round(mRand(0, 10000)/100, 2) or 1
		emitter["startParticleSizeVariance"] = round(mRand(0, 10000)/100, 2) or 1
		emitter["finishParticleSize"] = round(mRand(0, 10000)/100, 2) or 1
		emitter["finishParticleSizeVariance"] = round(mRand(0, 10000)/100, 2) or 1
		emitter["rotationStart"] = round(mRand(0, 360), 0) or 0
		emitter["rotationStartVariance"] = round(mRand(0, 360), 0) or 0
		emitter["rotationEnd"] = round(mRand(0, 360), 0) or 0
		emitter["rotationEndVariance"] = round(mRand(0, 360), 0) or 0
	end

	if( (name == nil or name == "color") and locks.color ~= true ) then
		print("Randomize color")

		local fields = pdFields.colorslide
		for i = 1, #fields do
			local data = fields[i]
			local attrName = data.attrName
			local val = round(mRand( 0, 1000000000)/1000000000,9)
			--print(data.min, data.max, data.decimalPoints, val, attrName)
			emitter[attrName] = val
		end

		local fields = pdFields.colorslide2
		for i = 1, #fields do
			if( i ~= 5 and i ~= 6 ) then
				local data = fields[i]
				local attrName = data.attrName
				local val = round(mRand( 0, 1000000000)/1000000000,9)
				--print(data.min, data.max, data.decimalPoints, val, attrName)
				emitter[attrName] = val
			end
		end
	end



	post( "onRefresh" )
	post( "onRefreshEmitter" )
end
pdFields.randomizeEmitter = randomizeEmitter


-- =============================================================
-- IMAGES
-- =============================================================

--configName="Some String"

-- Basic Emitter Settings
local image_basic = {}
pdFields.image_basic 	= image_basic
image_basic.title 	= "Image Settings - Basic"
image_basic[1] 		= { attrName = "x", displayName = "X", min = -fullw, max = fullw, decimalPoints = 0 }
image_basic[2] 		= { attrName = "y", displayName = "Y", min = -fullh, max = fullh, decimalPoints = 0 }
image_basic[3] 		= { attrName = "xScale", displayName = "X Scale", min = 0.1, max = 10, decimalPoints = 2 }
image_basic[4] 		= { attrName = "yScale", displayName = "Y Scale", min = 0.1, max = 10, decimalPoints = 2 }

return pdFields