-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- =============================================================
-- Localizations
-- =============================================================
-- Lua
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs
local strMatch = string.match; local strGSub = string.gsub; local strSub = string.sub
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale


-- =============================================
--  MODULE BEGINS
-- =============================================
local public = {}

-- Locals
local layers
local doubleClickTime = 350
local autoSaving = persist.get( "editorSettings.json", "autoSave" )
local currentBlock

-- Forward Declarations





local storyBlocks = {}
local arrows = {}

local blockSize = 120
local blockWidth = blockSize
local blockHeight = blockSize
local headerHeight = 25
local bodyBuffer = 5

local function isUUID( uid )
	for k,v in pairs( storyBlocks ) do
		if( v.uid == uid ) then
			return false
		end
	end 
	return true
end

local function markAllChanged()
	for k,v in pairs( storyBlocks ) do
		v._changed = true
	end
	return nil
end

local function findByUID( uid )
	for k,v in pairs( storyBlocks ) do
		if(v._data.uid == uid) then return v end
	end
	return nil
end

local function findByTitle( title )
	for k,v in pairs( storyBlocks ) do
		if(string.lower(v._data.title) == string.lower(title)) then return v end
	end
	return nil
end
local function countTitles( title )
	local count = 0
	for k,v in pairs( storyBlocks ) do
		if(string.lower(v._data.title) == string.lower(title)) then 
			count = count + 1
		end
	end
	return count
end

local function updateAll()
	for k,v in pairs(storyBlocks) do
		v:update()
	end
end

local function arrowStart( from, to )
	local fx = from.x
	local fy = from.y
	local tx = to.x
	local ty = to.y
	local fhw = from.contentWidth/2
	local fhh = from.contentHeight/2
	local thw = to.contentWidth/2
	local thh = to.contentHeight/2
	
	if( from.x + fhw < tx - thw ) then
		fx = fx + fhw
	elseif( from.x - fhw > tx + thw ) then
		fx = fx - fhw
	end

	if( from.y + fhh < ty - thh ) then
		fy = fy + fhh
	elseif( from.y - fhh > ty + thh ) then
		fy = fy - fhh
	end

	return fx, fy
end

local function arrowEnd( from, to )
	local fx = from.x
	local fy = from.y
	local tx = to.x
	local ty = to.y
	local fhw = from.contentWidth/2
	local fhh = from.contentHeight/2
	local thw = to.contentWidth/2
	local thh = to.contentHeight/2
	
	if( from.x + fhw < tx - thw ) then
		tx = tx - thw
	elseif( from.x - fhw > tx + thw ) then
		tx = tx + thw
	end

	if( from.y + fhh < ty - thh ) then
		ty = ty - thh
	elseif( from.y - fhh > ty + thh ) then
		ty = ty + thh
	end

	return tx, ty
end


-- ===============================================
-- Standard public Functions
-- ===============================================
function public.create( sceneGroup )
	sceneGroup = sceneGroup or display.currentStage
	layers = ssk.display.quickLayers( sceneGroup, "underlay", "content", "overlay" )
	storyBlocks = {}

	-- Handle Drag, Zoom, and Home Events
	--
	layers.content.x0 = layers.content.x
	layers.content.y0 = layers.content.y
	function layers.content.onEditDrag( self, event )
		if( autoIgnore( "onEditDrag", self ) ) then return false end
		self.x = self.x + event.dx --* self.xScale
		self.y = self.y + event.dy --* self.yScale
	end; listen( "onEditDrag", layers.content )

	function layers.content.onHome( self, event )
		if( autoIgnore( "onHome", self ) ) then return false end
		self.x = self.x0
		self.y = self.y0
		self.xScale = 1
		self.yScale = 1
	end; listen( "onHome", layers.content )

	function layers.content.onZoomOut( self, event )
		if( autoIgnore( "onZoomOut", self ) ) then return false end
		if( round(self.xScale,2) <= 0.51 ) then return end
		self:scale( 0.8, 0.8 )
		print(round(self.xScale,2))
	end; listen( "onZoomOut", layers.content )

	function layers.content.onZoomIn( self, event )
		if( autoIgnore( "onZoomIn", self ) ) then return false end
		if( round(self.xScale,2) >= 1.25 ) then return end
		self:scale( 1.25, 1.25 )
		print(round(self.xScale,2))
	end; listen( "onZoomIn", layers.content )

