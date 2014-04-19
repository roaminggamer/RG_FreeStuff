local particleDesigner = {}

local json = require( "json" )

function particleDesigner.newEmitter( fileName, textureFileName, baseDir )

	local filePath = system.pathForFile( fileName, baseDir )
	--print(filePath)

	local f = io.open( filePath, "r" )
	local fileData = f:read( "*a" )
	f:close()

	local emitterParams = json.decode( fileData )
	emitterParams.textureFileName = textureFileName

	for k,v in pairs(emitterParams) do		
		emitterParams[k] = tonumber(v) or v
		--print(k,emitterParams[k])
	end

	local emitter = display.newEmitter( emitterParams )

	return emitter
end

return particleDesigner
