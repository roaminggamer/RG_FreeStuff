
local function doit()

	local billy = 10
	local i = 1
	while(debug.getlocal(1,i) ~= "i" ) do
		print(debug.getlocal(1,i))
		i = i + 1
		
	end
end

local function doit2()

	local billy = 10
	local i = 1
	while(debug.getlocal(2,i) ~= nil ) do
		print(debug.getlocal(2,i))
		i = i + 1
		
	end
end

local function doit3( module )

	local mod = require( module )

	local i = 1
	while(debug.getlocal(2,i) ~= nil ) do
		local name,value = debug.getlocal(2,i)
		print(name,value)
		if(mod[name] ~= nil) then
			print("Found", name, mod[name] )
			debug.setlocal(2,i,mod[name])
		end
		i = i + 1
	end
end


local public = {}
public.doit = doit
public.doit2 = doit2
public.doit3 = doit3
return public