
-- Locals
local layers
local curPane = 1
local currentPenRadius = 1
local penRadii = { 1, 3, 5, 10 }
local currentColor = _W_
local colors = { _W_, _K_, _LIGHTGREY_, _GREY_, _DARKGREY_, _R_, _G_, _B_, _Y_, _PURPLE_, _C_, _O_  }
local paneSelectBW = 50
local colorChipSize = 30
local current = {}
local paneBacks = {}

-- Useful localization of SSK features
local newImageRect 		= ssk.display.newImageRect
local easyIFC				= ssk.easyIFC
local easyAlert			= ssk.misc.easyAlert
local quickLayers  		= ssk.display.quickLayers


-- Generate olor Button Presets
local mgr = require "ssk2.core.interfaces.buttons"
for i = 1, #colors do
	local tmp = table.shallowCopy(colors[i])
	--tmp[4] = 0.1

	local params = 
	{ 
		labelColor			= {1,1,1,1},
		labelSize			= 16,
		labelFont			= gameFont,
		labelOffset         = {0,1},
		unselRectFillColor	= tmp,
		selRectFillColor	= colors[i],
		strokeWidth         = 4,
	    unselStrokeColor    = {1,1,1, 0.25},
	    selStrokeColor      = _BRIGHTORANGE_,
		emboss              = false,	
	}
	mgr:addButtonPreset( "chip" .. i, params )
end

-- ============================
-- 
-- ============================
local public = {}



