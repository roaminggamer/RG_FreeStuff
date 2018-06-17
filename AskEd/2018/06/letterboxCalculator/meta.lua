--- This module provides various metatable operations.

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
local getmetatable = getmetatable
local pairs = pairs
local rawequal = rawequal
local setmetatable = setmetatable
local type = type

-- Cached module references --
local _Weak_

-- Exports --
local M = {}

--
--
--

local Cached, Augmented

local function Copy (t, err)
	assert(type(t) == "table", err)

	local dt = {}

	for k, v in pairs(t) do
		assert(type(v) == "function", "Non-function property")

		dt[k] = v
	end

	return dt
end

--- DOCME
-- @ptable object
-- @ptable extension
function M.Augment (object, extension)
	if not Cached then
		Augmented, Cached = _Weak_("kv"), _Weak_("k")
	end

	local mt = getmetatable(object)

	assert(type(extension) == "table", "Extension must be a table")
	assert(mt == nil or type(mt) == "table", "Metatable missing or inaccessible")
	assert(not Augmented[object], "Object's metatable already augmented")

	local cached = Cached[mt]

	if cached then
		assert(rawequal(cached, extension), "Attempt to augment object with different extension")
	else
		local list, old_index, old_newindex = {}, mt and mt.__index, mt and mt.__newindex

		for k, v in pairs(extension) do
			if k ~= "__iprops" and k ~= "__oprops" then
				list[k] = v
			end
		end

		local is_table_oi, index = type(old_index) == "table"

		if extension.__iprops then
			local iprops = Copy(extension.__iprops, "Invalid in-properties (__iprops)")

			function index (t, k)
				local prop = iprops[k]

				if prop then
					local what, res = prop(t)

					if what == "use_index_k" then
						k = res
					elseif what ~= "use_index" then
						return what
					end
				end

				local item = list[k]

				if item ~= nil then
					return item
				elseif is_table_oi then
					return old_index[k]
				elseif old_index then
					return old_index(t, k)
				end
			end
		elseif old_index then
			function index (t, k)
				local item = list[k]

				if item ~= nil then
					return item
				elseif is_table_oi then
					return old_index[k]
				else
					return old_index(t, k)
				end
			end
		else
			index = list
		end

		local is_table_oni, newindex = type(old_newindex) == "table"

		if extension.__oprops then
			local oprops = Copy(extension.__oprops, "Invalid out-properties (__oprops)")

			function newindex (t, k, v)
				local prop = oprops[k]

				if prop then
					local what, res1, res2 = prop(t, v)

					if what == "use_newindex_k" then
						k = res1
					elseif what == "use_newindex_v" then
						v = res1
					elseif what == "use_newindex_kv" then
						k, v = res1, res2
					elseif what ~= "use_newindex" then
						return
					end
				end

				if is_table_oni then
					old_newindex[k] = v
				elseif old_newindex then
					old_newindex(t, k, v)
				end
			end
		else
			newindex = old_newindex
		end

		local new = { __index = index, __newindex = newindex }

		setmetatable(object, new)

		Augmented[object], Cached[new] = new, extension
	end
end

-- Weak table choices --
local Choices = { "k", "v", "kv" }

for i, mode in ipairs(Choices) do
	Choices[mode], Choices[i] = { __metatable = true, __mode = mode }
end

--- Builds a new weak table.
--
-- The table's metatable is fixed.
-- @string choice Weak option, which is one of **"k"**, **"v"**, or **"kv"**,
-- and will assign that behavior to the **__mode** key of the table's metatable.
-- @treturn table Table.
function M.Weak (choice)
	return setmetatable({}, assert(Choices[choice], "Invalid weak option"))
end

-- Cache module members.
_Weak_ = M.Weak

-- Export the module.
return M