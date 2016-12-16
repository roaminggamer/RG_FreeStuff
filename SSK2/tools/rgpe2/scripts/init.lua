-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
-- Useful Localizations
local getTimer          = system.getTimer
local mRand				= math.random
local tpd 				= timer.performWithDelay

local common 	= require "scripts.common"

local init = {}

-- =============================================================
-- Initialization
-- =============================================================
function init.run()
	init.lookAndFeel()
	init.emitterLib()
end

-- =============================================================
-- Set up the look and feel settings
-- =============================================================
function init.lookAndFeel()
	-- Default Background Color
	display.setDefault( "background", unpack(common.backgroundColor))
end

-- =============================================================
-- Load (or create) the emitter library.
-- =============================================================
function init.emitterLib()

-- Load or Create Emitter Library
common.emitterLibrary = table.load( "emitterLib.json" ) 
	local names = 
	{
		"Pixie Dust",
		"Candlewick",
		"Fire Swirl",
		"Collapsing Nebula",
		"Firefall 1",
		"Nebulon",
		"Skull Spiral",
		"Galactic Demise",
		"Firefall 2",
		"Healing",
		"Damaging"
	}

	if( not common.emitterLibrary ) then
		local tmp = table.load( "data/defaultEmitterLibrary.json", system.ResourceDirectory ) 
		common.emitterLibrary = {}
		for i = 1, #tmp do
			print(names[i])
			common.emitterLibrary[i] = {}
			common.emitterLibrary[i].name = names[i]
			common.emitterLibrary[i].definition = tmp[i]
			common.emitterLibrary[i].id = math.getUID(15)

			-- Save aside the second emitter definition as the default 'new emitter'
			if( i == 2 ) then
				local tmp2 = table.deepCopy( common.emitterLibrary[i] )
				tmp2.name = "Emitter"
				table.save( tmp2, "defaultNewEmitter.json" )
			end

		end
		table.save( common.emitterLibrary, "emitterLib.json" ) 
		--table.dump(common.emitterLibrary[1])
	end
	common.defaultNewEmitter = table.load( "defaultNewEmitter.json" )

	-- Set 'initial' emitter record to a dummy record 
	common.curEmitterRec 	= { definition = {} }
	common.curObject 		= nil
end


local function onExportProject( event )
	local RGFiles = ssk.files
	local util = require "scripts.util"

	local curProject = common.curProject
	local content = curProject.content

	-- Create folders for our export
	local saveFolder = RGFiles.desktop.getDesktopPath( "RGPE2_out" )
	RGFiles.util.mkFolder( saveFolder )
	--RGFiles.util.mkFolder( saveFolder .. "/images" )
	--local particlesFolder = saveFolder .. "/images/particles"
	--RGFiles.util.mkFolder( particlesFolder )

	for i = 1, #content do
		local entry = content[i]
		--table.dump(entry)
		if( entry.isType == "emitter" ) then
			local record = util.getEmitterRecord( entry.id )

			local definition = table.deepCopy( record.definition )
			local srcParticle = RGFiles.resource.getPath( definition.textureFileName )
			local dstParticle = srcParticle
			dstParticle = RGFiles.util.repairPath( dstParticle, true )
			--print(srcParticle)
			--print(dstParticle)
			dstParticle = string.split( dstParticle, "/" )		
			--table.dump(dstParticle)		
			dstParticle = dstParticle[#dstParticle]				
			--print(dstParticle)
			definition.textureFileName = dstParticle

			-- Save particle definition to 
			local path = string.format( "%s/%s.json", saveFolder, io.cleanFileName(record.name) )
			RGFiles.util.saveTable( definition, path )

			--table.dump(record.definition)
			
			RGFiles.util.cpFile( srcParticle, saveFolder .. "/" .. dstParticle )

		elseif( entry.isType == "image" ) then
			local record = util.getImageRecord( entry.id )
		end			
	end

end; listen( "onExportProject", onExportProject )


return init