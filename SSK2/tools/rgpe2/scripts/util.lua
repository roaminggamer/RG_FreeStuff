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

local util = {}

-- =============================================================
-- Get an image record (if it can be found)
-- =============================================================
function util.getImageRecord( id_name )
	local imageSelector = require "scripts.imageSelector"
	local knownImages = imageSelector.getKnownImages( )
	--table.dump(knownImages[1])
	for i = 1, #knownImages do
		if( knownImages[i].id and knownImages[i].id == id_name ) then
			return knownImages[i]
		end
	end
	for i = 1, #knownImages do
		if( knownImages[i].name and knownImages[i].name == id_name ) then
			return knownImages[i]
		end
	end	
	return nil
end

-- =============================================================
-- Get an emitter record (if it can be found)
-- =============================================================
function util.getEmitterRecord( id )
	for i = 1, #common.emitterLibrary do
		if( common.emitterLibrary[i].id == id ) then 
			return common.emitterLibrary[i]
		end
	end
	return nil
end

return util