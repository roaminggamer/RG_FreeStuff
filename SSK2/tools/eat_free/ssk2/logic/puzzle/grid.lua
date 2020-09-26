-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- grid.lua
-- =============================================================
-- Grid builder with support for logic used in combination and jigsaw puzzles.
-- =============================================================

local public = {}
_G.ssk = _G.ssk or {}
_G.ssk.logic = _G.ssk.logic or {}
_G.ssk.logic.grid = public


function public.createImageGrid( group, x, y, filename, params )
	-- print(group, x, y, filename, params )
	group = group or display.currentStage
	params = params or {}	
	--table.dump(params)
	local rows 			= params.rows or 2
	local cols 			= params.cols or 2
	local width 		= params.w or 100
	local height 		= params.h or 100
	local baseDir 		= params.baseDir or system.ResourceDirectory
	local destroyLast   = fnn(params.destroyLast, false)
	--
	--
	local gridGroup = display.newGroup()
	group:insert(gridGroup)
	--
	local slices 	= {}
	local sliceH 	= height/rows
	local sliceW 	= width/cols
	--
	local startX 	= -width/2
	local startY 	= -height/2
	local endX 		= width/2
	local endY 		= height/2
	--
	local function getAllInRowSorted( row )
		local all = {}
		for k,v in pairs(slices) do
			if( v.row == row ) then
				all[#all+1] = v
			end
		end
		local function compare( a, b )
    		return a.col < b.col
		end
		table.sort( all, compare )
		return all
	end
	local function getAllInColSorted( col )
		local all = {}
		for k,v in pairs(slices) do
			if( v.col == col ) then
				all[#all+1] = v
			end
		end
		local function compare( a, b )
    		return a.row < b.row
		end
		table.sort( all, compare )
		return all
	end
	--
	local function canSlideRight( self )
		if( self.sliding ) then return false end
		if(self.col == cols) then return false end
		local all = getAllInRowSorted( self.row )
		local found = false
		local targetCol = self.col + 1
		for i = 1, #all do
			if( found ) then
				if( all[i].col == targetCol ) then 
					return false 
				end
			end
			if( all[i] == self ) then
				found = true
			end
		end		
		return true
	end

	local function canSlideLeft( self )
		if( self.sliding ) then return false end
		if(self.col == 1) then return false end
		local all = getAllInRowSorted( self.row )
		local found = false
		local targetCol = self.col - 1
		for i = #all, 1, -1 do
			if( found ) then
				if( all[i].col == targetCol ) then 
					return false 
				end
			end
			if( all[i] == self ) then
				found = true
			end
		end		
		return true
	end

	local function canSlideUp( self )
		if( self.sliding ) then return false end
		if(self.row == 1) then return false end
		local all = getAllInColSorted( self.col )
		local found = false
		local targetRow = self.row - 1
		for i = #all, 1, -1 do
			if( found ) then
				if( all[i].row == targetRow ) then 
					return false 
				end
			end
			if( all[i] == self ) then
				found = true
			end
		end		
		return true
	end

	local function canSlideDown( self )
		if( self.sliding ) then return false end
		if(self.row == rows) then return false end
		local all = getAllInColSorted( self.col )
		local found = false
		local targetRow = self.row + 1
		for i = 1, #all do
			if( found ) then
				if( all[i].row == targetRow ) then 
					return false 
				end
			end
			if( all[i] == self ) then
				found = true
			end
		end		
		return true
	end 
	--
	-- slideParams ==> { slideRate, slideEasing, onMoveComplete }
	local function slideRight( self, slideParams )
		slideParams = slideParams or {}
		self.col = self.col + 1
		if( slideParams.slideRate ) then			
			self.sliding = true
			local function onComplete()
				self.sliding = false
				if(slideParams.onMoveComplete) then slideParams.onMoveComplete() end
			end
			transition.to( self, { x = self.x + sliceW, time = 1000 * sliceW/slideParams.slideRate, transition = slideParams.slideEasing, onComplete = onComplete } )
			
		else
			self.x = self.x + sliceW
			if(slideParams.onMoveComplete) then slideParams.onMoveComplete() end
		end
	end

	local function slideLeft( self, slideParams )
		slideParams = slideParams or {}
		self.col = self.col - 1
		if( slideParams.slideRate ) then			
			self.sliding = true
			local function onComplete()
				self.sliding = false
				if(slideParams.onMoveComplete) then slideParams.onMoveComplete() end
			end
			transition.to( self, { x = self.x - sliceW, time = 1000 * sliceW/slideParams.slideRate, transition = slideParams.slideEasing, onComplete = onComplete } )
		else
			self.x = self.x - sliceW
			if(slideParams.onMoveComplete) then slideParams.onMoveComplete() end
		end
	end

	local function slideUp( self, slideParams )
		slideParams = slideParams or {}
		self.row = self.row - 1
		if( slideParams.slideRate ) then			
			self.sliding = true
			local function onComplete()
				self.sliding = false
				if(slideParams.onMoveComplete) then slideParams.onMoveComplete() end
			end
			transition.to( self, { y = self.y - sliceH, time = 1000 * sliceH/slideParams.slideRate, transition = slideParams.slideEasing, onComplete = onComplete } )
		else
			self.y = self.y - sliceH
			if(slideParams.onMoveComplete) then slideParams.onMoveComplete() end
		end
	end

	local function slideDown( self, slideParams )
		slideParams = slideParams or {}
		self.row = self.row + 1
		if( slideParams.slideRate ) then			
			self.sliding = true
			local function onComplete()
				self.sliding = false
				if(slideParams.onMoveComplete) then slideParams.onMoveComplete() end
			end
			transition.to( self, { y = self.y + sliceH, time = 1000 * sliceH/slideParams.slideRate, transition = slideParams.slideEasing, onComplete = onComplete } )
			
		else
			self.y = self.y + sliceH
			if(slideParams.onMoveComplete) then slideParams.onMoveComplete() end
		end
	end
	--
	local function pushRight( self, slideParams )
		slideParams = slideParams or {}
		-- print("pushRight", self.col)
		if( self.sliding ) then return false end
		local all = getAllInRowSorted(self.row)
		local atIndex = 1
		for i = 1, #all do			
			if( all[i] == self ) then
				atIndex = i
			end
		end
		local nextCol = self.col + 1
		local toSlide = {}
		for i = atIndex, #all do
			-- print( i, all[i].col, nextCol, nextCol - all[i].col )
			if(nextCol - all[i].col < 2 and nextCol - all[i].col >= 0 )  then
				nextCol = all[i].col + 1
				toSlide[#toSlide+1] = all[i]			
			end
		end
		-- print ('------------')
		for i = 1, #toSlide do
			-- table.dump( toSlide[i], tostring(i) ) 
			-- print( i, toSlide[i].col)
		end
		if(table.count(toSlide) == 0) then return false end
		if(toSlide[#toSlide].col == cols) then return false end
		for k,v in pairs(toSlide) do
			v:slideRight( slideParams )
		end
		return true
	end

	local function pushLeft( self, slideParams )
		slideParams = slideParams or {}
		-- print("pushLeft", self.col)
		if( self.sliding ) then return false end
		local all = getAllInRowSorted(self.row)
		local atIndex = 1
		for i = 1, #all do			
			if( all[i] == self ) then
				atIndex = i
			end
		end
		local nextCol = self.col - 1
		local toSlide = {}
		for i = atIndex, 1, -1 do
			-- print( i, all[i].col, nextCol, all[i].col - nextCol )
			if(all[i].col - nextCol > -2 and all[i].col - nextCol >= 0 )  then
				nextCol = all[i].col - 1
				toSlide[#toSlide+1] = all[i]			
			end
		end
		-- print ('------------')
		for i = 1, #toSlide do
			-- table.dump( toSlide[i], tostring(i) ) 
			-- print( i, toSlide[i].col)
		end
		if(table.count(toSlide) == 0) then return false end
		if(toSlide[#toSlide].col == 1) then return false end
		for k,v in pairs(toSlide) do
			v:slideLeft( slideParams )
		end
		return true
	end

	local function pushDown( self, slideParams )
		slideParams = slideParams or {}
		-- print("pushDown", self.row)
		if( self.sliding ) then return false end
		local all = getAllInColSorted(self.col)
		local atIndex = 1
		for i = 1, #all do			
			if( all[i] == self ) then
				atIndex = i
			end
		end
		local nextRow = self.row + 1
		local toSlide = {}
		for i = atIndex, #all do
			-- print( i, all[i].row, nextCol, nextRow - all[i].row )
			if(nextRow - all[i].row < 2 and nextRow - all[i].row >= 0 )  then
				nextRow = all[i].row + 1
				toSlide[#toSlide+1] = all[i]			
			end
		end
		-- print ('------------')
		for i = 1, #toSlide do
			-- table.dump( toSlide[i], tostring(i) ) 
			-- print( i, toSlide[i].col)
		end
		if(table.count(toSlide) == 0) then return false end
		if(toSlide[#toSlide].row == rows) then return false end
		for k,v in pairs(toSlide) do
			v:slideDown( slideParams )
		end
		return true
	end

 	local function pushUp( self, slideParams )
 		slideParams = slideParams or {}
		-- print("pushLeft", self.row)
		if( self.sliding ) then return false end
		local all = getAllInColSorted(self.col)
		local atIndex = 1
		for i = 1, #all do			
			if( all[i] == self ) then
				atIndex = i
			end
		end
		local nextRow = self.row - 1
		local toSlide = {}
		for i = atIndex, 1, -1 do
			-- print( i, all[i].row, nextRow, all[i].row - nextRow )
			if(all[i].row - nextRow > -2 and all[i].row - nextRow >= 0 )  then
				nextRow = all[i].row - 1
				toSlide[#toSlide+1] = all[i]			
			end
		end
		-- print ('------------')
		for i = 1, #toSlide do
			-- table.dump( toSlide[i], tostring(i) ) 
			-- print( i, toSlide[i].row)
		end
		if(table.count(toSlide) == 0) then return false end
		if(toSlide[#toSlide].row == 1) then return false end
		for k,v in pairs(toSlide) do
			v:slideUp( slideParams )
		end
		return true
	end
	--
	local slice	
	for i = 1, rows do
		for j = 1, cols do
			-- print( i, j )
			slice = display.newContainer( sliceW, sliceH )
			gridGroup:insert(slice)
			slice.x = startX + (j-1) * sliceW + sliceW/2
			slice.y = startY + (i-1) * sliceH + sliceH/2
			-- print( i, j, slice.x, slice.y )
			-- slice.anchorX = 0
			-- slice.anchorY = 0
			local img = display.newImageRect( slice, filename, baseDir, width, height )
			img.anchorX 		= 0
			img.anchorY 		= 0
			img.x 				= -sliceW/2 - (j-1) * sliceW
			img.y 				= -sliceH/2 - (i-1) * sliceH
			slices[slice] 		= slice	
			slice.slices 		= slices
			slice.img 			= img
			slice.row 			= i
			slice.col 			= j
			slice.row0 			= i
			slice.col0 			= j
			slice.canSlideRight = canSlideRight
			slice.canSlideLeft 	= canSlideLeft
			slice.canSlideUp 	= canSlideUp
			slice.canSlideDown 	= canSlideDown
			slice.slideRight 	= slideRight
			slice.slideLeft 	= slideLeft
			slice.slideUp 		= slideUp
			slice.slideDown 	= slideDown
			slice.pushRight 	= pushRight
			slice.pushLeft		= pushLeft
			slice.pushDown		= pushDown
			slice.pushUp		= pushUp
			if(params.touch) then
				slice.touch = params.touch
				slice:addEventListener('touch')
			end
		end
	end
	if( destroyLast ) then
		slices[slice] = nl
		display.remove(slice)
	end
	function gridGroup.convertSlicesToObjectTable()
		local tmp = {}
		for i = 1, #slices do
			tmp[slices[i]] = slices[i]
		end
		slices = tmp
		gridGroup.slices = slices
	end

	function gridGroup.checkIfSolved()
		local isSolved = true
		for k,v in pairs(slices) do
			isSolved = isSolved and (v.row == v.row0) and (v.col == v.col0)
		end
		return isSolved
	end

	function gridGroup.shuffle( numTimes )
		numTimes = numTimes or (rows * cols)
		for i = 1, numTimes do
			local a = table.getRandom(slices)
			local b = table.getRandom(slices)
			local x,y,row,col = b.x, b.y,b.row,b.col
			b.x = a.x
			b.y = a.y
			b.row = a.row
			b.col = a.col
			a.x = x
			a.y = y
			a.row = row
			a.col = col
		end
	end
	--
	--
	gridGroup.x = x
	gridGroup.y = y
	gridGroup.slices = slices
	--
	return gridGroup
end

return public