--	post("onEditDrag", { dx = dx, dy = dy } )

	--local back = newImageRect( layers.underlay, centerX, centerY, "images/fillT.png", { w = fullw, h = fullh } )
	--[[
	back.mouse = function( self, event )
		table.dump( event)
	end; listen("mouse",back)
	--]]

	--[[
	back.touch = function( self, event )
		table.dump( event)
	end; back:addEventListener("touch")
	--]]
	--local tmp = easyIFC:quickLabel( common.layers.content, "Count All Circles", centerX, centerY - 80, publicFont, 60  )


	local story = public.restore()
	--table.dump(story)

	if( not story ) then
		print("Story not found in documents, trying default story.")

		story = public.restore( { loadStarter = true } )
	
		--local start = public.newStoryBlock( left + 100, top + 100, { title = "Start", body = "Simple starter sample.\n[[exit 1|Page 2]]\n[[exit 2|Page 3]]", isStart = true } )
		--start:select()
		--local p2 = public.newStoryBlock( left + 250, top + 100, { title = "Page 2", body = "Body" } )
		--local p3 = public.newStoryBlock( left + 100, top + 250, { title = "Page 3", body = "Body" } )

		if( story ) then
			public.autoLink()
			public.save()
		end
	else 
		print("Story found in documents folder")

	end
	--timer.performWithDelay( 1000, function() public.purge( ) end )
	--timer.performWithDelay( 2000, function() public.restore( ) end )
end

