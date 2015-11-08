-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================

local json = require( "json" )
local mRand = math.random

-- ==
--    table.shuffle( t ) - Randomizes the order of a numerically indexed (non-sparse) table. Alternative to randomizeTable().
-- ==
table.shuffle = function( t, iter )
	local iter = iter or 1
	local n

	for i = 1, iter do
		n = #t 
		while n >= 2 do
			-- n is now the last pertinent index
			local k = math.random(n) -- 1 <= k <= n
			-- Quick swap
			t[n], t[k] = t[k], t[n]
			n = n - 1
		end
	end
 
	return t
end

-- ==
--    table.combineUnique( ... ) - Combines n tables into a single table containing only unique members from each source table.
-- ==
function table.combineUnique( ... )
	local newTable = {}
	
	for i=1, #arg do
		for k,v in pairs( arg[i] ) do
			newTable[v] = v
		end
	end

	return newTable
end

-- ==
--    table.combineUnique_i( ... ) - Combines n tables into a single table containing only unique members from each source table.
-- ==
function table.combineUnique_i( ... )
	local newTable = {}
	local tmpTable = table.combineUnique( unpack(arg) )	
	local i = 1
	for k,v in pairs( tmpTable ) do
		newTable[i] = tmpTable[k]
		i = i + 1
	end
	return newTable
end

-- ==
--    table.shallowCopy( src [ , dst ]) - Copies single-level tables; handles non-integer indexes; does not copy metatable
-- ==
function table.shallowCopy( src, dst )
	local dst = dst or {}
	if( not src ) then return dst end
	for k,v in pairs(src) do 
		dst[k] = v
	end
	return dst
end

-- ==
--    table.deepCopy( src [ , dst ]) - Copies multi-level tables; handles non-integer indexes; does not copy metatable
-- ==
function table.deepCopy( src, dst )
	local dst = dst or {}
	for k,v in pairs(src) do 
		if( type(v) == "table" ) then
			dst[k] = table.deepCopy( v, nil )
		else
			dst[k] = v
		end		
	end
	return dst
end

-- ==
--    table.deepStripCopy( src [ , dst ]) - Copies multi-level tables, but strips out metatable(s) and ...
--
--    Fields with these value types: 
--       functions
--       userdata
--
--    Fields with these these names: 
--       _class
--       __index
--
--
--  This function is primarily meant to be used in preparation for serializing a table to a file.
--  Because you can't serialize a table with the above types and fields, they need to be removed first.
--  Of course, when you load the file back up, it will be up to  you to reattach the removed parts.
-- 
-- ==
function table.deepStripCopy( src, dst )
	local dst = dst or {}
	for k,v in pairs(src) do 
		local key = tostring(k)
		local value = tostring(v)
		local keyType = type(k)
		local valueType = type(v)

		if( valueType == "function" or 
		    valueType == "userdata" or 
			key == "_class"         or
			key == "__index"           ) then

			-- STRIP (SKIP IT)

		elseif( valueType == "table" ) then

			dst[k] = table.deepStripCopy( v, nil )

		else
			dst[k] = v
		end		
	end
	return dst
end

-- ==
--    table.save( theTable, fileName [, base ] ) - Saves table to file (Uses JSON library as intermediary)
-- ==
function table.save( theTable, fileName, base, doStrip )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	local fh = io.open( path, "w" )

	if(fh) then
		fh:write(json.encode( theTable ))
		io.close( fh )
		return true
	end	
	return false
end

