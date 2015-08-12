-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Table Add-ons
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

local json = require( "json" )

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
		i = i+1
	end

	return newTable
end

-- ==
--    table.shallowCopy( src [ , dst ]) - Copies single-level tables; handles non-integer indexes; does not copy metatable
-- ==
function table.shallowCopy( src, dst )
	local dst = dst or {}
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
--    table.save( theTable, fileName [, base ] ) - Saves table to file (Uses JSON library as intermediary)
-- ==
function table.save( theTable, fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	fh = io.open( path, "w" )
	if(fh) then
		fh:write(json.encode( theTable ))
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
--    table.dump( theTable [, padding ] ) - Dumps indexes and values inside single-level table (for debug)
-- ==
function table.dump(theTable, padding )
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
	print("-----\n")
end


-- ==
--    table.print_r( theTable ) - Dumps indexes and values inside multi-level table (for debug)
-- ==
table.print_r = function ( t ) 
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
