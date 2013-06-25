-- Miscellaneous Functions and Library Extensions Used by Corona Twine

-- ==
--    string:rpad( len, char ) - Places padding on right side of a string, such that the new string is at least len characters long.
-- ==
function string:rpad(len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return theStr .. string.rep(char, len - #theStr)
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

-- ==
--    io.exists() - Does file exist?
-- ==
function io.exists( fileName, base )
	local fileName = fileName
	if( base ) then
		fileName = system.pathForFile( fileName, base )
	end
	if not fileName then return false end
	local f=io.open(fileName,"r")
	if (f == nil) then 
		return false
	end
	io.close(f)
	return true 
end

-- ==
--    io.readFileTable() - Read file into table. Lines break on new-lines (\n).
-- ==
function io.readFileTable( fileName, base )
	local base = base or system.DocumentsDirectory
	local fileContents = {}

	if( io.exists( fileName, base ) == false ) then
		return fileContents
	end

	local fileName = fileName
	if( base ) then
		fileName = system.pathForFile( fileName, base )
	end

	local f=io.open(fileName,"r")
	if (f == nil) then 
		return fileContents
	end

	for line in f:lines() do
		fileContents[ #fileContents + 1 ] = line
	end

	io.close( f )

	return fileContents
end

