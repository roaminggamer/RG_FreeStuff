local helpers = {}

helpers.shuffle = function( t, iter )
	local iter = iter or 1; local n
	for i = 1, iter do
		n = #t 
		while n >= 2 do
			local k = math.random(n); t[n], t[k] = t[k], t[n]; n = n - 1
		end
	end
	return t
end

return helpers