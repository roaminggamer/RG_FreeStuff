local allFuncs = {}

local function add( name, func )
	allFuncs[name] = func	
end

local function get( name )
	return allFuncs[name] or dummyFunc
end

local public = {}

public.add = add
public.get = get

return public