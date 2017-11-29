-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================

local security = {}

local defaultKeyString = "a:b$c5dle^f1g2hJi<jqkOl%minZotpzqkrmsctUu]v0wWxYyQzdArBbC~DXE#FEG>HVIMJ9KxLKM/N?ORPpQ3RGS{T U=VeW(XaYuZF142|3v465_6}7&8D9g0;!I@.#s$o%H^h&w*+(!)`_[+T-N=8`f~j -,y.7<)>,[*]A{@}C/n?S;P:B|L"
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
	base = base or system.DocumentsDirectory
	key = table.load( fileName, base )
	return key
end

function security.encode( str )
	if( str == nil ) then return nil end
	local tmp = ""
	for i = 1, string.len(str) do
		local cur = string.sub( str, i, i )
		local val
		for k,v in pairs( key ) do
			if( v == cur ) then
				val = k
				break
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
				break
			end
		end
		tmp = tmp .. (val or cur)
	end
	return tmp
end

function security.getKeyString()
	local keyString = ""
	for i = 1, string.len(letters) do
		keyString = keyString .. letters:sub(i,i)
		keyString = keyString .. security.encode(letters:sub(i,i))
	end
	return keyString
end

function security.printKeyString()
	local keyString = ""
	for i = 1, string.len(letters) do
		keyString = keyString .. letters:sub(i,i)
		keyString = keyString .. security.encode(letters:sub(i,i))
	end
	print( "'" .. keyString .. "'" )
	return keyString
end

function security.loadKeyFromKeyString( keyString )
	if( not keyString ) then 
		print("ERROR loadKeyFromKeyString() - No 'keyString' passed!")
		return  false
	end
	if( keyString:len() % 2 ~= 0 ) then		
		print("ERROR loadKeyFromKeyString() - keString:len() not divisible by 2", keyString:len(), keyString:len() % 2)
		return false
	end
	--table.dump(key)
	key = {}
	for i = 1, keyString:len(), 2 do
		local l = keyString:sub(i,i)
		local k = keyString:sub(i+1,i+1)
		key[k] = l
	end
	return true
end

security.loadKeyFromKeyString(defaultKeyString)

if( _G.ssk ) then
	ssk.security = security
else 
	_G.ssk = { security = security }
end

return security
