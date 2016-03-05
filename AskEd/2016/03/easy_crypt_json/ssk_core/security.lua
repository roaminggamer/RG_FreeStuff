local security = {}

local letters = "abcdefghijklmnopqrstuvwxyz"
letters = letters .. 
          string.upper( letters ) .. 
          "1234567890!@#$%^&*()_+-=`~ " ..
          ",.<>[]{}/?;:|"
local tmp = {}
local key = {}
function security.genKey()
	for i = 1, string.len(letters) do
		tmp[i] = string.sub( letters, i, i )
	end
	table.shuffle( tmp )
	for i = 1, string.len(letters) do
		key[tmp[i]] = string.sub( letters, i, i )
	end
	--table.dump(key)
end

function security.saveKey( fileName, base )
	base = base or system.DocumentsDirectory
	table.save( key, fileName, base)
end

function security.loadKey( fileName, base )
	base = base or system.ResourceDirectory
	key = table.load( fileName, base )
	return key
end

function security.loadJsonKey( jsonKey )
	local json = require "json"
	key = json.decode( jsonKey )
	return key
end

function security.printJsonKey()
	local json = require "json"
	local tmp =json.encode( key )
	print(tmp)
end

function security.encode( str )
	local tmp = ""
	for i = 1, string.len(str) do
		local cur = string.sub( str, i, i )
		local val
		for k,v in pairs( key ) do
			if( v == cur ) then
				val = k
			end
		end
		tmp = tmp .. (val or cur)
	end
	return tmp
end
function security.decode( str )
	local tmp = ""
	for i = 1, string.len(str) do
		local cur = string.sub( str, i, i )
		local val
		for k,v in pairs( key ) do
			if( k == cur ) then
				val = v
			end
		end
		tmp = tmp .. (val or cur)
	end
	return tmp
end

return security