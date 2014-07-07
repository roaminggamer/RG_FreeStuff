local function go( module )
	local mod = require( module )
	local i = 1
	while(debug.getlocal(2,i) ~= nil ) do
		local name,value = debug.getlocal(2,i)
		--print(name,value)
		if(mod[name] ~= nil) then
			--print("Found", name, mod[name] )
			debug.setlocal(2,i,mod[name])
		end
		i = i + 1
	end
end

local public = {}
public.go = go
return public