function public.create(  )
	local panes = {}
	for i = 1, 15 do
		panes[i] = "pane" .. i 
	end
	local layers = ssk.display.quickLayers( display.currentStage, 
		"underlay", 
		"content",  
			panes, 
		"paneSelect",
		"penSizeSelect",
		"colorSelect",
		"fillSelect" )

	-- Create Pane selection buttons
	local function showPane( cur )
		cur = cur or 1
		for i = 1, #panes do
			layers[panes[i]].isVisible = false
		end
		layers[panes[cur]].isVisible = true
	end
	showPane()

	local function onPaneSelect( event )
		local num = event.target.num
		showPane( num )
		curPane = num
		return true
	end

	local bw = paneSelectBW 
	local gap = 5
	local bh = h / #panes
	local curY = bh/2
	local first 
	for i = 1, #panes do
		local tmp = easyIFC:presetRadio( layers.paneSelect, "default", bw/2, curY, bw - gap, bh - gap, i, onPaneSelect, { labelSize = 16 } )
		tmp.num = i
		first = first or tmp
		curY = curY + bh
	end
	first:toggle()

	-- Create Pen Radius Selection buttons
	local function onRadiusSelect( event )
		local num = event.target.num
		currentPenRadius = penRadii[num]
		return true
	end

	local gap = 5
	local curX = paneSelectBW * 1.1 + colorChipSize * 2 * #colors + 1.5 * colorChipSize
	local curY = h - 0.5 * colorChipSize - gap
	local first 
	for i = 1, #penRadii do
		local tmp = easyIFC:presetRadio( layers.penSizeSelect, "default", curX, curY, colorChipSize - gap, colorChipSize - gap, penRadii[i], onRadiusSelect )
		tmp.num = i
		first = first or tmp
		curX = curX + colorChipSize
	end
	first:toggle()


	-- Create Pen Color Chips
	local function onColorSelect( event )
		local num = event.target.num
		currentColor = colors[num]
		return true
	end

	local gap = 5
	local curX = paneSelectBW * 1.1 + colorChipSize/2
	local curY = h - 0.5 * colorChipSize - gap
	local first 
	for i = 1, #colors do
		local tmp = easyIFC:presetRadio( layers.colorSelect, "chip" .. i, curX, curY, colorChipSize - gap, colorChipSize - gap, "", onColorSelect )
		tmp.num = i
		first = first or tmp
		curX = curX + colorChipSize
	end
	first:toggle()

	-- Create Back Fill Color Chips
	local function onBackFill( event )
		local num = event.target.num
		paneBacks[curPane]:setFillColor(unpack(colors[num]))
		return true
	end

	local gap = 5
	local curX =  paneSelectBW * 1.1 + (#colors + 1) * colorChipSize
	local curY = h - 0.5 * colorChipSize - gap
	local second 
	for i = 1, #colors do
		local tmp = easyIFC:presetRadio( layers.fillSelect, "chip" .. i, curX, curY, colorChipSize - gap, colorChipSize - gap, "", onBackFill )
		tmp.num = i
		if(i == 2 ) then second = tmp end
		curX = curX + colorChipSize
	end
	timer.performWithDelay(100, function() first:toggle() end )

	
	-- Create Each 'Drawing Space'	
	local function onPurge( event )

		local function doPurge()
			local target = event.target.back
			for k,v in pairs( target.myStuff ) do
				display.remove( v )
			end
			target.myStuff = {}
			target.undo = {}
			return true
		end
		easyAlert( "Delete This Page?", "Do you want to delete the contents of the active page?",
		{ {"Yes", doPurge }, { "Nope!", nil }} )
	end
	local function onUndo( event )
		local undo = event.target.back.undo
		if( not undo or #undo == 0 ) then return end
		local obj = undo[#undo]
		undo[#undo] = nil		
		display.remove(obj)
		return true
	end

	local function onTouch( self, event )
		self.myStuff = self.myStuff or {}
		self.undo = self.undo or {}
		local allowDraw = false
		if( self.last ) then 
			local dx = event.x - self.last[1]
			local dy = event.y - self.last[2]
			--print(dx,dy, (dx * dx + dy * dy) >= (currentPenRadius * currentPenRadius)  )
			allowDraw = ( (dx * dx + dy * dy) >= (currentPenRadius * currentPenRadius) )
		else			
			allowDraw = true
		end		

		if( not allowDraw  and  event.phase ~= "ended" ) then return true end
		if( event.phase ~= "ended" ) then self.last = { event.x, event.y } end

		if( event.phase == "began" ) then 
			current = {}
			undo = {}
		end

		if (allowDraw) then
			local dot = display.newCircle( layers["pane" .. curPane], event.x, event.y, currentPenRadius )
			dot:setFillColor(unpack(currentColor))
			self.myStuff[dot] = dot		
			current[#current+1] = dot
		end

		if( event.phase == "ended" ) then 
			print("drawline", #current )
			if( #current == 1 ) then
				undo[current[1]] = current[1]
				self.undo[#self.undo+1] = current[1]
			elseif( #current > 1 ) then
				local points = {}
				for i = 1, #current do
					points[#points+1] = current[i].x
					points[#points+1] = current[i].y
				end
				local line = display.newLine( layers["pane" .. curPane], unpack(points) )
				line:setStrokeColor( unpack(currentColor) )
				line.strokeWidth = currentPenRadius * 2
				self.undo[#self.undo+1] = line
				self.myStuff[line] = line
				for k,v in pairs( current ) do
					display.remove( v )
				end
			end
			current = {}			
		end

		return true
	end

	local function onHelp()
		local help = require "scripts.help"
		help.show()
	end
	onHelp()

	for i = 1, #panes do
		local back = newImageRect( layers["pane" .. i], centerX, centerY, "images/fillW.png", { w = w, h = h, fill = _K_ } )
		local tmp = easyIFC:presetPush( layers["pane" .. i], "default", w - 25,  25, 40, 40, "?", onHelp )
		tmp.back = back

		local tmp = easyIFC:presetPush( layers["pane" .. i], "default", w - 25, h - 25, 40, 40, "X", onPurge )
		tmp.back = back
		local tmp = easyIFC:presetPush( layers["pane" .. i], "default", w - 70, h - 25, 40, 40, "U", onUndo )
		tmp.back = back
		back.touch = onTouch
		back:addEventListener( "touch" )
		paneBacks[i] = back
	end

end

return public