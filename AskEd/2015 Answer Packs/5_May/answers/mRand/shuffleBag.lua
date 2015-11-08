local public = {}

local fullBag 		= {}
local castOffBag 	= {}


function public.insert( value )
	fullBag[#fullBag+1] = value
	public.shuffle()
end

local function shuffle( t, iter )
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

function public.shuffle()
	shuffle(fullBag)
end

function public.get()
	local value = fullBag[1]
	castOffBag[#castOffBag+1] = value
	table.remove( fullBag, 1 )
	if( #fullBag == 0 ) then
		fullBag = castOffBag
		castOffBag = {}
		shuffle(fullBag)
	end
	return value
end


return public