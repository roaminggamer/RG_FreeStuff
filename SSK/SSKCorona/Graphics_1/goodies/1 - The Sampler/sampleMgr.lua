-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- SSKCorona Sampler Manager
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
-- 
-- =============================================================


--[[ 
--]]

local theMgr = {}
--local theMgr_mt = { __index = theMgr }
--setmetatable( theMgr, theMgr_mt )

theMgr.Categories = {}
--theMgr.Categories[#theMgr.Categories+1] = "Mechanics"
--theMgr.Categories[#theMgr.Categories+1] = "Games"

theMgr.subCategories = {}


theMgr.samples = {}

theMgr.totalSamples = 0

function theMgr:addSample( category, subcategory, samplePath, debugMode)

	local samplePath = "theSamples." .. samplePath

	if(debugMode == true) then
		local errorCheck = require(samplePath)
	end

	theMgr.totalSamples = theMgr.totalSamples +1

	-- 1. Make sure sample of same name is not already registered
	local sampleLookupName = category .. "_" .. subcategory

	if(self.samples[sampleLookupName]) then
		print("ERROR: You already have a sample '" .. subcategory .. 
		      "' in the category '" .. category .. "'")
		print("Try a new subcategory name.")
	end

	-- 2. Create the category if it does not exit.
	if(self.subCategories[category] == nil) then
		theMgr.Categories[#theMgr.Categories+1] = category
		self.subCategories[category] = {}
	end

	-- 3. Add the subcategory
	table.insert( self.subCategories[category], subcategory )

	-- 4. Add the sample path
	self.samples[sampleLookupName] = samplePath
end

function theMgr:getTotalSamples()
	return self.totalSamples
end


function theMgr:getCategories()
	return self.Categories
end

function theMgr:getCategoriesCount()
	return #self.Categories
end

function theMgr:getCategoriesEntryNum( category )
	for i=1, #self.Categories do
		if(self.Categories[i] == category) then
			return i
		end
	end
	return "err"
end


function theMgr:getSubcategories( category )
	return self.subCategories[category]
end

function theMgr:getSubcategoriesCount( category )
	return #self.subCategories[category]
end

function theMgr:getSubCategoriesEntryNum( category, subcategory )
	local subcategories = self:getSubcategories( category )
	for i=1, #subcategories do
		if(subcategories[i] == subcategory) then
			return i
		end
	end
	return "err"
end


function theMgr:getSamplePath( category, subcategory )
	local sampleLookupName = category .. "_" .. subcategory
	return self.samples[sampleLookupName]
end

function theMgr:getRandomSamplePath( )
	local tmpSamples = {}
	for k,v in pairs( self.samples ) do
		tmpSamples[#tmpSamples+1] = v
	end
	return( tmpSamples[math.random(1,#tmpSamples)] )
end

return theMgr