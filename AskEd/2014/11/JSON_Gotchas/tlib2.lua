local json = require "json"
local tlib2 = {}


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
tlib2.deepStripCopy = function( src, dst )
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
tlib2.save = function( theTable, fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	local fh = io.open( path, "w" )

	local tmpTable = tlib2.deepStripCopy(theTable)

	if(fh) then
		fh:write(json.encode( tmpTable ))
		io.close( fh )
		return true
	end	
	return false
end


-- ==
--    Load Table( fileName [, base ] ) - Loads table from file (Uses JSON library as intermediary)
-- ==
tlib2.load = function( fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
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

function tlib2.repairIndicies( theTable )
	for k,v in pairs( theTable ) do
		if(tonumber(k) and type(k) == "string") then
			timer.performWithDelay( 1, function() theTable[tostring(k)] = nil end )
			--theTable[tostring(k)] = nil
			theTable[tonumber(k)] = v 
		end
		if( type(v) == "table" ) then
			tlib2.repairIndicies(v)
		end
	end
end


-- This function is needed by tlib.dump below
function string:rpad(len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return theStr .. string.rep(char, len - #theStr)
end

-- ==
--    table.dump( theTable [, padding ] ) - Dumps indexes and values inside single-level table (for debug) (UNSORTED)
-- ==
function tlib2.dump(theTable, padding, marker ) -- Sorted
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
			local value = tostring(theTable[key])
			local keyType = type(key)
			local valueType = type(value)
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


return tlib2