-- ==
--    table.stripSave( theTable, fileName [, base ] ) - Saves table to file (Uses JSON library as intermediary)
-- ==
function table.stripSave( theTable, fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	local fh = io.open( path, "w" )

	local tmpTable = table.deepStripCopy(theTable)

	if(fh) then
		fh:write(json.encode( tmpTable ))
		io.close( fh )
		return true
	end	
	return false
end

-- ==
--    table.load( fileName [, base ] ) - Loads table from file (Uses JSON library as intermediary)
-- ==
function table.load( fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	if(path == nil) then return nil end
	local fh, reason = io.open( path, "r" )
	
	if fh then
		local contents = fh:read( "*a" )
		io.close( fh )
		local newTable = json.decode( contents )
		return newTable
	else
		return nil
	end
end

-- ==
--    table.dumpu( theTable [, padding ] ) - Dumps indexes and values inside single-level table (for debug) (UNSORTED)
-- ==
function table.dumpu(theTable, padding, marker )
	marker = marker or ""
	local padding = padding or 30
	print("\Table Dump:")
	print("-----")
	if(theTable) then
		for k,v in pairs(theTable) do 
			local key = tostring(k)
			local value = tostring(v)
			local keyType = type(k)
			local valueType = type(v)
			local keyString = key .. " (" .. keyType .. ")"
			local valueString = value .. " (" .. valueType .. ")" 

			keyString = keyString:rpad(padding)
			valueString = valueString:rpad(padding)

			print( keyString .. " == " .. valueString ) 
		end
	else
		print("empty")
	end
	print( marker .. "-----\n")
end

function table.dump(theTable, padding, marker ) -- Sorted
	marker = marker or ""
	local theTable = theTable or  {}
	local function compare(a,b)
	  return tostring(a) < tostring(b)
	end
	local tmp = {}
	for n in pairs(theTable) do table.insert(tmp, n) end
	table.sort(tmp,compare)

	local padding = padding or 30
	print("\Table Dump:")
	print("-----")
	if(#tmp > 0) then
		for i,n in ipairs(tmp) do 		

			local key = tmp[i]
			local keyType = type(key)
			local valueType = type(theTable[key])
			local value = tostring(theTable[key])
			local keyString = tostring(key) .. " (" .. keyType .. ")"
			local valueString = tostring(value) .. " (" .. valueType .. ")" 

			keyString = keyString:rpad(padding)
			valueString = valueString:rpad(padding)

			print( keyString .. " == " .. valueString ) 
		end
	else
		print("empty")
	end
	print( marker .. "-----\n")
end


-- ==
--    table.print_r( theTable ) - Dumps indexes and values inside multi-level table (for debug)
-- ==
table.print_r = function ( t ) 
	--local depth   = depth or math.huge
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+1))
						print(indent..string.rep(" ",string.len(pos)+1).."}")
					elseif (type(val)=="string") then
						print(indent.."["..pos..'] => "'..val..'"')
					else
						print(indent.."["..pos.."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end			
		end
	end
	if (type(t)=="table") then
		print(tostring(t).." {")
		sub_print_r(t," ")
		print("}")
	else
		sub_print_r(t," ")
	end
end


-- ==
--    table.count( src ) - Counts all entries in table (non-recursive)
-- ==
function table.count( src )
	local count = 0
	if( not src ) then return count end
	for k,v in pairs(src) do 
		count = count + 1
	end
	return count
end

-- ==
--    table.maxIndex( src ) - Determine the maximum index of a sparse table
-- ==
function table.maxIndex( src )
	local high = 0
	if( not src ) then return high end
	for k,v in pairs(src) do 
		if(k>high) then high = k end
	end
	return high
end


-- ==
--    table.count_r( src ) - Counts all entries in table (recursive)
-- ==
function table.count_r( src )
	local count = 0
	for k,v in pairs(src) do 
		if( type(v) == "table" ) then
			count = count + table.count_r( v )
		else
			count = count + 1
		end		
	end
	return count
end

-- ==
--    Permutation Iterator
-- ==
local permgen
permgen = function (a, n, fn)
	if n == 0 then
		fn(a)
	else
	for i=1,n do
		-- put i-th element as the last one
		a[n], a[i] = a[i], a[n]
 
		-- generate all permutations of the other elements
		permgen(a, n - 1, fn)
 
		-- restore i-th element
		a[n], a[i] = a[i], a[n]
 
		end
	end
end
 
--- an iterator over all permutations of the elements of a list.
-- Please note that the same list is returned each time, so do not keep references!
-- @param a list-like table
-- @return an iterator which provides the next permutation as a list
function table.permute_iter (a)
	--assert_arg(1,a,'table')
	local n = #a
	local co = coroutine.create( function () permgen(a, n, coroutine.yield) end )
	return function ()   -- iterator
	local code, res = coroutine.resume(co)
		return res
	end
end


-- ==
--    Sergey Stuff - Nice bits from Sergey's code: https://gist.github.com/Lerg
-- ==
function table.removeByRef(t, obj)
    table.remove(t, table.indexOf(t, obj))
end


function table.repairIndicies( theTable )
	for k,v in pairs( theTable ) do
		if(tonumber(k) and type(k) == "string") then
			timer.performWithDelay( 1, function() theTable[tostring(k)] = nil end )
			theTable[tonumber(k)] = v 
		end
		if( type(v) == "table" ) then
			table.repairIndicies(v)
		end
	end
end

-- ==
--    getRandom() - Numerically indexed tables ONLY
-- ==
table.getRandom = function( t )
	if( #t == 0 ) then return nil end
	return t[mRand(1,#t)]
end
