--- Menu UI elements.
--
-- @todo Document skin...

--
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- [ MIT license: http://www.opensource.org/licenses/mit-license.php ]
--

-- Standard library imports --
local assert = assert
local ipairs = ipairs
local pairs = pairs
local rawequal = rawequal
local remove = table.remove
local type = type

--
-- INLINED FROM SOME OTHER MODULES
--

local ceil = math.ceil
local floor = math.floor
local sub = string.sub
local tonumber = tonumber

local function Copy (t)
	local dt = {}

	for k, v in pairs(t) do
		dt[k] = v
	end

	return dt
end

-- Helper to extract a number from a DSL_Number
local function ParseNumber (arg, dim, can_fail)
	local num = tonumber(arg)

	if num then
		return num
	else
		local ok = sub(arg, -1) == "%"

		assert(ok or can_fail, "Invalid argument")

		num = ok and tonumber(sub(arg, 1, -2))

		return num and num * display[dim] / 100
	end
end

local function EvalDims (w, h)
	w = w and ceil(ParseNumber(w, "contentWidth")) or nil
	h = h and ceil(ParseNumber(h, "contentHeight")) or nil

	return w, h
end

local function FitToSlot (value, base, dim)
	return floor((value - base) / dim) + 1
end

--
-- /INLINED
--

-- Modules --
local layout = require("layout")
local meta = require("meta")

-- Corona globals --
local display = display
local graphics = graphics
local native = native
local system = system
local transition = transition

-- Cached module references --
local _Menu_

-- Exports --
local M = {}

--
--
--

local function Heading (menu, index)
	return menu[index][1]
end

local function DataFromHeading (heading)
	local tindex, iindex = heading.m_text_index, heading.m_image_index
	local data_index = tindex or iindex -- see 'into' in PopulateEntry()

	return heading.parent[data_index], heading, tindex, iindex
end

local function HeadingData (menu, index)
	return DataFromHeading(Heading(menu, index))
end

local ImageFill, OnItemChangeEvents = { type = "image" }, {}

local function PlaceImage (image, object, pos, str, margin)
	if pos == "left" then
		layout.LeftAlignWith(image, object, margin)
	elseif pos == "right" then
		layout.RightAlignWith(image, object, -margin)
	elseif str then
		layout.PutLeftOf(image, str, -margin)
	else
		image.x = object.x
	end

	image.y = object.y
end

local function UpdateText (str, event)
	local new_text = event.text

	if new_text then
		str.text = event.visual_text or new_text
	end

	str.isVisible = new_text ~= nil
end

local function SetImage (image, event, sheets, shader)
	local filename, sheet = event.filename, sheets and sheets[event.sheet or 1]

	if filename then
		ImageFill.filename, ImageFill.baseDir, ImageFill.sheet, ImageFill.frame = filename, event.baseDir
	elseif sheet then
		ImageFill.sheet, ImageFill.frame, ImageFill.filename, ImageFill.baseDir = sheet, event.frame
	else
		return -- no sheet yet?
	end

	image.fill = ImageFill

	if type(shader) == "function" then
		shader(image)
	else
		image.fill.effect = shader
	end
end

local function UpdateImage (image, event, heading, sheets, str, shader)
	local image_data = event.filename or event.frame

	if image_data then
		SetImage(image, event, sheets, shader)
		PlaceImage(image, heading, event.position, event.text and str, image.m_margin)
	end

	image.isVisible = image_data ~= nil
end

local Names = { "text", "id", "filename", "baseDir", "position", "sheet", "frame", "index", "shader" }

for i, name in ipairs(Names) do
	local suffix, def = name

	if name == "baseDir" then
		suffix, def = "dir", system.ResourceDirectory
	elseif name == "position" then
		suffix = "pos"
	elseif name == "sheet" then
		def = 1
	end

	Names[name], Names[i] = { "m_" .. suffix, "old_" .. name, def }
end

local function HasChanged (data, event)
	for name, info in pairs(Names) do
		local def = info[3]

		if (data[info[1]] or def) ~= (event[name] or def) then
			return true
		end
	end
end

local function SetHeading (menu_item_event)
	local menu = menu_item_event.target
	local data, heading, tindex, iindex = HeadingData(menu, menu_item_event.column)

	if HasChanged(data, menu_item_event) then
		local event = remove(OnItemChangeEvents) or {} -- allow recycling but also nesting

		for name, info in pairs(Names) do
			local new_key, old_key, new = info[1], info[2], menu_item_event[name]

			data[new_key], event[old_key], event[name] = new, data[new_key], new
		end

		if tindex then
			UpdateText(data, menu_item_event)
		end

		if iindex then
			UpdateImage(data.parent[iindex], menu_item_event, heading, menu.m_sheets, tindex and data, data.m_shader)
		end

		event.name, event.target = "item_change", menu

		menu:dispatchEvent(event)

		OnItemChangeEvents[#OnItemChangeEvents + 1], event.target = event
	end
end

-- --
local Empty = {}

--- DOCME
function M.Dropdown (params)
	local column = assert(params.column, "Expected column")

	assert(type(column) == "table", "Column must be table")
	assert(#column > 0, "Table entries required")

	params = Copy(params)
	params.columns, params.is_dropdown = { Empty, column }, true

	local dropdown = _Menu_(params)

	dropdown:Select(params.choice, params.how or "first_in_first_column")

	return dropdown
end

local function Type (column)
	local ctype = type(column)

	assert(ctype == "table" or ctype == "string", "Bad column type")

	if ctype == "string" or rawequal(column, Empty) then
		return "entry"
	elseif #column == 0 then
		assert(column.text == nil or type(column.text) == "string", "Non-string text")
		assert(column.filename == nil or type(column.filename) == "string", "Non-string filename")
		assert(column.id == nil or type(column.id) == "number", "Non-number ID")
		assert(column.frame == nil or type(column.frame) == "number", "Non-number frame")
		assert(column.sheet == nil or type(column.sheet) == "number", "Non-number sheet index")
		assert(column.shader == nil or type(column.shader) == "function" or type(column.shader) == "string", "Invalid shader")
		assert(column.text or column.filename or column.frame, "Entry has neither text nor an image or frame")
		assert(column.sheet == nil or column.frame, "Sheet index only valid with frame")
		assert(column.frame == nil or column.filename == nil, "Frames and filenames are mutually exclusive")
		assert(column.position == nil or column.position == "left" or column.position == "right", "Invalid image position")
		assert(column.shader == nil or column.filename or column.frame, "Shader assumes image or frame")

		return "entry"
	else
		return "column"
	end
end

local function CheckColumns (columns)
	assert(columns, "Missing columns")

	local prev_type

	for _, column in ipairs(columns) do
		local ctype = Type(column)

		if ctype == "column" then
			assert(prev_type == "entry", "Columns must follow heading entry")

			for _, v in ipairs(column) do
				assert(Type(v) == "entry", "Invalid column entry")
			end
		end

		prev_type = ctype
	end

	return columns
end

local FadeParams = {
	time = 150,

	onComplete = function(object)
		object.m_can_touch = true
	end
}

local function Fade (object, alpha)
	object.m_can_touch, FadeParams.alpha = false, alpha

	return transition.to(object, FadeParams)
end

local function MenuFromHeading (heading)
	return heading.parent.parent
end

local function InHeading (heading, x, y)
	local menu = MenuFromHeading(heading)

	for i = 1, menu.numChildren do
		local item = Heading(menu, i)
		local ibounds = item.contentBounds

		if x >= ibounds.xMin and x <= ibounds.xMax and y >= ibounds.yMin and y <= ibounds.yMax then
			if item == heading then
				return "this"
			else
				return item
			end
		end
	end
end

local function ReleaseHeading (heading)
	heading:setFillColor(.6)
end

local function SetOrClearFocus (menu, focus)
	display.getCurrentStage():setFocus(focus)

	menu.m_touched = focus ~= nil
end

local function Close (dropdown, new)
	transition.cancel(dropdown.m_fading)

	dropdown.m_can_touch, dropdown.m_fading = false

	Fade(dropdown.parent, 0)

	local heading = dropdown.m_bar.m_heading

	ReleaseHeading(heading)
	SetOrClearFocus(MenuFromHeading(heading), new)
end

local function TouchHeading (heading)
	heading:setFillColor(.2)

	local dropdown = heading.m_dropdown

	if dropdown then
		dropdown.m_fading = Fade(dropdown.parent, 1)

		display:getCurrentStage():setFocus(dropdown)
	else
		display:getCurrentStage():setFocus(heading)
	end
end

local function FindData (bar, index)
	local bgroup, cur = bar.parent, 1

	for i = bar.m_offset + 1, bgroup.numChildren do
		local item = bgroup[i]

		if item.m_text or item.m_filename or item.m_frame then
			if cur == index then
				return item
			else
				cur = cur + 1
			end
		end
	end

	assert(false, "Data not found") -- should never get here if implementation is correct
end

local MenuItemEvents = {}

local function SendMenuItemEvent (menu, packet, column, index)
	local event = remove(MenuItemEvents) or {} -- see note in SetHeading()

	event.name, event.target = "menu_item", menu
	event.text, event.visual_text = nil
	event.column, event.index = column, index, packet.m_pos

	for name, info in pairs(Names) do
		if name ~= "text" then
			event[name] = packet[info[1]]
		end
	end

	local text = packet.m_text

	if text then
		event.text = text

		if menu.m_get_text then
			local vtext = menu.m_get_text(text)

			if vtext ~= text then
				event.visual_text = text
			end
		end
	end

	menu:dispatchEvent(event)

	MenuItemEvents[#MenuItemEvents + 1], event.target = event
end

local function DropdownTouch (event)
	local dropdown, phase = event.target, event.phase
	local end_phase = phase == "ended" or phase == "cancelled" 

	if not (dropdown.parent.m_can_touch or end_phase) then
		return
	end

	local bar = dropdown.m_bar

	if phase == "moved" then
		local bounds, x, y = dropdown.contentBounds, event.x, event.y
		local xinside = x >= bounds.xMin and x <= bounds.xMax
		local yinside = y >= bounds.yMin and y <= bounds.yMax
		local heading, _, topy = bar.m_heading, dropdown:contentToLocal(0, y)
		local index = FitToSlot(topy, -dropdown.height / 2, bar.height)

		if yinside then
			layout.PutBelow(bar, heading, (index - 1) * bar.height)
		end

		local how = yinside and "show"

		if xinside and yinside then
			bar.m_index = index
		else
			how, bar.m_index = how or InHeading(heading, x, y)
		end

		bar.isVisible = how == "show"

		if how and how ~= "show" and how ~= "this" then
			Close(dropdown, how)
			TouchHeading(how)
		end
	elseif end_phase then
		local index = bar.m_index

		if index then
			local heading = bar.m_heading

			SendMenuItemEvent(MenuFromHeading(heading), FindData(bar, index), heading.m_column, index)

			bar.m_index = nil
		end

		bar.isVisible = false

		Close(dropdown)
	end

	return true
end

local function HeadingTouch (event)
	local heading, phase = event.target, event.phase
	local menu = MenuFromHeading(heading)

	if phase == "began" then
		TouchHeading(heading)

		menu.m_touched = true
	elseif not menu.m_touched then
		return
	elseif phase == "moved" then
		local how = InHeading(heading, event.x, event.y)

		if how and how ~= "this" then
			ReleaseHeading(heading)
			TouchHeading(how)
		end
	elseif phase == "ended" or phase == "cancelled" then
		ReleaseHeading(heading)
		SetOrClearFocus(menu, nil)

		if InHeading(heading, event.x, event.y) == "this" then
			SendMenuItemEvent(menu, DataFromHeading(heading), heading.m_column)
		end
	end

	return true
end

local Menu = {}

--- DOCME
function Menu:addEventListener (name, listener)
	self.m_dispatcher = self.m_dispatcher or system.newEventDispatcher()

	self.m_dispatcher:addEventListener(name, listener)
end

--- DOCME
function Menu:dispatchEvent (event)
	assert(not self.m_broken, "Menu not whole")

	if self.m_dispatcher then
		self.m_dispatcher:dispatchEvent(event)
	end
end

--- DOCME
function Menu:GetHeadingCenterY ()
	local heading = Heading(self, 1)
	local _, y = self.parent:contentToLocal(heading:localToContent(0, 0))

	return y
end

--- DOCME
function Menu:GetHeadingHeight ()
	return Heading(self, 1).height
end

--- DOCME
function Menu:GetSelection (params)
	assert(not self.m_broken, "Menu not whole")

	local params_type, out, column = type(params)

	if params_type == "number" then
		column = params
	elseif params_type == "string" then
		out = true -- stifle automatic table
	elseif params_type == "table" then
		column, out = params.column, params

		if params.get then
			params, out = params.get, true -- reinterpret as string

			assert(type(params) == "string", "Non-string get")
		end
	elseif params then
		assert(false, "Invalid selection")
	end

	column, out = column or 1, out or {}

	assert(self[column], "Index out of bounds")

	local data = HeadingData(self, column)

	if out == true then -- see above
		local info = Names[params]

		return info and data[info[1]]
	end

	for name, info in pairs(Names) do
		out[name] = data[info[1]]
	end

	return out
end

--- DOCME
function Menu:RelocateDropdowns (into)
	assert(not self.m_broken, "Menu not whole")
	assert(not self.m_relocated, "Dropdowns already relocated")

	for i = 1, self.numChildren do
		local cgroup = self[i]

		if cgroup.m_has_dropdown then
			local bgroup = cgroup[cgroup.numChildren]
			local x, y = bgroup:localToContent(0, 0)

			into:insert(bgroup)

			bgroup.x, bgroup.y = into:contentToLocal(x, y)
		end
	end

	self.m_relocated = true
end

--- DOCME
function Menu:removeEventListener (name, listener)
	if self.m_dispatcher then
		self.m_dispatcher:removeEventListener(name, listener)
	end
end

--- DOCME
function Menu:RestoreDropdowns (stash)
	assert(self.m_broken, "Menu already whole")

	local headings_only = stash.m_headings_only

	for i = self.numChildren, 1, -1 do
		if not (headings_only and headings_only[i]) then
			self[i]:insert(stash[stash.numChildren])
		end
	end

	self.m_broken = false
end

-- --
local SelectPacket = {}

local function FindSelection (menu, name_or_id)
	for i = 1, name_or_id and menu.numChildren or 0 do -- do check here to simplify multiple returns
		local bar = Heading(menu, i).m_dropdown.m_bar
		local bgroup, index = bar.parent, 0

		for j = bar.m_offset + 1, bgroup.numChildren do
			local item = bgroup[j]
			local text = item.m_text

			if text or item.m_filename or item.m_frame then
				index = index + 1

				if item.m_id == name_or_id or text == name_or_id then
					return item, i, index
				end
			end
		end
	end
end

--- DOCME
function Menu:Select (name_or_id, on_absence)
	assert(not self.m_broken, "Menu not whole")

	local ni_type = type(name_or_id)

	assert(name_or_id == nil or ni_type == "string" or ni_type == "number", "Expected string name or number ID")

	local packet, column, index = FindSelection(self, name_or_id)

	if not packet then
		packet = SelectPacket

		if on_absence == "no_op" then
			return
		elseif on_absence == "first_in_first_column" then
			packet, index = FindData(Heading(self, 1).m_dropdown.m_bar, 1), 1
		elseif ni_type == "string" then
			packet.m_text, packet.m_id = name_or_id
		else
			packet.m_id, packet.m_text = name_or_id
		end
	end

	SendMenuItemEvent(self, packet, column or 1, index)
end

--- DOCME
function Menu:StashDropdowns ()
	assert(not self.m_broken, "Already stashed")
	assert(not self.m_relocated, "Dropdowns have been relocated")

	local stash, headings_only = display.newGroup()

	for i = 1, self.numChildren do
		local cgroup = self[i]

		if cgroup.m_has_dropdown then
			stash:insert(cgroup[cgroup.numChildren])
		else
			headings_only = headings_only or {}
			headings_only[i] = true
		end
	end

	self.m_broken, stash.isVisible, stash.m_headings_only = true, false, headings_only

	return stash
end

local SheetInfo = {}

--- DOCME
function Menu:UpdateSheet (index, sheet)
	local sheets = self.m_sheets

	assert(sheets, "Menu not using image sheets")
	assert(sheets[index] ~= nil, "Invalid index")

	sheets[index] = assert(sheet, "Invalid sheet")

	SheetInfo.sheet = index

	for i = 1, self.numChildren do
		local heading = Heading(self, i)
		local data = DataFromHeading(heading)

		if data.m_frame and (data.m_sheet or 1) == index then
			SheetInfo.frame = data.m_frame

			SetImage(heading.parent[heading.m_image_index], SheetInfo, sheets, data.m_shader)
		end

		local bar = heading.m_dropdown.m_bar
		local bgroup = bar.parent

		for j = bar.m_offset + 1, bgroup.numChildren do
			local item = bgroup[j]

			if item.m_frame and (item.m_sheet or 1) == index then
				SheetInfo.frame = item.m_frame

				SetImage(item.m_rect or item, SheetInfo, sheets, item.m_shader) -- see note in PopulateEntry()
			end
		end
	end
end

local function DefGetText (text) return text end

local function EnsureText (object, font, size, is_dropdown, is_heading)
	local heading = is_heading and object or object.m_heading
	local cgroup = heading.parent

	-- If we just added the heading, we already have our text. Otherwise, if this is the
	-- first text entry in a dropdown, the heading must be ready to represent it, so get
	-- a text object ready to go. This is irrelevant for non-dropdowns.
	if is_dropdown and not (is_heading or heading.m_text_index) then
		display.newText(cgroup, "", heading.x, heading.y, font, size).isVisible = false
	end

	-- Make the heading aware of any text.
	if is_dropdown or is_heading then
		heading.m_text_index = heading.m_text_index or cgroup.numChildren
	end
end

local function EnsureImage (object, iw, ih, margin, is_dropdown, is_heading)
	local heading = is_heading and object or object.m_heading
	local cgroup, image = heading.parent

	-- If this is a dropdown, the heading must be ready to represent the image, so get a rect
	-- ready to go, to be assigned a bitmap fill. This might be the heading itself, in which
	-- case it should already be visible. This is irrelevant for non-dropdowns.
	if is_dropdown and not heading.m_image_index then
		image = display.newRect(cgroup, 0, 0, iw, ih)
		image.m_margin, image.isVisible = margin, is_heading
	end

	-- Make the heading aware of any image.
	if is_dropdown or is_heading then
		heading.m_image_index = heading.m_image_index or cgroup.numChildren
	end

	return image
end

local function GetSheets (sheets)
	if sheets then
		assert(type(sheets) == "table", "Invalid image sheets")

		for _, sheet in ipairs(sheets) do
			if sheet == false then
				return Copy(sheets) -- has provisional sheets, so must be able to change
			end
		end
	end

	return sheets
end

local function PopulateEntry (column, group, object, get_text, font, size, iw, ih, margin, is_dropdown, is_heading)
	local text, into, str, filename, frame, shader

	if type(column) == "string" then
		text = column
	else
		text, filename, frame, shader = column.text, column.filename, column.frame, column.shader
	end

	if text then
		str = display.newText(group, get_text(text), object.x, object.y, font, size)
		str.m_text, into = text, str -- do m_text here, since column might be string

		EnsureText(object, font, size, is_dropdown, is_heading)
	end

	if filename or frame then
		local image, pos = EnsureImage(object, iw, ih, margin, is_dropdown, is_heading), column.position
		local heading = is_heading and object or object.m_heading -- when not heading, object is bar
		local sheets = MenuFromHeading(heading).m_sheets

		if image and is_heading then
			SetImage(image, column, sheets, shader)
		else
			local dir = column.baseDir

			if image then
				PlaceImage(image, heading, pos, str, margin)
			end

			if frame then
				image = display.newRect(group, 0, 0, iw, ih)

				if str then
					str.m_rect = image -- means of discovering this when updating sheet
				end

				SetImage(image, column, sheets, shader)
			elseif dir then
				image = display.newImageRect(group, filename, dir, iw, ih)
			else
				image = display.newImageRect(group, filename, iw, ih)
			end
		end

		PlaceImage(image, object, pos, str, margin)

		into = into or image -- consolidate all data in one object
	end

	if into then
		for name, info in pairs(Names) do
			if name ~= "text" then
				into[info[1]] = column[name]
			end
		end
	end
end

--- DOCME
function M.Menu (params)
	local menu = display.newGroup()

	if params.group then
		params.group:insert(menu)
	end

	local columns = CheckColumns(params.columns)
	local column_width, heading_height = EvalDims(params.column_width or 100, params.heading_height or 30)
	local _, bar_height = EvalDims(nil, params.bar_height or heading_height)
	local iw, ih = EvalDims(params.image_width or 24, params.image_height or 24)
	local font, size = params.font or native.systemFont, params.size or 16
	local x, y, margin, cgroup, heading = .5 * column_width, .5 * heading_height, layout.ResolveX(params.margin or 5)
	local ci, get_text, is_dropdown = 1, params.get_text or DefGetText, params.is_dropdown

	menu.m_get_text, menu.m_sheets = get_text, GetSheets(params.sheets)

	for _, column in ipairs(columns) do
		if type(column) == "string" or #column == 0 then
			cgroup = display.newGroup()
			heading = display.newRect(cgroup, x, y, column_width, heading_height)
			heading.m_column = ci

			ReleaseHeading(heading) -- set fill color
			PopulateEntry(column, cgroup, heading, get_text, font, size, iw, ih, margin, is_dropdown, true)

			heading:addEventListener("touch", HeadingTouch)
			menu:insert(cgroup)

			if ci > 1 then
				local lx = (ci - 1) * column_width
				local sep = display.newRect(cgroup, lx, y, 1, heading_height) -- display.newLine() spills over too much

				sep:setFillColor(.3)
			end

			ci, x = ci + 1, x + column_width
		else
			local bgroup = display.newGroup()

			cgroup.m_has_dropdown = true

			local dropdown = display.newRect(bgroup, heading.x, 0, column_width, #column * bar_height)
			local bar = display.newRect(bgroup, heading.x, 0, column_width, bar_height)
			local prev = heading

			heading.m_dropdown, dropdown.m_bar, bar.m_heading = dropdown, bar, heading

			layout.PutBelow(dropdown, heading)

			bar.m_offset = bgroup.numChildren

			for _, entry in ipairs(column) do
				layout.PutBelow(bar, prev)

				PopulateEntry(entry, bgroup, bar, get_text, font, size, iw, ih, margin, is_dropdown)

				prev = layout.Below(bar)
			end

			cgroup:insert(bgroup) -- add here to ensure as last element

			dropdown:addEventListener("touch", DropdownTouch)
			dropdown:setFillColor(0, 0, .3)
			bar:setFillColor(0, .7, 0)

			bgroup.alpha, bar.isVisible = 0, false
		end
	end

	if params.left then
		layout.LeftAlignWith(menu, params.left)
	elseif params.x then
		layout.CenterAtX(menu, params.x)
	end

	if params.top then
		layout.TopAlignWith(menu, params.top)
	elseif params.y then
		layout.CenterAtY(menu, params.y)
	end

	meta.Augment(menu, Menu)

	if is_dropdown then
		menu:addEventListener("menu_item", SetHeading)
	end

	return menu
end

-- Cache module members.
_Menu_ = M.Menu

-- Export the module.
return M