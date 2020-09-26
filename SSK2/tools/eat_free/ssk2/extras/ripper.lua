-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
--[[
ssk.ripper.vertical( nil, display.contentCenterX - 200, display.contentCenterY - 150, "images/cave.png",
       { w = 300, h = 240, sliceTime = 100, time = 100, numSlices = 5 } )

ssk.ripper.vertical( nil, display.contentCenterX + 200, display.contentCenterY - 150, "images/bruges.png",
       { w = 300, h = 240, sliceDelay = 50, numSlices = 21, sliceEasing = easing.inQuad } )



ssk.ripper.horizontal( nil, display.contentCenterX - 200, display.contentCenterY + 150, "images/cave.png",
       { w = 300, h = 240, sliceTime = 100, time = 100, numSlices = 5 } )

ssk.ripper.horizontal( nil, display.contentCenterX + 200, display.contentCenterY + 150, "images/bruges.png",
       { w = 300, h = 240, sliceDelay = 50, numSlices = 21, sliceEasing = easing.inQuad } )
]]

local ripper = {}
_G.ssk = _G.ssk or {}
_G.ssk.ripper = ripper


function ripper.horizontal( group, x, y, filename, params )
	print(group, x, y, filename, params )
	group = group or display.currentStage
	params = params or {}	
	--table.dump(params)
	local numSlices 	= params.numSlices or 3
	local width 		= params.w or 100
	local height 		= params.h or 100
	local baseDir 		= params.baseDir or system.ResourceDirectory
	local delay 		= params.delay or 500
	local sliceDelay	= params.sliceDelay or 150
	local time 			= params.time or 1000
	local sliceTime	= params.sliceTime or 0
	local sliceEasing = params.sliceEasing or easing.linear
	local autoDestroy = fnn(params.autoDestroy, true)
	--
	local sliceGroup = display.newGroup()
	group:insert(sliceGroup)
	--
	local slices = {}
	local sliceH = height/numSlices
	--
	local startY = -height/2
	for i = 1, numSlices do		
		local slice = display.newContainer( width, sliceH )
		sliceGroup:insert(slice)
		slice.x = 0
		slice.y = startY + (i-1) * sliceH
		slice.anchorY = 0
		local img = display.newImageRect( slice, filename, baseDir, width, height )
		img.anchorY = 0
		img.y = -sliceH/2 - (i-1) * sliceH
		slices[#slices+1] = slice	
		slice.img = img	
	end
	--
	local function onComplete()
		if( autoDestroy ) then display.remove( sliceGroup ) end
		if(params.onComplete) then params.onComplete() end
	end
	--
	for i = 1, #slices do
		if(i%2==0) then
			transition.to( slices[i].img, { x = -width, 
												delay = delay + i * sliceDelay, 
												time = time + i * sliceTime, 
												transition = sliceEasing,
												onComplete = (i==#slices) and onComplete } )
		else
			transition.to( slices[i].img, { x = width, 
												delay = delay + i * sliceDelay, 
												time = time + i * sliceTime, 
												transition = sliceEasing,
												onComplete = (i==#slices) and onComplete } )
		end
	end
	--
	sliceGroup.x = x
	sliceGroup.y = y
	sliceGroup.slices = slices
	--
	return sliceGroup
end

function ripper.vertical( group, x, y, filename, params )
	print(group, x, y, filename, params )
	group = group or display.currentStage
	params = params or {}	
	--table.dump(params)
	local numSlices 	= params.numSlices or 3
	local width 		= params.w or 100
	local height 		= params.h or 100
	local baseDir 		= params.baseDir or system.ResourceDirectory
	local delay 		= params.delay or 500
	local sliceDelay	= params.sliceDelay or 150
	local time 			= params.time or 1000
	local sliceTime	= params.sliceTime or 0
	local sliceEasing = params.sliceEasing or easing.linear
	local autoDestroy = fnn(params.autoDestroy, true)
	--
	local sliceGroup = display.newGroup()
	group:insert(sliceGroup)
	--
	local slices = {}
	local sliceW = width/numSlices
	--
	local startX = -width/2
	for i = 1, numSlices do		
		local slice = display.newContainer( sliceW, height )
		sliceGroup:insert(slice)
		slice.x = startX + (i-1) * sliceW
		slice.y = 0
		slice.anchorX = 0
		local img = display.newImageRect( slice, filename, baseDir, width, height )
		img.anchorX = 0
		img.x = -sliceW/2 - (i-1) * sliceW
		slices[#slices+1] = slice	
		slice.img = img	
	end
	--
	local function onComplete()
		if( autoDestroy ) then display.remove( sliceGroup ) end
		if(params.onComplete) then params.onComplete() end
	end
	--
	for i = 1, #slices do
		if(i%2==0) then
			transition.to( slices[i].img, { y = -height, 
												delay = delay + i * sliceDelay, 
												time = time + i * sliceTime, 
												transition = sliceEasing,
												onComplete = (i==#slices) and onComplete } )
		else
			transition.to( slices[i].img, { y = height, 
												delay = delay + i * sliceDelay, 
												time = time + i * sliceTime, 
												transition = sliceEasing,
												onComplete = (i==#slices) and onComplete } )
		end
	end
	--
	sliceGroup.x = x
	sliceGroup.y = y
	sliceGroup.slices = slices
	--
	return sliceGroup
end


function ripper.grid( group, x, y, filename, params )
	print(group, x, y, filename, params )
	group = group or display.currentStage
	params = params or {}	
	--table.dump(params)
	local rows 			= params.rows or 2
	local cols 			= params.cols or 2
	local width 		= params.w or 100
	local height 		= params.h or 100
	local baseDir 		= params.baseDir or system.ResourceDirectory
	local delay 		= params.delay or 500
	local sliceDelay	= params.sliceDelay or 150
	local time 			= params.time or 1000
	local sliceTime		= params.sliceTime or 0
	local sliceEasing 	= params.sliceEasing or easing.linear
	local autoDestroy 	= fnn(params.autoDestroy, true)
	local effect 		= fnn(params.effect, "standard")
	--
	local sliceGroup = display.newGroup()
	group:insert(sliceGroup)
	--
	local slices = {}
	local sliceH = height/rows
	local sliceW = width/cols
	--
	local startX = -width/2
	local startY = -height/2
	for i = 1, rows do
		for j = 1, cols do
			-- print( i, j )
			local slice = display.newContainer( sliceW, sliceH )
			sliceGroup:insert(slice)
			slice.x = startX + (j-1) * sliceW
			slice.y = startY + (i-1) * sliceH
			print( i, j, slice.x, slice.y )
			slice.anchorX = 0
			slice.anchorY = 0
			local img = display.newImageRect( slice, filename, baseDir, width, height )
			img.strokeWidth = 3
			img.anchorX = 0
			img.anchorY = 0
			img.x = -sliceW/2 - (j-1) * sliceW
			img.y = -sliceH/2 - (i-1) * sliceH
			slices[#slices+1] = slice	
			slice.img = img
			slice.row = i
			slice.col = j	
		end
	end
	--
	if( effect == "standard" ) then
	else
	end
	--
	sliceGroup.x = x
	sliceGroup.y = y
	sliceGroup.slices = slices
	--
	return sliceGroup
end
return ripper
