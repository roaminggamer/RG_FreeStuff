local thePlayer = {}

local maxInventoryEntries = 15
thePlayer.myInventory = {}

thePlayer.inventoryHasFreeEntries = function( self )
	local inv = self.myInventory
	local usedEntries = 0
	for k,v in pairs(inv) do usedEntries = usedEntries + 1 end
	--print(usedEntries)
	if( usedEntries < maxInventoryEntries ) then return true end
	return false
end		

thePlayer.inventoryAdd = function( self, item, count )
	local inv = self.myInventory
	inv[item] = (inv[item] or 0) + (count or 1)
end

thePlayer.inventoryRemove = function( self, item, count )
	-- Warning!  No safety check for removing more than we have.
	-- So, be safe!
	--
	local inv = self.myInventory
	inv[item] = (inv[item] or 0) - (count or 1)
	if( inv[item] < 0 ) then inv[item] = 0 end
end

thePlayer.inventoryCount = function( self, item )
	local count = count or 1
	local inv = self.myInventory
	return inv[item] or 0
end

thePlayer.inventoryHas = function( self, item, count )
	local count = count or 1
	local inv = self.myInventory
	if(inv[item] and inv[item] >= (count or 1) ) then return true end
	return false
end

thePlayer.getInventoryTable = function( self )
	local theTable = table.shallowCopy( self.myInventory )
	local function compare(a,b)
	  return tostring(a) < tostring(b)
	end
	local tmp = {}
	for n in pairs(theTable) do table.insert(tmp, n) end
	table.sort(tmp,compare)

	for i = 1, #tmp do
		local key = tmp[i]
		tmp[i] = { key, theTable[key] }
	end
	return tmp
end


return thePlayer

--[[

function table.dump(theTable, padding ) -- Sorted

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

]]