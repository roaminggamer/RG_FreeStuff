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


-- ==
--    func() - what it does
-- ==
function displayBuilders.backImage( group, imageFile )
	local group = group or display.currentStage
	local imageFile = imageFile or "protoBack.png"
	local image = display.newImage( imagesDir .. "interface/" .. imageFile )
	group:insert( image, true )
	image.x = w/2
	image.y = h/2
	if(system.orientation == "landscapeRight") then
		image.rotation = 90
	end
	return image
end


-- ==
--    func() - what it does
-- ==
function displayBuilders.quitButton( callback, group )
	local group = group or display.currentStage
	local quitButton = ssk.buttons:new 
	{
		unselImg = imagesDir .. "homeButtonRed.png",
		selImg = imagesDir .. "homeButtonRedOver.png",
		x = w-16,
		y = 16,
		w = 32,
		h = 32,
		fontSize = 30,
		onRelease = callback,
		text = "",
		scaleFont = true,
		textOffset = {0,0},
	}
	group:insert(quitButton)

	return quitButton
end