local function extractLinks( body )
	local linkList
	if( string.find( body, "%[%[" ) ~= nil ) then
		--print(body)
		local list = string.split( body, "%[%[")
		linkList = {}
		for i = 1, #list do
			if( string.find( list[i], "%]%]" ) ~= nil ) then
				local entry = list[i]
				--print(entry)							
				--print("endcap == ", endcap, string.sub(entry, 1, endCap - 1))
				local endCap = string.find(entry, "%]%]") or string.len( entry )
				entry = string.sub(entry, 1, endCap - 1)
				entry = string.gsub( entry, "%]%]", "" )
				entry = string.gsub( entry, "\n", "" )
				entry = string.gsub( entry, "\r", "" )
				if( string.find(entry, "|") ~= nil ) then
					linkList[#linkList+1] = string.split( entry, "|" )
				else
					linkList[#linkList+1] = { entry, entry }
				end
			end
		end
		table.print_r(linkList)
	end

	return linkList
end

function public.autoLink()
	for k,v in pairs( storyBlocks ) do
		local titles = extractLinks(v._data.body)
		if( titles ) then
			v._data.leadsTo = {}
			for i = 1, #titles do
				local block = findByTitle( titles[i][2] )
				if( block ) then
					print("DOING ADD for title ", titles[i][2] )
					v:addLeadsTo( block )
				else
					local block = public.newStoryBlock( centerX, centerY, { title = titles[i][2] } )
					v:addLeadsTo( block )					
				end
			end
		end
	end
end

function public.editBlock( block )
	local eg = display.newGroup()
	eg.enterFrame = display.toFront
	listen("enterFrame", eg)
	local blocker = newImageRect( eg, centerX, centerY, "images/fillW.png", { alpha = 0.3, w = fullw, h = fullh, touch = function() return true end } )

	-- Create text field
	local onComplete = function( self )

		local onCloseBlockEdit
		local onEscape

		onCloseBlockEdit = function( event )

			local len = string.len( block._data.title )
			if( len == 0 ) then
				easyAlert("Title Too Short", "Please make the title at least one character long.", {{"OK",nil}})
				return
			end

			local count = countTitles( block._data.title )
			if( count > 1 ) then
				easyAlert("Duplicate Title", "Another title with same name found.  Titles must be unique.", {{"OK",nil}})
				return
			end

			ignore("enterFrame", eg)
			ignore("ON_KEY", onEscape)
			display.remove(eg)
			public.autoLink()
			markAllChanged()
			block:update()
			if( autoSaving ) then 
				updateAll()
				public.save() 
			end
		end
		onEscape = function( event )
			if( event.descriptor == "escape" and event.phase == "up" ) then
				onCloseBlockEdit()
			end 
			return true
		end
		listen("ON_KEY", onEscape)

		local function commonListener( self, event )
			table.dump(event)

		    if ( event.phase == "began" ) then
		        print( self.text )

		    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		        print( self.text )
		        block._data[self.fieldName] = self.text

		    elseif ( event.phase == "editing" ) then
		        print( event.newCharacters )
		        print( event.oldText )
		        print( event.startPosition )	        
		        print( event.text )
		        block._data[self.fieldName] = self.text
		    end
		end

		-- Title 
		local titleField = native.newTextField( self.x - 30, self.y - self.contentHeight/2 + 40, self.contentWidth - 100, 40 )
		eg:insert( titleField )
		titleField.userInput = commonListener
		titleField:addEventListener( "userInput" )
		titleField.fieldName = "title"
		titleField.text = block._data.title
		titleField.font = native.newFont( native.systemFontBold, 24 )

		local closebutton = easyIFC:presetPush( eg, "default", titleField.x + titleField.contentWidth/2 + 30, titleField.y, 35, 35, "X", onCloseBlockEdit)

		-- Body 
		local barHeight = 60
		local bh = self.contentHeight - 60 - titleField.contentHeight - barHeight - 20
		local bodyBox = native.newTextBox( self.x, titleField.y + titleField.contentHeight/2 + 20 + bh/2, self.contentWidth - 40, bh )
		eg:insert( bodyBox )
		bodyBox.isEditable = true
		bodyBox.userInput = commonListener
		bodyBox:addEventListener( "userInput" )
		bodyBox.fieldName = "body"
		bodyBox.text = block._data.body
		bodyBox.font = native.newFont( native.systemFont, 24 )


		-- Bottom Bar (placeholder)
		local bottomBar = newRect( eg, bodyBox.x, bodyBox.y + bodyBox.contentHeight/2 + 20 + barHeight/2, 
			                       { w = bodyBox.contentWidth, h = barHeight, cornerRadius = 4, stroke = _K_ } )

		native.setKeyboardFocus( titleField )
	end

	local editHeight = fullh * 0.6
	local editBack = newRect( eg, centerX, top + editHeight/2, { fill = _GREY_, h = editHeight - 20, w = fullw - 20, cornerRadius = 12, stroke = _DARKERGREY_, strokeWidth = 2 })
	editBack.xScale = 0.005
	editBack.yScale = 0.005
	transition.to(editBack, { xScale = 1, yScale = 1, time = 150, transition = easing.outCirc, onComplete = onComplete })

end

function public.newStoryBlock( x, y, params )
	params = params or {}
	group = layers.content
	local bs = 14 -- button size (delete and isStart)

	-- The block body
	--
	local block = newRect( group, x, y, { w = blockWidth, h = blockHeight, fill = _T_, stroke = _W_, strokeWidth = 2, isHitTestable = true })
	storyBlocks[block] = block
	block._arrows = {}
	block._data = {}
	block._data.title 	= params.title or "title" .. math.getUID(8)	
	block._data.body 	= params.body or "body"
	block._data.isStart 	= fnn(params.isStart, false)

	-- Assign a unique ID to this block
	--
	block._data.uid = params.uid or math.getUID( 5 )
	while( not isUUID( block._data.uid ) ) do
		block._data.uid = math.getUID( 20 )
	end
	block._data.leadsTo = {}

	-- Title Bar
	--
	block._titleRect = newRect( group, 0,0, { w = blockWidth, h = headerHeight, fill = _T_, stroke = _W_, strokeWidth = 2, anchorY = 0 })
	block._titleLabel = easyIFC:quickLabel( group, "", 0, 0, publicFont, 12  )

	-- Delete (me) button
	--
	local function doDel()
		block:destroy()
		if( autoSaving ) then public.save() end
		return true
	end
	block._delB = easyIFC:presetPush( group, "defaultcheck", 0, 0, bs, bs, "", doDel, { selImgFillColor = _R_ } )

	-- Delete (me) button
	--
	local function doIsHome()
		print("BOB")
		for k,v in pairs( storyBlocks ) do
			if( v._data.isStart ) then
				v._data.isStart = false
				v._data._changed = true
				v:update()
			end
		end
		block._data.isStart = true
		block._data._changed = true
		block:update()
		if( autoSaving ) then public.save() end
		--block:delete()
		return true
	end
	block._homeB = easyIFC:presetRadio( group, "defaultradio", 0, 0, bs, bs, "", doIsHome, { selImgFillColor = _G_ } )
	if( params.isStart ) then
		block._homeB:toggle(true)
	end


	-- Body Box
	--
	local options = 
	{
	    parent = group,
	    text = "",     
	    x = 0,
	    y = 0,
	    width = blockWidth - 2 * bodyBuffer,
	    height = blockHeight - headerHeight - 2 * bodyBuffer,
	    font = gameFont,   
	    fontSize = 12,
	}
	block._bodyLabel = display.newText( options )
	block._bodyLabel.anchorY = 1


	-- Block Methods
	--
	function block:addLeadsTo( toBlock )
		if( not toBlock ) then 
			print("ERROR? block:addLeadsTo()", toBlock )
			return 0 
		end
		local toUID = toBlock._data.uid
		print("addLeadsTo", self._data.title, self._data.uid, toBlock._data.title, toUID )
		local leadsTo = self._data.leadsTo
		if( not leadsTo[toUID] ) then
			leadsTo[toUID] = { count = 1 }
		else
			leadsTo[toUID].count = leadsTo[toUID].count + 1
		end

		self._changed = true

		return leadsTo[toUID].count
	end

	function block:removeLeadsTo( toBlock, clear )
		local toUID = toBlock._data.uid
		local leadsTo = self._data.leadsTo
		
		if( not leadsTo[toUID] ) then
			leadsTo[toUID] = { count = 1 }
		end
		
		if( clear ) then
			leadsTo[toUID].count = 0
		else
			leadsTo[toUID].count = leadsTo[toUID].count - 1
		end

		if( leadsTo[toUID].count < 0 ) then 
			leadsTo[toUID].count = 0
		end

		self._changed = true

		return leadsTo[toUID].count
	end


	function block:update()
		--table.dump(self._data,nil,"UPDATE")
		-- update Content
		self._titleLabel.text = self._data.title
		ssk.misc.fitText( self._titleLabel, self._data.title, blockWidth - 2 * bs - 20 )
		self._bodyLabel.text = self._data.body

		-- reposition parts
		self._titleRect.x = self.x
		self._titleRect.y = self.y - blockHeight/2
		self._titleLabel.x = self._titleRect.x
		self._titleLabel.y = self._titleRect.y + headerHeight/2

		block._delB.x = self._titleRect.x - blockWidth/2 + bs/2 + 5
		block._delB.y = self._titleRect.y + headerHeight/2
		block._homeB.x = self._titleRect.x + blockWidth/2 - bs/2 - 5
		block._homeB.y = self._titleRect.y + headerHeight/2

		self._bodyLabel.x = self.x 
		self._bodyLabel.y = self.y + blockHeight/2 - bodyBuffer

		self._titleRect:toFront()
		self._titleLabel:toFront()
		self._bodyLabel:toFront()
		self:toFront()
		block._delB:toFront()
		block._homeB:toFront()
		if( self._data.isStart ) then 
			self.strokeWidth = 4
			--self:setStrokeColor(unpack(_G_))
		else
			self.strokeWidth = 2
			--self:setStrokeColor(unpack(_W_))
		end		
	end

	function block:select()
		currentBlock = block
		self:setFillColor(1,1,1,0.2)
		self._selected = true
		self._changed = true
	end

	function block:deSelect()
		currentBlock = nil
		self:setFillColor(unpack(_T_))
		self._selected = false
		self._changed = true
	end


	function block:drawArrows()
		for k,v in pairs( self._arrows ) do
			display.remove(v)
		end
		self._arrows = {}

		for k,v in pairs( self._data.leadsTo ) do
			if(v.count > 0 ) then
				local to = findByUID( k )
				--print(to,l)
				if(to) then
					local fx,fy = arrowStart( self, to )
					local tx,ty = arrowEnd( self, to )			
					local vec = subVec( tx, ty, fx, fy, true )
					vec = normVec( vec )
					vec = scaleVec( vec, 10 )
					local tmp = ssk.display.arrow(self.parent, fx, fy, tx+vec.x, ty+vec.y )
					self._arrows[tmp] = tmp
				end
			end
		end
	end

	block.touch = function( self, event )
		if( event.phase == "began" ) then
			display.currentStage:setFocus( self, event.id )
			self.isFocus = true
			for k,v in pairs( storyBlocks ) do
				v:deSelect()
			end
			self:select()

			self.x0 = self.x
			self.y0 = self.y
			return true
		
		elseif( self.isFocus ) then

			local dx = event.x - event.xStart
			local dy = event.y - event.yStart
			self.x = self.x0 + dx
			self.y = self.y0 + dy
			markAllChanged()
			self:update()

			if( event.phase == "ended" ) then
				display.currentStage:setFocus( self, nil )
				self.isFocus = false

				-- Edit?
				self.lastTouchTime = self.lastTouchTime or getTimer()	
				local curTime = getTimer()
				local dt = curTime - self.lastTouchTime
				self.lastTouchTime = curTime
				if( dt > 0 and dt <= doubleClickTime ) then
					public.editBlock( self )
				end

				if( autoSaving ) then public.save() end
			end
			return true
		end
		return false
	end; block:addEventListener("touch")

	

	--table.dump(block)

	function block:destroy()
		ignore("enterFrame", self)		
		for k,v in pairs( self._arrows ) do
			display.remove(v)
		end
		display.remove(self._titleRect)
		display.remove(self._titleLabel)
		display.remove(self._bodyLabel)
		display.remove( self._delB )
		display.remove( self._homeB )
		
		display.remove(self)
		storyBlocks[self] = nil
		markAllChanged()
	end

	function block:enterFrame()
		if( autoIgnore( "enterFrame", self ) ) then return end
		if( not self._changed ) then return end
		self:drawArrows()
		self._changed = false
	end; listen("enterFrame", block)

	block:update()

	return block
end


function public.purge( )
	layers:purge("content")
	storyBlocks = {}
end


function public.save( params )
	local toSave = {}
	for k,v in pairs( storyBlocks ) do
		--table.dump(v)
		local tmp = {}
		toSave[#toSave+1] = tmp 
		tmp._data = table.deepCopy( v._data )
		for k,v in pairs( tmp._data.leadsTo ) do
			tmp._data.leadsTo[k] = k
		end

		tmp.x = v.x
		tmp.y = v.y
	end
	table.save( toSave, "testStory.json" )
end

function public.restore( params )
	params = params or {}
	public.purge()
	local toRestore

	if( params.loadStarter ) then
		toRestore = table.load( "data/starter.json", system.ResourceDirectory )
	else
		toRestore = table.load( "testStory.json" )
	end

	if( not toRestore ) then return nil end
	--table.print_r(toRestore)

	for k,v in pairs( toRestore ) do
		local d = v._data
		local tmp = public.newStoryBlock( v.x, v.y, { title = d.title, body = d.body, uid = d.uid, isStart = d.isStart } )
		if(d.isStart) then
			tmp:select()
		end
	end
	for k,v in pairs( toRestore ) do
		local d = v._data
		--table.dump(d)
		--table.dump(d.leadsTo)
		local from = findByUID( d.uid )
		for l,m in pairs( d.leadsTo ) do
			--print(l,m)
			local to = findByUID( l )
			---print(from,to,l)
			from:addLeadsTo( to )
		end
	end

	return toRestore

end

local function ON_KEY( event )
	if( event.descriptor == "s" and event.isCtrlDown and event.phase == "down" ) then
		public.save()
	elseif( event.descriptor == "p" and event.isCtrlDown and event.phase == "down" ) then
		public.purge()
	elseif( event.descriptor == "l" and event.isCtrlDown and event.phase == "down" ) then
		public.restore()
	end

	--table.dump(event)
	return false
end; listen( "ON_KEY", ON_KEY)


local function onDeleteSelected( event )
	if( currentBlock ) then
		currentBlock:destroy()
	end
end; listen( "onDeleteSelected", onDeleteSelected )

local function onToggleAutoSave( event )
	--table.dump(event.target)
	autoSaving = event.target:pressed()
	print(autoSaving)	
	
end; listen( "onToggleAutoSave", onToggleAutoSave )

local function onNewPage( event )
	public.newStoryBlock( centerX, centerY )
	if( autoSaving ) then public.save() end	
end; listen( "onNewPage", onNewPage )




 
return public